import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import 'section_header.dart';
import 'package:intl/intl.dart';

class RecentlyUpdatedList extends StatelessWidget {
  const RecentlyUpdatedList({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MangaAppColors>()!;
    
    // Mock Data
    final recentItems = [
      {
        'title': 'Shadow Monarch',
        'author': 'Chugong',
        'chapter': 'Ch.179',
        'time': '2h ago',
        'color': colors.trendingBlue.first,
        'hasUpdate': true,
      },
      {
        'title': 'Iron Fist Chronicles',
        'author': 'Gege Akutami',
        'chapter': 'Ch.236',
        'time': '12h ago',
        'color': colors.trendingGreen.first,
        'hasUpdate': true,
      },
      {
        'title': 'Crimson Blade Chronicles',
        'author': 'Hajime Isayama',
        'chapter': 'Ch.139',
        'time': '1d ago',
        'color': colors.trendingRed.first,
        'hasUpdate': false,
      },
      {
        'title': 'Infinite Dungeon',
        'author': 'Kim Dae-Jin',
        'chapter': 'Ch.94',
        'time': '2d ago',
        'color': colors.featuredGradient.first,
        'hasUpdate': false,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: 'Recently Updated',
          onActionTap: () {},
        ),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          itemCount: recentItems.length,
          separatorBuilder: (context, index) => const Divider(
            height: 32,
            color: Colors.white10,
          ),
          itemBuilder: (context, index) {
            final item = recentItems[index];
            return _buildUpdateTile(context, item);
          },
        ),
      ],
    );
  }

  Widget _buildUpdateTile(BuildContext context, Map<String, dynamic> item) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Placeholder Image (Solid Color with text)
        Container(
          width: 70,
          height: 70,
          decoration: BoxDecoration(
            color: item['color'] as Color,
            borderRadius: BorderRadius.circular(12),
          ),
          alignment: Alignment.center,
          padding: const EdgeInsets.all(8),
          child: Text(
            item['title'] as String,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(width: 16),
        
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item['title'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                item['author'] as String,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Text(
                    item['chapter'] as String,
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary, // using seed color purple
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    item['time'] as String,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Update Indicator Map
        if (item['hasUpdate'] == true)
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF42E0AE), // Green indicator
              shape: BoxShape.circle,
            ),
          )
        else
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Colors.white10,
              shape: BoxShape.circle,
            ),
          ),
      ],
    );
  }
}
