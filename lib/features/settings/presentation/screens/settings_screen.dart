import 'package:flutter/material.dart';

import '../../../../core/widgets/atlas_scaffold.dart';

/// Presentational settings view. Persistence and application state are injected
/// by the route/composition layer, keeping this widget easy to reuse and test.
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({
    required this.volume,
    required this.isMuted,
    required this.language,
    required this.themeMode,
    required this.onVolumeChanged,
    required this.onMutedChanged,
    required this.onLanguageChanged,
    required this.onThemeModeChanged,
    this.onBack,
    super.key,
  });

  final double volume;
  final bool isMuted;
  final String language;
  final ThemeMode themeMode;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<bool> onMutedChanged;
  final ValueChanged<String> onLanguageChanged;
  final ValueChanged<ThemeMode> onThemeModeChanged;
  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final padding = MediaQuery.sizeOf(context).width >= 600 ? 48.0 : 24.0;
    final effectiveVolume = volume.clamp(0.0, 1.0).toDouble();

    return AtlasScaffold(
      coordinate: 'PREFERENCIAS · 01',
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 640),
          child: ListView(
            padding: EdgeInsets.fromLTRB(padding, 16, padding, 40),
            children: [
              Row(
                children: [
                  Semantics(
                    label: 'Volver',
                    button: true,
                    child: IconButton(
                      onPressed:
                          onBack ?? () => Navigator.of(context).maybePop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      tooltip: 'Volver',
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Ajustes',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(
                            fontFamily: 'serif',
                            fontWeight: FontWeight.w700,
                            letterSpacing: -.5,
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'PERSONALIZA TU EXPEDICIÓN',
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colors.tertiary,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.3,
                ),
              ),
              const SizedBox(height: 32),
              const _SectionLabel(
                icon: Icons.volume_up_outlined,
                label: 'Sonido',
              ),
              const SizedBox(height: 12),
              _SettingsPanel(
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            isMuted ? 'Audio desactivado' : 'Volumen',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                          ),
                        ),
                        Text(
                          '${(effectiveVolume * 100).round()}%',
                          style: _dataStyle(context),
                        ),
                      ],
                    ),
                    Slider(
                      value: isMuted ? 0 : effectiveVolume,
                      onChanged: onVolumeChanged,
                      semanticFormatterCallback: (value) =>
                          '${(value * 100).round()} por ciento',
                    ),
                    const Divider(),
                    SwitchListTile.adaptive(
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Silenciar sonidos'),
                      value: isMuted,
                      onChanged: onMutedChanged,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),
              const _SectionLabel(
                icon: Icons.language_rounded,
                label: 'Idioma',
              ),
              const SizedBox(height: 12),
              _SettingsPanel(
                child: DropdownButtonFormField<String>(
                  initialValue: language == 'es' ? language : 'es',
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.translate_rounded),
                    labelText: 'Idioma de la aplicación',
                  ),
                  items: const [
                    DropdownMenuItem(value: 'es', child: Text('Español')),
                  ],
                  onChanged: (value) {
                    if (value != null) onLanguageChanged(value);
                  },
                ),
              ),
              const SizedBox(height: 28),
              const _SectionLabel(
                icon: Icons.light_mode_outlined,
                label: 'Apariencia',
              ),
              const SizedBox(height: 12),
              _SettingsPanel(
                child: LayoutBuilder(
                  builder: (context, constraints) => SegmentedButton<ThemeMode>(
                    direction: constraints.maxWidth < 420
                        ? Axis.vertical
                        : Axis.horizontal,
                    showSelectedIcon: false,
                    segments: const [
                      ButtonSegment(
                        value: ThemeMode.system,
                        label: Text('Sistema'),
                        icon: Icon(Icons.brightness_auto_rounded),
                      ),
                      ButtonSegment(
                        value: ThemeMode.light,
                        label: Text('Claro'),
                        icon: Icon(Icons.light_mode_rounded),
                      ),
                      ButtonSegment(
                        value: ThemeMode.dark,
                        label: Text('Oscuro'),
                        icon: Icon(Icons.dark_mode_rounded),
                      ),
                    ],
                    selected: {themeMode},
                    onSelectionChanged: (selection) =>
                        onThemeModeChanged(selection.first),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  TextStyle? _dataStyle(BuildContext context) =>
      Theme.of(context).textTheme.labelLarge?.copyWith(
        color: Theme.of(context).colorScheme.tertiary,
        fontFamily: 'monospace',
        fontWeight: FontWeight.w700,
      );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) => Row(
    children: [
      Icon(icon, size: 20, color: Theme.of(context).colorScheme.tertiary),
      const SizedBox(width: 8),
      Text(
        label.toUpperCase(),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          fontFamily: 'monospace',
          fontWeight: FontWeight.w700,
          letterSpacing: 1.1,
        ),
      ),
    ],
  );
}

class _SettingsPanel extends StatelessWidget {
  const _SettingsPanel({required this.child});
  final Widget child;
  @override
  Widget build(BuildContext context) => Material(
    color: Theme.of(context).colorScheme.surfaceContainer.withValues(alpha: .9),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: BorderSide(color: Theme.of(context).colorScheme.outlineVariant),
    ),
    clipBehavior: Clip.antiAlias,
    child: Padding(padding: const EdgeInsets.all(16), child: child),
  );
}
