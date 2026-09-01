import 'package:flutter/material.dart';

import '../../../../core/widgets/atlas_scaffold.dart';

/// Entry point for the game. It deliberately owns only presentation concerns;
/// navigation can be overridden by the app router or by tests.
class HomeScreen extends StatelessWidget {
  const HomeScreen({this.onPlay, this.onSettings, super.key});

  final VoidCallback? onPlay;
  final VoidCallback? onSettings;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final play = onPlay ?? () {};
    final settings = onSettings ?? () {};

    return AtlasScaffold(
      coordinate: '34°36′S · 58°22′O',
      child: LayoutBuilder(
        builder: (context, constraints) {
          final horizontalPadding = constraints.maxWidth >= 600 ? 48.0 : 24.0;
          return Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 560),
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  28,
                  horizontalPadding,
                  40,
                ),
                child: SizedBox(
                  height: (constraints.maxHeight - 68)
                      .clamp(520.0, 760.0)
                      .toDouble(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Spacer(),
                      Semantics(
                        label: 'Globo terráqueo de GeoQuiz',
                        image: true,
                        child: Container(
                          width: 118,
                          height: 118,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colors.primaryContainer.withValues(
                              alpha: .72,
                            ),
                            border: Border.all(
                              color: colors.primary,
                              width: 1.4,
                            ),
                          ),
                          child: Icon(
                            Icons.public_rounded,
                            size: 74,
                            color: colors.primary,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'GeoQuiz',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.displaySmall
                            ?.copyWith(
                              color: colors.onSurface,
                              fontFamily: 'serif',
                              fontWeight: FontWeight.w700,
                              letterSpacing: -.8,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'ATLAS EN JUEGO',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colors.tertiary,
                          fontFamily: 'monospace',
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.8,
                        ),
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Pon a prueba tus conocimientos del mundo',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(color: colors.onSurfaceVariant),
                      ),
                      const SizedBox(height: 42),
                      FilledButton.icon(
                        onPressed: play,
                        icon: const Icon(Icons.explore_rounded),
                        label: const Text('Comenzar expedición'),
                      ),
                      const SizedBox(height: 12),
                      OutlinedButton.icon(
                        onPressed: settings,
                        icon: const Icon(Icons.tune_rounded),
                        label: const Text('Ajustes de viaje'),
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
                      Text(
                        'APRENDE · JUEGA · DESCUBRE',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: colors.onSurfaceVariant,
                              fontFamily: 'monospace',
                              letterSpacing: 1.15,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
