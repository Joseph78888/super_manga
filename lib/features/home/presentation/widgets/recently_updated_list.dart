import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../home/domain/manga.dart';
import 'section_header.dart';

/// Vertical list of recently added/updated manga.
class RecentlyUpdatedList extends StatelessWidget {
  final List<Manga> mangas;

  const RecentlyUpdatedList({super.key, required this.mangas});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(title: 'Recently Added', onActionTap: () {}),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
          itemCount: mangas.length,
          separatorBuilder: (_, __) => const Divider(
            height: 32,
            color: Colors.white10,
          ),
          itemBuilder: (context, index) {
            return _MangaTile(manga: mangas[index]);
          },
        ),
      ],
    );
  }
}

class _MangaTile extends StatelessWidget {
  final Manga manga;

  const _MangaTile({required this.manga});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/detail/${manga.id}'),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Cover image thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CachedNetworkImage(
              imageUrl: manga.coverUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              placeholder: (_, __) => Container(
                width: 70,
                height: 70,
                color: const Color(0xFF1E1A33),
                alignment: Alignment.center,
                child: const CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: const Color(0xFF1E1A33),
                alignment: Alignment.center,
                child: Text(
                  manga.titleEn,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                  manga.titleEn,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                if (manga.titleAr.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    manga.titleAr,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.4),
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                if (manga.author != null)
                  Text(
                    manga.author!,
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
                      manga.status,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                    if (manga.rating != null) ...[
                      const SizedBox(width: 8),
                      const Icon(Icons.star, color: Colors.amber, size: 12),
                      const SizedBox(width: 2),
                      Text(
                        manga.rating!.toStringAsFixed(1),
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.5),
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),

          // New indicator
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF42E0AE),
              shape: BoxShape.circle,
            ),
          ),
        ],
      ),
    );
  }
}
