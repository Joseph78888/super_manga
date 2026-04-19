import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'gradient_card.dart';
import 'pill_badge.dart';

class MangaPosterCard extends StatelessWidget {
  final String title;
  final String author;
  final String tag; // MANHWA, MANGA, MANHUA
  final String rating;
  final String chapter;
  final List<Color> gradientColors;
  final double? width;
  final double? height;

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
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/detail'),
      child: GradientCard(
        width: width,
      height: height,
      padding: const EdgeInsets.all(16),
      gradientColors: gradientColors,
      child: Stack(
        children: [
          // Optional diagonal effect
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(
                painter: _DiagonalStripePainter(),
              ),
            ),
          ),
          
          Column(
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
                  fontSize: 15,
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
                  fontSize: 12,
                ),
              ),
              const SizedBox(height: 16),
              // Bottom gradient to ensure text readability / Bottom text
              Row(
                children: [
                   Expanded(child: Text(title, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis,)),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    rating,
                    style: const TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      '•  $chapter',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: Colors.white.withOpacity(0.8), fontSize: 12),
                    ),
                  ),
                ],
              ),
            ],
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
    var paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
      
    double spacing = 15;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
