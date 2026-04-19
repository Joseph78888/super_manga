import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/manga_poster_card.dart';
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
        'title': 'Crimson Blade Chronicles',
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
        SectionHeader(
          title: 'Trending Now',
          onActionTap: () {},
        ),
        SizedBox(
          height: 200,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            scrollDirection: Axis.horizontal,
            itemCount: trendingItems.length,
            separatorBuilder: (context, index) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              final item = trendingItems[index];
              return MangaPosterCard(
                title: item['title'] as String,
                author: item['author'] as String,
                tag: item['tag'] as String,
                rating: item['rating'] as String,
                chapter: item['chapter'] as String,
                gradientColors: item['gradient'] as List<Color>,
              );
            },
          ),
        ),
      ],
    );
  }
}
