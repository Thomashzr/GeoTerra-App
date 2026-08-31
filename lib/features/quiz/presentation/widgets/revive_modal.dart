import 'package:flutter/material.dart';

import '../../../../core/services/ad_service.dart';

class ReviveModal extends StatefulWidget {
  const ReviveModal({
    required this.adService,
    required this.onRevived,
    required this.onFinished,
    super.key,
  });

  final IAdService adService;
  final VoidCallback onRevived;
  final VoidCallback onFinished;

  @override
  State<ReviveModal> createState() => _ReviveModalState();
}

class _ReviveModalState extends State<ReviveModal> {
  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _requestRevive() async {
    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final wasRewarded = await widget.adService.showRewardedAd();
      if (!mounted) {
        return;
      }

      if (wasRewarded) {
        setState(() {
          _isLoading = false;
        });
        widget.onRevived();
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage =
            'El anuncio no se completó. Puedes intentarlo de nuevo.';
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
        _errorMessage = 'No pudimos mostrar el anuncio. Inténtalo nuevamente.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return PopScope(
      canPop: false,
      child: AlertDialog(
        icon: Icon(
          Icons.favorite_rounded,
          color: Colors.red.shade600,
          size: 48,
        ),
        title: const Text('¿Quieres continuar?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Mira un anuncio recompensado para recuperar una vida y seguir jugando.',
              textAlign: TextAlign.center,
            ),
            if (_errorMessage case final errorMessage?) ...[
              const SizedBox(height: 16),
              Semantics(
                liveRegion: true,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.error_outline_rounded, color: colorScheme.error),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        errorMessage,
                        style: TextStyle(color: colorScheme.error),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actionsOverflowAlignment: OverflowBarAlignment.center,
        actionsOverflowButtonSpacing: 8,
        actions: [
          FilledButton.icon(
            onPressed: _isLoading ? null : _requestRevive,
            icon: _isLoading
                ? const SizedBox.square(
                    dimension: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.ondemand_video_rounded),
            label: Text(
              _isLoading
                  ? 'Cargando anuncio…'
                  : 'Ver un anuncio para continuar con 1 vida extra',
              textAlign: TextAlign.center,
            ),
          ),
          OutlinedButton(
            onPressed: _isLoading ? null : widget.onFinished,
            child: const Text('Terminar partida'),
          ),
        ],
      ),
    );
  }
}
