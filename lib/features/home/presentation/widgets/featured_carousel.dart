import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/gradient_card.dart';
import '../../../../core/widgets/pill_badge.dart';

class FeaturedCarousel extends StatelessWidget {
  const FeaturedCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MangaAppColors>()!;
    
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: GestureDetector(
            onTap: () => context.push('/detail'),
            child: GradientCard(
              height: 220,
              gradientColors: colors.featuredGradient,
            child: Stack(
              children: [
                // Diagonal lines placeholder (optional effect overlay)
                Positioned.fill(
                  child: Opacity(
                    opacity: 0.1,
                    child: CustomPaint(
                      painter: _DiagonalStripePainter(),
                    ),
                  ),
                ),
                
                // Content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const PillBadge(text: 'FEATURED'),
                        PillBadge(
                          text: '4.9',
                          backgroundColor: Colors.black.withOpacity(0.4),
                          textColor: Colors.amber,
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        const PillBadge(text: 'Action', backgroundColor: Colors.white24,),
                        const SizedBox(width: 8),
                        const PillBadge(text: 'Fantasy', backgroundColor: Colors.white24,),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Shadow Monarch',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'The weakest hunter of all mankind. Sung Jin-Woo, a man who has had to battle constantly just to stay alive. One d...',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Text('179 ch', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                        const SizedBox(width: 16),
                        Text('52.3M', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                        const SizedBox(width: 16),
                        Text('ongoing', style: TextStyle(color: Colors.white.withOpacity(0.6), fontSize: 12)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        ),
        
        // Page Indicator
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDot(true),
            _buildDot(false),
            _buildDot(false),
            _buildDot(false),
          ],
        ),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3),
      width: isActive ? 16 : 6,
      height: 6,
      decoration: BoxDecoration(
        color: isActive ? AppTheme.accentRed : Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(4),
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
      
    double spacing = 20;
    for (double i = -size.height; i < size.width; i += spacing) {
      canvas.drawLine(Offset(i, 0), Offset(i + size.height, size.height), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
