import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/pill_badge.dart';
import 'cubit/detail_cubit.dart';
import 'cubit/detail_state.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => DetailCubit(),
      child: const DetailView(),
    );
  }
}

class DetailView extends StatelessWidget {
  const DetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          // Hero Header with Gradient Background & Overlapping Content
          SliverToBoxAdapter(child: _buildHeroHeader(context)),

          // Stats Box Section
          SliverToBoxAdapter(child: _buildStatsBox()),

          // Action Row (Start Reading, Bookmark)
          SliverToBoxAdapter(child: _buildActionRow()),

          // Genres Section
          SliverToBoxAdapter(child: _buildGenresOptions()),

          // Synopsis Section
          SliverToBoxAdapter(child: _buildSynopsis()),

          // Chapters Title
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '5 Chapters',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Latest',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                  ),
                ],
              ),
            ),
          ),

          // Chapter List (Dummy Data)
          SliverList(
            delegate: SliverChildBuilderDelegate((context, index) {
              return _buildChapterItem(
                chapterNum: 179 - index,
                title: index == 0
                    ? 'The Final Confrontation'
                    : [
                        'Shadow Army',
                        'Rising Power',
                        'The Hunt Begins',
                        'Dark Secrets',
                      ][index - 1],
                time: index == 0 ? '2h ago' : '${index}w ago',
                pages: 45 - index,
                isNew: index == 0,
              );
            }, childCount: 5),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 40)),
        ],
      ),
    );
  }

  Widget _buildHeroHeader(BuildContext context) {
    return Stack(
      children: [
        // Background Gradient & Watermark
        Container(
          height: 320,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF6B52F6), // Vibrant purple
                Color(0xFF33206E),
                Color(0xFF0F0B1A), // Fade into dark scaffold bg
              ],
            ),
          ),
          child: Stack(
            children: [
              // Subtle slanted lines
              Positioned.fill(
                child: Opacity(
                  opacity: 0.15,
                  child: CustomPaint(painter: _HeaderLinesPainter()),
                ),
              ),
              // Watermark text
              const Positioned(
                top: 100,
                right: -20,
                child: Opacity(
                  opacity: 0.05,
                  child: Text(
                    'Shadow\nMonarch',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 80,
                      fontWeight: FontWeight.w900,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Foreground Content
        Padding(
          padding: const EdgeInsets.only(top: 240, left: 24, right: 24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              // Poster Cover
              Container(
                width: 120,
                height: 170,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: const Color(0xFF8B77F6),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Shadow Monarch',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 16),

              // Title, Author, Stats
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Shadow Monarch',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Chugong',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Text(
                          '4.9',
                          style: TextStyle(
                            color: Colors.amber,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF422E8A).withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF422E8A)),
                          ),
                          child: const Text(
                            'MANHWA',
                            style: TextStyle(
                              color: Color(0xFF8B77F6),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF133E2B),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFF133E2B)),
                          ),
                          child: const Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: Color(0xFF32C68A),
                                size: 6,
                              ),
                              SizedBox(width: 4),
                              Text(
                                'ongoing',
                                style: TextStyle(
                                  color: Color(0xFF32C68A),
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsBox() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 32, 24, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF161423),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _buildStatItem('179', 'Chapters'),
            _buildDivider(),
            _buildStatItem('52.3M', 'Views'),
            _buildDivider(),
            _buildStatItem('2h ago', 'Updated'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 4),
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

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.white.withOpacity(0.05),
    );
  }

  Widget _buildActionRow() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 56,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accentRed,
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

  Widget _buildGenresOptions() {
    final genres = ['Action', 'Fantasy', 'Isekai'];
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
            spacing: 12,
            children: genres.map((genre) {
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF161423),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Text(
                  genre,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.7),
                    fontSize: 13,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSynopsis() {
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
              final text =
                  'The weakest hunter of all mankind. Sung Jin-Woo, a man who has had to battle constantly just to stay alive. One day, he receives a strange power to level up that only he can see. Will he become the Shadow Monarch? And what is the true origin of the gates?';

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    text,
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

  Widget _buildChapterItem({
    required int chapterNum,
    required String title,
    required String time,
    required int pages,
    required bool isNew,
  }) {
    return InkWell(
      onTap: () {},
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Ch.$chapterNum',
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
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              '$pages pages • $time',
              style: TextStyle(
                color: Colors.white.withOpacity(0.4),
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Custom Painter for the slanted background lines
class _HeaderLinesPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    const spacing = 30.0;
    for (double i = -size.height; i < size.width * 2; i += spacing) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i - size.height, size.height), // slanted backwards slightly
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
