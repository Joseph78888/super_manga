import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/gradient_card.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../../home/domain/manga.dart';

/// Displays the featured mangas in a horizontally scrolling carousel.
class FeaturedCarousel extends StatefulWidget {
  final List<Manga> mangas;

  const FeaturedCarousel({super.key, required this.mangas});

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.93);
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.mangas.isEmpty) return const SizedBox.shrink();

    final colors = Theme.of(context).extension<MangaAppColors>()!;

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.mangas.length,
            itemBuilder: (context, index) {
              final manga = widget.mangas[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
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
                              errorWidget: (_, __, ___) =>
                                  const SizedBox.shrink(),
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
                                    backgroundColor: Colors.black.withOpacity(
                                      0.4,
                                    ),
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
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(
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
              );
            },
          ),
        ),

        // Page indicators
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.mangas.length,
            (index) => _buildDot(index == _currentPage),
          ),
        ),
      ],
    );
  }

  Widget _buildDot(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
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
