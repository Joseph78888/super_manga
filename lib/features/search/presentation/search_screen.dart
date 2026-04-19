import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/manga_poster_card.dart';
import 'cubit/search_cubit.dart';
import 'cubit/search_state.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SearchCubit(),
      child: const SearchView(),
    );
  }
}

class SearchView extends StatelessWidget {
  const SearchView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MangaAppColors>()!;

    final popularSearches = [
      'Solo Leveling',
      'Jujutsu Kaisen',
      'One Piece',
      'Manhwa',
      'Isekai',
      'Action',
    ];

    final genreCards = [
      {
        'title': 'Action',
        'bgColor': const Color(0xFF33151A),
        'textColor': const Color(0xFFE55B5B),
      },
      {
        'title': 'Romance',
        'bgColor': const Color(0xFF211D3B),
        'textColor': const Color(0xFF8161E5),
      },
      {
        'title': 'Fantasy',
        'bgColor': const Color(0xFF133633),
        'textColor': const Color(0xFF38CDA6),
      },
      {
        'title': 'Sci-Fi',
        'bgColor': const Color(0xFF3B2516),
        'textColor': const Color(0xFFE68A2E),
      },
      {
        'title': 'Horror',
        'bgColor': const Color(0xFF331533),
        'textColor': const Color(0xFFD644D6),
      },
      {
        'title': 'Comedy',
        'bgColor': const Color(0xFF152D3D),
        'textColor': const Color(0xFF2CCED6),
      },
      {
        'title': 'Drama',
        'bgColor': const Color(0xFF133323),
        'textColor': const Color(0xFF32C68A),
      },
      {
        'title': 'Isekai',
        'bgColor': const Color(0xFF3B2C16),
        'textColor': const Color(0xFFD69A3A),
      },
    ];

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
      {
        'title': 'Phantom Guild',
        'author': 'Mashima Hiro',
        'tag': 'MANGA',
        'rating': '4.6',
        'chapter': 'Ch.545',
        'gradient': colors.trendingOrange,
      },
    ];

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Search Header Title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Text(
                  'Search',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: -0.5,
                  ),
                ),
              ),
            ),

            // Search Input Row
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: BlocBuilder<SearchCubit, SearchState>(
                  builder: (context, state) {
                    return TextField(
                      onChanged: (value) =>
                          context.read<SearchCubit>().updateSearchQuery(value),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: const Color(
                          0xFF1A1A2E,
                        ), // Deep muted blue/purple
                        hintText: 'Manga, manhwa, author...',
                        hintStyle: TextStyle(
                          color: Colors.white.withOpacity(0.4),
                          fontSize: 16,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 18,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            // Popular Searches Title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Text(
                  'Popular Searches',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Popular Searches Wrap
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: popularSearches.map((term) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF161423),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                      child: Text(
                        term,
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.6),
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // Browse by Genre Title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Text(
                  'Browse by Genre',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Browse by Genre Grid
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 2.8, // Rectangular blocks
                ),
                delegate: SliverChildBuilderDelegate((context, index) {
                  final item = genreCards[index];
                  return Container(
                    decoration: BoxDecoration(
                      color: item['bgColor'] as Color,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      item['title'] as String,
                      style: TextStyle(
                        color: item['textColor'] as Color,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  );
                }, childCount: genreCards.length),
              ),
            ),

            // Trending Title
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(24, 32, 24, 16),
                child: Text(
                  'Trending',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            // Trending Horizontal List
            SliverToBoxAdapter(
              child: SizedBox(
                height: 200,
                child: ListView.separated(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  scrollDirection: Axis.horizontal,
                  itemCount: trendingItems.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 16),
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
            ),

            // Bottom Padding
            const SliverToBoxAdapter(child: SizedBox(height: 32)),
          ],
        ),
      ),
    );
  }
}
