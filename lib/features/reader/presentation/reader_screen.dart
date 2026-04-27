import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../data/datasources/page_remote_data_source.dart';
import '../data/repositories/page_repository.dart';
import 'cubit/reader_cubit.dart';
import 'cubit/reader_state.dart';

class ReaderScreen extends StatelessWidget {
  final String chapterId;
  final String chapterNumber;

  const ReaderScreen({
    super.key,
    required this.chapterId,
    required this.chapterNumber,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ReaderCubit(
        pageRepository: PageRepository(
          dataSource: SupabasePageRemoteDataSource(
            supabaseClient: Supabase.instance.client,
          ),
        ),
      )..loadPages(chapterId, chapterNumber: chapterNumber),
      child: const _ReaderView(),
    );
  }
}

class _ReaderView extends StatefulWidget {
  const _ReaderView();

  @override
  State<_ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<_ReaderView> {
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final cubit = context.read<ReaderCubit>();
    final state = cubit.state;
    if (state.pages.isEmpty) return;

    // Estimate page from scroll position using viewport height
    final viewportHeight = MediaQuery.of(context).size.height;
    final offset = _scrollController.offset;
    final estimated = (offset / viewportHeight).floor() + 1;
    final clamped = estimated.clamp(1, state.totalPages);

    if (clamped != state.currentPage) {
      cubit.updatePage(clamped);
    }
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: BlocBuilder<ReaderCubit, ReaderState>(
        builder: (context, state) {
          if (state.isLoading) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading pages…',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            );
          }

          if (state.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: Colors.white38,
                    size: 48,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    state.error!,
                    style: const TextStyle(color: Colors.white38),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Stack(
            children: [
              // ── Page list ───────────────────────────────────────────────
              GestureDetector(
                onTap: () => context.read<ReaderCubit>().toggleMenu(),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.pages.length,
                  itemBuilder: (context, index) {
                    final page = state.pages[index];
                    return CachedNetworkImage(
                      imageUrl: page.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.fitWidth,
                      placeholder: (_, __) => Container(
                        height: MediaQuery.of(context).size.height * 0.8,
                        color: const Color(0xFF1E1A33),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const CircularProgressIndicator(strokeWidth: 2),
                            const SizedBox(height: 12),
                            Text(
                              'Page ${index + 1}',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                      errorWidget: (_, __, ___) => Container(
                        height: 300,
                        color: const Color(0xFF161423),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.broken_image_outlined,
                              size: 48,
                              color: Colors.white.withOpacity(0.2),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Page ${index + 1} failed to load',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.3),
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),

              // ── Top HUD ─────────────────────────────────────────────────
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                top: state.isMenuVisible
                    ? MediaQuery.of(context).padding.top + 16
                    : -100,
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _GlassChip(
                      shape: BoxShape.circle,
                      width: 48,
                      height: 48,
                      child: IconButton(
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () => context.pop(),
                      ),
                    ),
                    _GlassChip(
                      borderRadius: BorderRadius.circular(24),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Text(
                        state.chapterNumber != null &&
                                state.chapterNumber!.isNotEmpty
                            ? 'Ch.${state.chapterNumber}  •  '
                                  '${state.currentPage}/${state.totalPages}'
                            : '${state.currentPage}/${state.totalPages}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    _GlassChip(
                      shape: BoxShape.circle,
                      width: 48,
                      height: 48,
                      child: IconButton(
                        icon: const Icon(
                          Icons.more_horiz,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),

              // ── Bottom scrubber ──────────────────────────────────────────
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                bottom: state.isMenuVisible
                    ? MediaQuery.of(context).padding.bottom + 20
                    : -150,
                left: 16,
                right: 16,
                child: _GlassChip(
                  borderRadius: BorderRadius.circular(36),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: Colors.white,
                      inactiveTrackColor: Colors.white.withOpacity(0.2),
                      thumbColor: Colors.white,
                      overlayColor: Colors.white.withOpacity(0.2),
                      trackHeight: 3,
                      thumbShape: const RoundSliderThumbShape(
                        enabledThumbRadius: 8,
                      ),
                      overlayShape: const RoundSliderOverlayShape(
                        overlayRadius: 16,
                      ),
                    ),
                    child: Slider(
                      value: state.totalPages > 1
                          ? state.currentPage.toDouble().clamp(
                              1.0,
                              state.totalPages.toDouble(),
                            )
                          : 1.0,
                      min: 1,
                      max: state.totalPages > 1
                          ? state.totalPages.toDouble()
                          : 2,
                      onChanged: state.pages.isEmpty
                          ? null
                          : (value) {
                              final target = value.toInt();
                              context.read<ReaderCubit>().updatePage(target);
                              final viewportHeight = MediaQuery.of(
                                context,
                              ).size.height;
                              _scrollController.jumpTo(
                                (target - 1) * viewportHeight,
                              );
                            },
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// Glassmorphic floating island.
class _GlassChip extends StatelessWidget {
  final Widget child;
  final BoxShape shape;
  final BorderRadius? borderRadius;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const _GlassChip({
    required this.child,
    this.shape = BoxShape.rectangle,
    this.borderRadius,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final radius =
        borderRadius ??
        (shape == BoxShape.circle
            ? BorderRadius.circular(100)
            : BorderRadius.zero);
    return ClipRRect(
      borderRadius: radius,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            shape: shape,
            borderRadius: shape == BoxShape.circle ? null : radius,
            color: const Color.fromARGB(22, 206, 206, 206),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: child,
        ),
      ),
    );
  }
}
