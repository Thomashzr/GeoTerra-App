#!/usr/bin/env python3
import os
import math
import wave
import struct
import subprocess
import tempfile
import glob

SAMPLE_RATE = 44100

def create_wav_file(filename, samples):
    with wave.open(filename, 'w') as wav:
        wav.setnchannels(1)  # Mono
        wav.setsampwidth(2)  # 16-bit
        wav.setframerate(SAMPLE_RATE)
        packed_data = bytearray()
        for s in samples:
            clamped = max(-1.0, min(1.0, s))
            int_sample = int(clamped * 32767.0)
            packed_data.extend(struct.pack('<h', int_sample))
        wav.writeframes(packed_data)

def generate_success(output_wav):
    # Arpeggio C5, E5, G5, C6
    notes = [
        (523.25, 0.08),  # C5
        (659.25, 0.08),  # E5
        (783.99, 0.08),  # G5
        (1046.50, 0.20), # C6
    ]
    samples = []
    for freq, duration in notes:
        n_samples = int(duration * SAMPLE_RATE)
        for i in range(n_samples):
            t = i / SAMPLE_RATE
            progress = i / n_samples
            env = (1.0 - progress) ** 1.5 if duration > 0.1 else (1.0 - progress * 0.5)
            attack = min(1.0, i / (SAMPLE_RATE * 0.008))
            val = (0.7 * math.sin(2 * math.pi * freq * t) +
                   0.3 * math.sin(4 * math.pi * freq * t)) * attack * env * 0.8
            samples.append(val)
    create_wav_file(output_wav, samples)

def generate_error(output_wav):
    # Dissonant descending buzz
    duration = 0.28
    n_samples = int(duration * SAMPLE_RATE)
    samples = []
    for i in range(n_samples):
        t = i / SAMPLE_RATE
        progress = i / n_samples
        env = (1.0 - progress) ** 1.2
        attack = min(1.0, i / (SAMPLE_RATE * 0.01))
        # Mix 180Hz and 130Hz with slight distortion
        f1 = 180.0 - 40.0 * progress
        f2 = 135.0 - 30.0 * progress
        val = 0.5 * math.sin(2 * math.pi * f1 * t) + 0.4 * math.sin(2 * math.pi * f2 * t)
        # soft clip
        val = math.tanh(val * 1.5) * 0.7 * attack * env
        samples.append(val)
    create_wav_file(output_wav, samples)

def generate_tick(output_wav):
    # Short crisp click/tick
    duration = 0.04
    n_samples = int(duration * SAMPLE_RATE)
    samples = []
    for i in range(n_samples):
        t = i / SAMPLE_RATE
        progress = i / n_samples
        freq = 1200.0 * math.exp(-progress * 5.0)
        env = math.exp(-progress * 25.0)
        val = math.sin(2 * math.pi * freq * t) * env * 0.6
        samples.append(val)
    create_wav_file(output_wav, samples)

def generate_game_over(output_wav):
    # Sad descending motif
    notes = [
        (392.00, 0.16),  # G4
        (329.63, 0.16),  # E4
        (261.63, 0.20),  # C4
        (196.00, 0.40),  # G3
    ]
    samples = []
    for freq, duration in notes:
        n_samples = int(duration * SAMPLE_RATE)
        for i in range(n_samples):
            t = i / SAMPLE_RATE
            progress = i / n_samples
            env = (1.0 - progress) ** 1.3
            attack = min(1.0, i / (SAMPLE_RATE * 0.012))
            val = (0.75 * math.sin(2 * math.pi * freq * t) +
                   0.25 * math.sin(3 * math.pi * freq * t)) * attack * env * 0.75
            samples.append(val)
    create_wav_file(output_wav, samples)

def convert_wav_to_mp3(wav_path, mp3_path):
    cmd = [
        "ffmpeg", "-y", "-i", wav_path,
        "-codec:a", "libmp3lame", "-b:a", "128k",
        mp3_path
    ]
    result = subprocess.run(cmd, stdout=subprocess.DEVNULL, stderr=subprocess.PIPE)
    if result.returncode != 0:
        error_msg = result.stderr.decode('utf-8', errors='ignore')
        raise RuntimeError(f"FFmpeg conversion failed for {mp3_path}:\n{error_msg}")

def main():
    root_dir = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
    audio_dir = os.path.join(root_dir, "assets", "audio")
    os.makedirs(audio_dir, exist_ok=True)

    # Clean up any leftover WAV files to ensure only MP3s are bundled
    for wav_file in glob.glob(os.path.join(audio_dir, "*.wav")):
        try:
            os.remove(wav_file)
            print(f"Removed redundant WAV: {wav_file}")
        except OSError:
            pass

    sounds = [
        ("success", generate_success),
        ("error", generate_error),
        ("tick", generate_tick),
        ("game_over", generate_game_over),
    ]

    for name, generator in sounds:
        mp3_path = os.path.join(audio_dir, f"{name}.mp3")
        with tempfile.NamedTemporaryFile(suffix=".wav", delete=False) as temp_wav:
            temp_wav_path = temp_wav.name

        try:
            generator(temp_wav_path)
            convert_wav_to_mp3(temp_wav_path, mp3_path)
            print(f"Generated MP3: {mp3_path} ({os.path.getsize(mp3_path)} bytes)")
        finally:
            if os.path.exists(temp_wav_path):
                os.remove(temp_wav_path)

    print("All audio assets successfully generated in MP3 format.")

if __name__ == "__main__":
    main()
