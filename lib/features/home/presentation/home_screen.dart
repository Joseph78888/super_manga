import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_theme.dart';
import 'widgets/featured_carousel.dart';
import 'widgets/trending_list.dart';
import 'widgets/recently_updated_list.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Safe Area / App Bar simulation
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Good morning',
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.5),
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Super Manga',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () => context.push('/profile'),
                      child: const CircleAvatar(
                        radius: 22,
                        backgroundColor: Color(0xFF1E1A33),
                        child: Icon(Icons.person, color: Colors.white54),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Body Content
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(bottom: 32),
                child: Column(
                  children: [
                    FeaturedCarousel(),
                    SizedBox(height: 24),
                    TrendingList(),
                    SizedBox(height: 24),
                    RecentlyUpdatedList(),
                    SizedBox(height: 32), // Bottum padding
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
