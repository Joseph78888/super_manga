import 'dart:developer' as developer;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/theme/app_theme.dart';
import '../../auth/data/datasources/auth_remote_data_source.dart';
import '../../auth/data/repositories/auth_repository_impl.dart';
import 'cubit/profile_cubit.dart';
import 'cubit/profile_state.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(
        authRepository: AuthRepositoryImpl(
          remoteDataSource: SupabaseAuthRemoteDataSource(
            supabaseClient: Supabase.instance.client,
          ),
        ),
      ),
      child: const ProfileView(),
    );
  }
}

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MangaAppColors>()!;
    
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
            icon: const Icon(Icons.settings_outlined, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: BlocBuilder<ProfileCubit, ProfileState>(
        builder: (context, state) {
          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // Hero Profile Header
              SliverToBoxAdapter(
                child: state.isLoading 
                    ? const SizedBox(
                        height: 260,
                        child: Center(child: CircularProgressIndicator(color: AppTheme.accentRed)),
                      )
                    : _buildHeroProfile(state, colors),
              ),

              // Statistics Dashboard
              SliverToBoxAdapter(
                child: _buildStatisticsCard(state),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 32),
              ),

              // Settings Options
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      _buildSettingsGroup('Account', [
                        _buildSettingTile(Icons.person_outline, 'Personal Information'),
                        _buildSettingTile(Icons.workspace_premium_outlined, 'Premium Membership', trailing: 'Gold'),
                        _buildSettingTile(Icons.payment_outlined, 'Payment Methods'),
                      ]),
                      const SizedBox(height: 24),
                      _buildSettingsGroup('Preferences', [
                        _buildSettingTile(Icons.notifications_outlined, 'Notifications'),
                        _buildSettingTile(Icons.download_outlined, 'Downloads', trailing: '1.2 GB'),
                        _buildSettingTile(Icons.color_lens_outlined, 'Appearance', trailing: 'Dark'),
                      ]),
                      const SizedBox(height: 24),
                      _buildSettingsGroup('Support', [
                        _buildSettingTile(Icons.help_outline, 'Help Center'),
                        _buildSettingTile(Icons.info_outline, 'About Super Manga'),
                      ]),
                      const SizedBox(height: 32),
                      
                      // Log Out Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: () async {
                            developer.log('User signed out', name: 'auth');
                            await context.read<ProfileCubit>().signOut();
                            if (context.mounted) {
                              context.go('/auth');
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1E1A33),
                            foregroundColor: AppTheme.accentRed,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Text(
                            state.isAnonymous ? 'Log In / Sign Up' : 'Sign Out',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeroProfile(ProfileState state, MangaAppColors colors) {
    return Stack(
      children: [
        // Subtle Glowing Background
        Container(
          height: 260,
          width: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2E1C4B),
                Color(0xFF0F0B1A),
              ],
            ),
          ),
        ),
        // Content
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 120, 24, 24),
          child: Column(
            children: [
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppTheme.accentRed, width: 3),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.accentRed.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                    color: const Color(0xFF1E1A33),
                  ),
                  child: const Center(
                    child: Icon(Icons.person, size: 50, color: Colors.white54),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                state.username,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                state.email,
                style: TextStyle(
                  color: Colors.white.withOpacity(0.5),
                  fontSize: 14,
                ),
              ),
              if (state.isPremium) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.amber.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.amber.withOpacity(0.5)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.star, color: Colors.amber, size: 14),
                      SizedBox(width: 6),
                      Text(
                        'PREMIUM',
                        style: TextStyle(
                          color: Colors.amber,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatisticsCard(ProfileState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 24),
        decoration: BoxDecoration(
          color: const Color(0xFF161423),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.05)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildStatItem('${state.mangaRead}', 'Manga Read'),
            _buildDivider(),
            _buildStatItem('${state.chaptersRead}', 'Chapters'),
            _buildDivider(),
            _buildStatItem('${state.streakDays}', 'Day Streak'),
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
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withOpacity(0.5),
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
      color: Colors.white.withOpacity(0.08),
    );
  }

  Widget _buildSettingsGroup(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 8),
          child: Text(
            title.toUpperCase(),
            style: TextStyle(
              color: Colors.white.withOpacity(0.4),
              fontSize: 12,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF161423),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.05)),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildSettingTile(IconData icon, String title, {String? trailing}) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 15,
          fontWeight: FontWeight.w500,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (trailing != null) ...[
            Text(
              trailing,
              style: TextStyle(
                color: Colors.white.withOpacity(0.5),
                fontSize: 13,
              ),
            ),
            const SizedBox(width: 8),
          ],
          Icon(Icons.arrow_forward_ios, color: Colors.white.withOpacity(0.3), size: 14),
        ],
      ),
      onTap: () {},
    );
  }
}
