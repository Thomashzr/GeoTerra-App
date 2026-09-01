import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Entry point for the game. It deliberately owns only presentation concerns;
/// navigation can be overridden by the app router or by tests.
class HomeScreen extends StatelessWidget {
  const HomeScreen({this.onPlay, this.onSettings, super.key});

  final VoidCallback? onPlay;
  final VoidCallback? onSettings;

  void _showSettings(BuildContext context) {
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Ajustes',
                style: Theme.of(context).textTheme.headlineSmall
                    ?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 8),
              const Text('Los ajustes estarán disponibles próximamente.'),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Cerrar'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final play = onPlay ?? () => context.go('/quiz');
    final settings = onSettings ?? () => _showSettings(context);

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth >= 600 ? 48.0 : 24.0;
            return SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                32,
                horizontalPadding,
                24,
              ),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      Semantics(
                        label: 'Globo terráqueo de GeoQuiz',
                        image: true,
                        child: Icon(
                          Icons.public_rounded,
                          size: 104,
                          color: colors.primary,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'GeoQuiz',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: colors.primary,
                              fontWeight: FontWeight.w900,
                              letterSpacing: -1,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Pon a prueba tus conocimientos del mundo',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 40),
                      FilledButton.icon(
                        onPressed: play,
                        icon: const Icon(Icons.play_arrow_rounded),
                        label: const Text('Jugar'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: settings,
                        icon: const Icon(Icons.settings_rounded),
                        label: const Text('Ajustes'),
                      ),
                      const SizedBox(height: 12),
                      Tooltip(
                        message:
                            'El reto diario estará disponible próximamente',
                        child: OutlinedButton.icon(
                          onPressed: null,
                          icon: const Icon(Icons.calendar_today_rounded),
                          label: const Text('Reto diario'),
                        ),
                      ),
                      const Spacer(),
                      const SizedBox(height: 32),
                      Text(
                        'Aprende. Juega. Descubre.',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.bodyMedium
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Temporary destination kept behind a route so settings can become a full
/// screen without changing the public navigation contract.
class SettingsPlaceholderScreen extends StatelessWidget {
  const SettingsPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ajustes')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.settings_rounded, size: 64),
              const SizedBox(height: 16),
              Text(
                'Los ajustes estarán disponibles próximamente.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: () => context.pop(),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
