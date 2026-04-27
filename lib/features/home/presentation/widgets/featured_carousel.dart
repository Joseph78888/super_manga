import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/gradient_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../home/domain/manga.dart';

/// Displays the first manga in the list as a featured hero card.
class FeaturedCarousel extends StatelessWidget {
  final Manga manga;

  const FeaturedCarousel({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MangaAppColors>()!;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          child: GestureDetector(
            onTap: () => context.push('/detail/${manga.id}'),
            child: GradientCard(
              height: 220,
              gradientColors: colors.featuredGradient,
              child: Stack(
                children: [
                  // Cover image as background
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: manga.coverUrl,
                        fit: BoxFit.cover,
                        color: Colors.black.withOpacity(0.55),
                        colorBlendMode: BlendMode.darken,
                        errorWidget: (_, __, ___) => const SizedBox.shrink(),
                      ),
                    ),
                  ),

                  // Content overlay
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const PillBadge(text: 'FEATURED'),
                          if (manga.rating != null)
                            PillBadge(
                              text: manga.rating!.toStringAsFixed(1),
                              backgroundColor: Colors.black.withOpacity(0.4),
                              textColor: Colors.amber,
                            ),
                        ],
                      ),
                      const Spacer(),
                      PillBadge(
                        text: manga.status.toUpperCase(),
                        backgroundColor: Colors.white24,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        manga.titleEn,
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                      ),
                      if (manga.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          manga.description!,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 13,
                            height: 1.4,
                          ),
                        ),
                      ],
                      const SizedBox(height: 16),
                      if (manga.author != null)
                        Text(
                          manga.author!,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.6),
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),

        // Page indicator (single dot for single manga)
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildDot(true),
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
