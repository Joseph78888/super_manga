import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'gradient_card.dart';
import 'pill_badge.dart';

/// Reusable poster card for manga lists.
class MangaPosterCard extends StatelessWidget {
  final String title;
  final String author;
  final String tag;
  final String rating;
  final String chapter;
  final List<Color> gradientColors;
  final double? width;
  final double? height;

  /// Optional network cover image; falls back to gradient if null or fails.
  final String? coverUrl;

  const MangaPosterCard({
    super.key,
    required this.title,
    required this.author,
    required this.tag,
    required this.rating,
    required this.chapter,
    required this.gradientColors,
    this.width = 140,
    this.height,
    this.coverUrl,
  });

  @override
  Widget build(BuildContext context) {
    return GradientCard(
      width: width,
      height: height,
      padding: EdgeInsets.zero,
      gradientColors: gradientColors,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Stack(
          children: [
            // Cover image (if available)
            if (coverUrl != null && coverUrl!.isNotEmpty)
              Positioned.fill(
                child: CachedNetworkImage(
                  imageUrl: coverUrl!,
                  fit: BoxFit.cover,
                  color: Colors.black.withOpacity(0.35),
                  colorBlendMode: BlendMode.darken,
                  errorWidget: (_, __, ___) => const SizedBox.shrink(),
                ),
              )
            else
              Positioned.fill(
                child: Opacity(
                  opacity: 0.1,
                  child: CustomPaint(painter: _DiagonalStripePainter()),
                ),
              ),

            // Text overlay
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PillBadge(
                    text: tag,
                    backgroundColor: Colors.black.withOpacity(0.4),
                  ),
                  const Spacer(),
                  Text(
                    title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    author,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        rating,
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Expanded(
                        child: Text(
                          '• $chapter',
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DiagonalStripePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    const spacing = 15.0;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
