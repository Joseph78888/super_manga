import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import 'cubit/reader_cubit.dart';
import 'cubit/reader_state.dart';

class ReaderScreen extends StatelessWidget {
  const ReaderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ReaderCubit(),
      child: const ReaderView(),
    );
  }
}

class ReaderView extends StatefulWidget {
  const ReaderView({super.key});

  @override
  State<ReaderView> createState() => _ReaderViewState();
}

class _ReaderViewState extends State<ReaderView> {
  late ScrollController _scrollController;
  // Estimated height for a single dummy manga page to calculate scroll position
  final double _dummyPageHeight = 600.0;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    // Calculate current page based on scroll offset
    // Since images can have varying heights, dynamically tracking in a real app
    // might use visibility detectors. For dummy scrolling, we use division.
    final offset = _scrollController.offset;
    final int calculatedPage = (offset / _dummyPageHeight).floor() + 1;

    final cubit = context.read<ReaderCubit>();
    if (calculatedPage != cubit.state.currentPage &&
        calculatedPage > 0 &&
        calculatedPage <= cubit.state.totalPages) {
      cubit.updatePage(calculatedPage);
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
      backgroundColor: Colors.black, // True black for immersive reading
      body: BlocBuilder<ReaderCubit, ReaderState>(
        builder: (context, state) {
          return Stack(
            children: [
              // Infinite Scroll Content
              GestureDetector(
                onTap: () => context.read<ReaderCubit>().toggleMenu(),
                child: ListView.builder(
                  controller: _scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: state.totalPages,
                  itemBuilder: (context, index) {
                    // Dummy Manga Pages
                    return Container(
                      height: _dummyPageHeight,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: index % 2 == 0
                            ? const Color(0xFF1E1A33)
                            : const Color(
                                0xFF161423,
                              ), // Alternating blocks mimicking pages
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.02),
                            width: 1,
                          ),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: Colors.white.withOpacity(0.1),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Page ${index + 1}',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.3),
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),

              // Top Dynamic Islands
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                top: state.isMenuVisible
                    ? MediaQuery.of(context).padding.top + 16
                    : -100, // Slide out of view
                left: 16,
                right: 16,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Close Button
                    _buildGlassContainer(
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
                    // Title Pill
                    _buildGlassContainer(
                      borderRadius: BorderRadius.circular(24),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      child: Text(
                        'Ch. 179 • ${state.currentPage}/${state.totalPages}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // More Button
                    _buildGlassContainer(
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

              // Bottom Dynamic Islands
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                bottom: state.isMenuVisible
                    ? MediaQuery.of(context).padding.bottom + 20
                    : -150, // Slide out of view
                left: 16,
                right: 16,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    // Chapters Button
                    _buildGlassContainer(
                      shape: BoxShape.circle,
                      width: 56,
                      height: 56,
                      child: IconButton(
                        icon: const Icon(
                          Icons.format_list_bulleted,
                          color: Colors.white,
                          size: 24,
                        ),
                        onPressed: () {},
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Central Scrubber Pill
                    Expanded(
                      child: _buildGlassContainer(
                        borderRadius: BorderRadius.circular(36),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Text(
                            //   '${state.currentPage}/${state.totalPages}',
                            //   style: const TextStyle(
                            //     color: Colors.white,
                            //     fontSize: 13,
                            //     fontWeight: FontWeight.bold,
                            //   ),
                            // ),
                            SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white.withOpacity(
                                  0.2,
                                ),
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
                                value: state.currentPage.toDouble(),
                                min: 1,
                                max: state.totalPages.toDouble(),
                                onChanged: (value) {
                                  final targetPage = value.toInt();
                                  context.read<ReaderCubit>().updatePage(
                                    targetPage,
                                  );
                                  _scrollController.jumpTo(
                                    (targetPage - 1) * _dummyPageHeight,
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // const SizedBox(width: 12),
                    // // Settings/More Button
                    // _buildGlassContainer(
                    //   shape: BoxShape.circle,
                    //   width: 56,
                    //   height: 56,
                    //   child: IconButton(
                    //     icon: const Icon(Icons.more_horiz, color: Colors.white, size: 24),
                    //     onPressed: () {},
                    //   ),
                    // ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // Builder method for reusable floating glassmorphic islands
  Widget _buildGlassContainer({
    required Widget child,
    BoxShape shape = BoxShape.rectangle,
    BorderRadius? borderRadius,
    double? width,
    double? height,
    EdgeInsetsGeometry? padding,
  }) {
    return ClipRRect(
      borderRadius:
          borderRadius ??
          (shape == BoxShape.circle
              ? BorderRadius.circular(100)
              : BorderRadius.zero),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: width,
          height: height,
          padding: padding,
          decoration: BoxDecoration(
            shape: shape,
            borderRadius: shape == BoxShape.circle ? null : borderRadius,
            color: const Color.fromARGB(
              22,
              206,
              206,
              206,
            ), // Smooth stark dark overlay
            border: Border.all(
              color: Colors.white.withOpacity(0.08),
              width: 1,
            ), // Subtle glassy rim effect
          ),
          child: child,
        ),
      ),
    );
  }
}
