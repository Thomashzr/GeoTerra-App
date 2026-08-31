import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlagCard extends StatelessWidget {
  const FlagCard({required this.assetPath, super.key});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const borderRadius = BorderRadius.all(Radius.circular(20));

    return Semantics(
          image: true,
          label: 'Bandera a identificar',
          child: AspectRatio(
            aspectRatio: 3 / 2,
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: borderRadius,
                border: Border.all(color: colorScheme.outlineVariant, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(2),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(18)),
                  child: SvgPicture.asset(
                    assetPath,
                    fit: BoxFit.cover,
                    excludeFromSemantics: true,
                  ),
                ),
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(duration: 250.ms)
        .scale(
          begin: const Offset(0.82, 0.82),
          end: const Offset(1, 1),
          duration: 700.ms,
          curve: Curves.elasticOut,
        );
  }
}
