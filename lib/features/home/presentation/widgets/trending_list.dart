import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/manga_poster_card.dart';
import '../../../home/domain/manga.dart';
import 'section_header.dart';

/// Horizontal list of trending manga cards.
class TrendingList extends StatelessWidget {
  final List<Manga> mangas;

  const TrendingList({super.key, required this.mangas});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MangaAppColors>()!;

    final gradients = [
      colors.trendingBlue,
      colors.trendingRed,
      colors.trendingGreen,
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
            itemCount: mangas.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final manga = mangas[index];
              final gradient = gradients[index % gradients.length];
              return GestureDetector(
                onTap: () => context.push('/detail/${manga.id}'),
                child: MangaPosterCard(
                  title: manga.titleEn,
                  author: manga.author ?? '',
                  tag: 'MANGA',
                  rating: manga.rating?.toStringAsFixed(1) ?? '—',
                  chapter: manga.status,
                  gradientColors: gradient,
                  coverUrl: manga.coverUrl,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
