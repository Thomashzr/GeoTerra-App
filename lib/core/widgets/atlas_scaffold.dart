import 'package:flutter/material.dart';

/// Shared field-atlas canvas for the app's principal screens.
///
/// The painted grid and meridians identify the product without competing with
/// the interactive content layered above them.
class AtlasScaffold extends StatelessWidget {
  const AtlasScaffold({
    required this.child,
    this.coordinate = '34°36′S · 58°22′O',
    super.key,
  });

  final Widget child;
  final String coordinate;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: ExcludeSemantics(
              child: CustomPaint(
                painter: _AtlasBackgroundPainter(
                  paper: colors.surface,
                  ink: colors.onSurface,
                  meridian: colors.tertiary,
                ),
              ),
            ),
          ),
          SafeArea(
            child: Stack(
              children: [
                child,
                Positioned(
                  right: 20,
                  bottom: 14,
                  child: IgnorePointer(
                    child: ExcludeSemantics(
                      child: Text(
                        coordinate.toUpperCase(),
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colors.onSurfaceVariant.withValues(alpha: .62),
                          fontFamily: 'monospace',
                          fontFeatures: const [FontFeature.tabularFigures()],
                          letterSpacing: 1.1,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AtlasBackgroundPainter extends CustomPainter {
  const _AtlasBackgroundPainter({
    required this.paper,
    required this.ink,
    required this.meridian,
  });

  final Color paper;
  final Color ink;
  final Color meridian;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(paper, BlendMode.src);
    final gridPaint = Paint()
      ..color = ink.withValues(alpha: .055)
      ..strokeWidth = 1;
    const spacing = 40.0;
    for (var x = 0.0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), gridPaint);
    }
    for (var y = 0.0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gridPaint);
    }

    final arcPaint = Paint()
      ..color = meridian.withValues(alpha: .16)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    final arcBounds = Rect.fromCenter(
      center: Offset(size.width * .86, size.height * .1),
      width: size.width * 1.25,
      height: size.width * 1.25,
    );
    canvas.drawArc(arcBounds, 1.8, 2.35, false, arcPaint);
    canvas.drawArc(arcBounds.inflate(-28), 1.8, 2.35, false, arcPaint);

    final markerPaint = Paint()
      ..color = meridian.withValues(alpha: .72)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.4;
    const marker = Offset(24, 24);
    canvas.drawCircle(marker, 5, markerPaint);
    canvas.drawLine(
      marker + const Offset(-10, 0),
      marker + const Offset(10, 0),
      markerPaint,
    );
    canvas.drawLine(
      marker + const Offset(0, -10),
      marker + const Offset(0, 10),
      markerPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _AtlasBackgroundPainter oldDelegate) {
    return paper != oldDelegate.paper ||
        ink != oldDelegate.ink ||
        meridian != oldDelegate.meridian;
  }
}
