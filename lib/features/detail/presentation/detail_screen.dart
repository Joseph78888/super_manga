import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/pill_badge.dart';
import '../../home/data/datasources/manga_remote_data_source.dart';
import '../../home/data/datasources/chapter_remote_data_source.dart';
import '../../home/data/repositories/manga_repository.dart';
import '../../home/data/repositories/chapter_repository.dart';
import '../../home/domain/manga.dart';
import '../../home/domain/chapter.dart';
import 'cubit/detail_cubit.dart';
import 'cubit/detail_state.dart';

class DetailScreen extends StatelessWidget {
  final String mangaId;

  const DetailScreen({super.key, required this.mangaId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DetailCubit(
        mangaRepository: MangaRepository(
          dataSource: SupabaseMangaRemoteDataSource(
            supabaseClient: Supabase.instance.client,
          ),
        ),
        chapterRepository: ChapterRepository(
          dataSource: SupabaseChapterRemoteDataSource(
            supabaseClient: Supabase.instance.client,
          ),
        ),
      )..loadDetail(mangaId),
      child: const _DetailView(),
    );
  }
}

class _DetailView extends StatelessWidget {
  const _DetailView();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DetailCubit, DetailState>(
      builder: (context, state) {
        if (state.isLoading) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        if (state.error != null) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
              child: Text(
                'Failed to load: ${state.error}',
                style: TextStyle(color: Colors.white.withOpacity(0.6)),
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        final manga = state.manga;
        if (manga == null) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () => context.pop(),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(
                      Icons.more_horiz,
                      color: Colors.white,
                      size: 20,
                    ),
                    onPressed: () {},
                  ),
                ),
              ),
            ],
          ),
          body: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(child: _HeroHeader(manga: manga)),
              SliverToBoxAdapter(
                child: _StatsBox(
                  chapterCount: state.chapters.length,
                  updatedAt: manga.createdAt,
                ),
              ),
              SliverToBoxAdapter(
                child: _ActionRow(
                  firstChapterId: state.chapters.isNotEmpty
                      ? state.chapters.last.id
                      : null,
                  firstChapterNumber: state.chapters.isNotEmpty
                      ? state.chapters.last.chapterNumber
                      : null,
                ),
              ),
              if (manga.genres != null && manga.genres!.isNotEmpty)
                SliverToBoxAdapter(child: _GenresSection(genres: manga.genres!)),
              if (manga.description != null)
                SliverToBoxAdapter(child: _Synopsis(manga: manga)),
              SliverToBoxAdapter(
                child: _ChaptersHeader(count: state.chapters.length),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) =>
                      _ChapterTile(chapter: state.chapters[index]),
                  childCount: state.chapters.length,
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 40)),
            ],
          ),
        );
      },
    );
  }
}

// ─── Sub-widgets ────────────────────────────────────────────────────────────

class _HeroHeader extends StatelessWidget {
  final Manga manga;

  const _HeroHeader({required this.manga});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Gradient background
        Container(
          height: 320,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF6B52F6), Color(0xFF33206E), Color(0xFF0F0B1A)],
            ),
          ),
          child: manga.coverUrl.isNotEmpty
              ? ShaderMask(
                  shaderCallback: (rect) {
                    return const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [Colors.black, Colors.transparent],
                    ).createShader(
                      Rect.fromLTRB(0, 0, rect.width, rect.height),
                    );
                  },
                  blendMode: BlendMode.dstIn,
                  child: CachedNetworkImage(
                    imageUrl: manga.coverUrl,
                    fit: BoxFit.cover,
                    errorWidget: (_, __, ___) => const SizedBox.shrink(),
                  ),
                )
              : const SizedBox.shrink(),
        ),

        // Foreground content
        Padding(
          padding: const EdgeInsets.only(top: 240, left: 24, right: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Poster thumbnail with fade
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: ShaderMask(
                    shaderCallback: (rect) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black, Colors.black.withOpacity(0.8)],
                      ).createShader(
                        Rect.fromLTRB(0, 0, rect.width, rect.height),
                      );
                    },
                    blendMode: BlendMode.dstIn,
                    child: CachedNetworkImage(
                      imageUrl: manga.coverUrl,
                      width: 120,
                      height: 160,
                      fit: BoxFit.cover,
                      placeholder: (_, __) => Container(
                        width: 120,
                        height: 160,
                        color: const Color(0xFF8B77F6),
                        alignment: Alignment.center,
                        child: const CircularProgressIndicator(),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        width: 120,
                        height: 160,
                        color: const Color(0xFF8B77F6),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),

              // Title & metadata
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      manga.titleEn,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    if (manga.author != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        manga.author!,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ],
                    if (manga.rating != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        manga.rating!.toStringAsFixed(1),
                        style: const TextStyle(
                          color: Colors.amber,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF1E1A33),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF4A3A73)),
                          ),
                          child: const Text(
                            'MANHWA',
                            style: TextStyle(
                              color: Color(0xFF8B77F6),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        _StatusBadge(status: manga.status),
                      ],
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final isOngoing =
        status.toLowerCase().contains('ongoing') ||
        status.toLowerCase() == 'ongoing';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF161423),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isOngoing ? const Color(0xFF133E2B) : const Color(0xFF5A2020),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.circle,
            color: isOngoing ? const Color(0xFF32C68A) : Colors.redAccent,
            size: 6,
          ),
          const SizedBox(width: 4),
          Text(
            status.toLowerCase(),
            style: TextStyle(
              color: isOngoing ? const Color(0xFF32C68A) : Colors.redAccent,
              fontSize: 10,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatsBox extends StatelessWidget {
  final int chapterCount;
  final DateTime? updatedAt;

  const _StatsBox({required this.chapterCount, required this.updatedAt});

  String _timeAgo(DateTime? date) {
    if (date == null) return 'N/A';
    final diff = DateTime.now().difference(date);
    if (diff.inDays > 365) return '${(diff.inDays / 365).floor()}y ago';
    if (diff.inDays > 30) return '${(diff.inDays / 30).floor()}mo ago';
    if (diff.inDays > 0) return '${diff.inDays}d ago';
    if (diff.inHours > 0) return '${diff.inHours}h ago';
    if (diff.inMinutes > 0) return '${diff.inMinutes}m ago';
    return 'Just now';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF161423),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
        ),
        child: Row(
          children: [
            _StatItem(value: '$chapterCount', label: 'Chapters'),
            _Divider(),
            _StatItem(value: _timeAgo(updatedAt), label: 'Updated'),
          ],
        ),
      ),
    );
  }
}

class _StatItem extends StatelessWidget {
  final String value;
  final String label;

  const _StatItem({required this.value, required this.label});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 32,
      color: Colors.white.withOpacity(0.05),
    );
  }
}

class _ActionRow extends StatelessWidget {
  final String? firstChapterId;
  final int? firstChapterNumber;

  const _ActionRow({this.firstChapterId, this.firstChapterNumber});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: firstChapterId == null
                    ? null
                    : () => context.push(
                        '/reader/$firstChapterId'
                        '?chapterNumber=$firstChapterNumber',
                      ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentRed,
                  disabledBackgroundColor: Colors.white10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Start Reading',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF161423),
              borderRadius: BorderRadius.circular(16),
            ),
            child: IconButton(
              onPressed: () {},
              icon: const Icon(Icons.bookmark_border, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

class _GenresSection extends StatelessWidget {
  final List<String> genres;

  const _GenresSection({required this.genres});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Genres',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: genres.map((genre) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF161423),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Text(
                  genre,
                  style: const TextStyle(
                    color: Color(0xFFB3A5FF), // Soft purple to match the design
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}

class _Synopsis extends StatelessWidget {
  final Manga manga;

  const _Synopsis({required this.manga});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Synopsis',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          BlocBuilder<DetailCubit, DetailState>(
            builder: (context, state) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    manga.description ?? '',
                    maxLines: state.isSynopsisExpanded ? null : 4,
                    overflow: state.isSynopsisExpanded
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  GestureDetector(
                    onTap: () => context.read<DetailCubit>().toggleSynopsis(),
                    child: Text(
                      state.isSynopsisExpanded ? 'Read less' : 'Read more',
                      style: const TextStyle(
                        color: AppTheme.accentRed,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _ChaptersHeader extends StatelessWidget {
  final int count;

  const _ChaptersHeader({required this.count});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '$count ${count == 1 ? 'Chapter' : 'Chapters'}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Text(
            'Latest first',
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
        ],
      ),
    );
  }
}

class _ChapterTile extends StatelessWidget {
  final Chapter chapter;

  const _ChapterTile({required this.chapter});

  @override
  Widget build(BuildContext context) {
    final isNew =
        chapter.createdAt != null &&
        DateTime.now().difference(chapter.createdAt!).inDays < 7;

    return InkWell(
      onTap: () => context.push(
        '/reader/${chapter.id}'
        '?chapterNumber=${chapter.chapterNumber}',
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Ch.${chapter.chapterNumber}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (isNew) ...[
                  const SizedBox(width: 8),
                  const PillBadge(
                    text: 'NEW',
                    backgroundColor: AppTheme.accentRed,
                  ),
                ],
              ],
            ),
            if (chapter.chapterName != null &&
                chapter.chapterName!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text(
                chapter.chapterName!,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 14,
                ),
              ),
            ],
            if (chapter.createdAt != null) ...[
              const SizedBox(height: 6),
              Text(
                _formatDate(chapter.createdAt!),
                style: TextStyle(
                  color: Colors.white.withOpacity(0.4),
                  fontSize: 12,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inDays == 0) return 'Today';
    if (diff.inDays == 1) return 'Yesterday';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    return '${(diff.inDays / 30).floor()}mo ago';
  }
}
