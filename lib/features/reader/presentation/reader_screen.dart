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
    if (calculatedPage != cubit.state.currentPage && calculatedPage > 0 && calculatedPage <= cubit.state.totalPages) {
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
                        color: index % 2 == 0 ? const Color(0xFF1E1A33) : const Color(0xFF161423), // Alternating blocks mimicking pages
                        border: Border(
                          bottom: BorderSide(color: Colors.white.withOpacity(0.02), width: 1),
                        ),
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image_outlined, size: 48, color: Colors.white.withOpacity(0.1)),
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

              // Top Glassmorphic Header (Telegram style)
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                top: state.isMenuVisible ? 0 : -100, // Slide out of view upwards
                left: 0,
                right: 0,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 8,
                        bottom: 16,
                        left: 16,
                        right: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F0B1A).withOpacity(0.65), // Semi-transparent dark background
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
                            onPressed: () => context.pop(),
                          ),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Shadow Monarch',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Chapter 179',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.settings_outlined, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Glassmorphic Scrubber
              AnimatedPositioned(
                duration: const Duration(milliseconds: 250),
                curve: Curves.easeInOut,
                bottom: state.isMenuVisible ? 0 : -120, // Slide out of view downwards
                left: 0,
                right: 0,
                child: ClipRRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      padding: EdgeInsets.only(
                        top: 24,
                        bottom: MediaQuery.of(context).padding.bottom + 24,
                        left: 24,
                        right: 24,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F0B1A).withOpacity(0.65),
                        border: Border(
                          top: BorderSide(
                            color: Colors.white.withOpacity(0.05),
                          ),
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${state.currentPage} / ${state.totalPages}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: AppTheme.accentRed,
                              inactiveTrackColor: Colors.white.withOpacity(0.1),
                              thumbColor: AppTheme.accentRed,
                              overlayColor: AppTheme.accentRed.withOpacity(0.2),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value: state.currentPage.toDouble(),
                              min: 1,
                              max: state.totalPages.toDouble(),
                              onChanged: (value) {
                                final targetPage = value.toInt();
                                context.read<ReaderCubit>().updatePage(targetPage);
                                // Quickly scroll to the target page via slider scrubbing
                                _scrollController.jumpTo((targetPage - 1) * _dummyPageHeight);
                              },
                            ),
                          ),
                        ],
                      ),
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
