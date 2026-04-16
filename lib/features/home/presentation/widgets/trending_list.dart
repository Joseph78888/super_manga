import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/gradient_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import 'section_header.dart'; // We can include the header in the same file or module

class TrendingList extends StatelessWidget {
  const TrendingList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MangaAppColors>()!;

    // Mock Data
    final trendingItems = [
      {
        'title': 'Shadow Monarch',
        'author': 'Chugong',
        'tag': 'MANHWA',
        'rating': '4.9',
        'chapter': 'Ch.179',
        'gradient': colors.trendingBlue,
      },
      {
        'title': 'Crimson Blade',
        'author': 'Hajime Isayama',
        'tag': 'MANGA',
        'rating': '4.8',
        'chapter': 'Ch.139',
        'gradient': colors.trendingRed,
      },
      {
        'title': 'Infinite Dungeon',
        'author': 'Kim Dae-Jin',
        'tag': 'MANHWA',
        'rating': '4.7',
        'chapter': 'Ch.94',
        'gradient': colors.trendingGreen,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Trending Now', onActionTap: () {}),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: trendingItems.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = trendingItems[index];
              return _buildTrendingCard(context, item);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTrendingCard(BuildContext context, Map<String, dynamic> item) {
    return GradientCard(
      width: 140,
      padding: const EdgeInsets.all(16),
      gradientColors: item['gradient'] as List<Color>,
      child: Stack(
        children: [
          // Optional diagonal effect
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: CustomPaint(painter: _DiagonalStripePainter()),
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              PillBadge(
                text: item['tag'] as String,
                backgroundColor: Colors.black.withOpacity(0.4),
              ),
              const Spacer(),
              Text(
                item['title'] as String,
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
                item['author'] as String,
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
                  Text(
                    item['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    item['rating'] as String,
                    style: const TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '•  ${item['chapter']}',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
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
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
