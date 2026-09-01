import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/flutter_svg.dart';

class FlagCard extends StatelessWidget {
  const FlagCard({required this.assetPath, super.key});

  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    const borderRadius = BorderRadius.all(Radius.circular(18));
    final card = Semantics(
      image: true,
      label: 'Bandera a identificar',
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surfaceContainer,
          borderRadius: borderRadius,
          border: Border.all(color: colors.tertiary.withValues(alpha: .58)),
          boxShadow: [
            BoxShadow(
              color: colors.shadow.withValues(alpha: .12),
              blurRadius: 16,
              offset: const Offset(0, 7),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: ClipRRect(
            borderRadius: const BorderRadius.all(Radius.circular(13)),
            child: AspectRatio(
              aspectRatio: 3 / 2,
              child: SvgPicture.asset(
                assetPath,
                fit: BoxFit.cover,
                excludeFromSemantics: true,
              ),
            ),
          ),
        ),
      ),
    );

    if (MediaQuery.disableAnimationsOf(context)) return card;
    return card
        .animate()
        .fadeIn(duration: 220.ms)
        .scale(
          begin: const Offset(.96, .96),
          end: const Offset(1, 1),
          duration: 380.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
