import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../data/datasources/auth_remote_data_source.dart';
import '../data/repositories/auth_repository_impl.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;
import 'cubit/auth_cubit.dart';
import 'cubit/auth_state.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthCubit(
        authRepository: AuthRepositoryImpl(
          remoteDataSource: SupabaseAuthRemoteDataSource(
            supabaseClient: Supabase.instance.client,
          ),
        ),
      ),
      child: const AuthView(),
    );
  }
}

class AuthView extends StatefulWidget {
  const AuthView({super.key});

  @override
  State<AuthView> createState() => _AuthViewState();
}

class _AuthViewState extends State<AuthView> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _submitAuth() async {
    final cubit = context.read<AuthCubit>();
    final success = await cubit.authenticate(
      email: _emailController.text,
      password: _passwordController.text,
      username: _usernameController.text,
      confirmPassword: _confirmPasswordController.text,
    );

    if (success && mounted) {
      context.go('/'); // Navigate to home on success
    }
  }

  void _submitGuestAuth() async {
    final cubit = context.read<AuthCubit>();
    final success = await cubit.signInAsGuest();
    
    if (success && mounted) {
      context.go('/'); // Navigate to home on success
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<MangaAppColors>()!;

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    colors.headerGradientStart,
                    colors.headerGradientEnd,
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: BlocConsumer<AuthCubit, AuthState>(
              listener: (context, state) {
                if (state.errorMessage != null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(state.errorMessage!),
                      backgroundColor: AppTheme.accentRed,
                    ),
                  );
                }
              },
              builder: (context, state) {
                return Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Logo / Icon
                        const Icon(
                          Icons.auto_awesome,
                          size: 64,
                          color: AppTheme.accentRed,
                        ),
                        const SizedBox(height: 24),

                        // Title
                        Text(
                          state.isLoginMode
                              ? 'Welcome Back'
                              : 'Join Super Manga',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.isLoginMode
                              ? 'Sign in to continue reading'
                              : 'Create an account to track your progress',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.6),
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 40),

                        // Form Fields
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: state.isLoginMode
                              ? const SizedBox.shrink()
                              : Padding(
                                  padding: const EdgeInsets.only(bottom: 16),
                                  child: CustomTextField(
                                    controller: _usernameController,
                                    hintText: 'Username',
                                    prefixIcon: Icons.person_outline,
                                  ),
                                ),
                        ),

                        CustomTextField(
                          controller: _emailController,
                          hintText: 'Email Address',
                          prefixIcon: Icons.email_outlined,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 16),

                        CustomTextField(
                          controller: _passwordController,
                          hintText: 'Password',
                          prefixIcon: Icons.lock_outline,
                          obscureText: state.isPasswordObscured,
                          suffixIcon: IconButton(
                            icon: Icon(
                              state.isPasswordObscured
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: Colors.white.withValues(alpha: 0.5),
                            ),
                            onPressed: () => context
                                .read<AuthCubit>()
                                .togglePasswordVisibility(),
                          ),
                        ),

                        // Forgot Password and Confirm Password logic
                        AnimatedSize(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          child: state.isLoginMode
                              ? Align(
                                  alignment: Alignment.centerRight,
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Forgot Password?',
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.6,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Padding(
                                  padding: const EdgeInsets.only(
                                    top: 16,
                                    bottom: 8,
                                  ),
                                  child: CustomTextField(
                                    controller: _confirmPasswordController,
                                    hintText: 'Confirm Password',
                                    prefixIcon: Icons.lock_outline,
                                    obscureText:
                                        state.isConfirmPasswordObscured,
                                    suffixIcon: IconButton(
                                      icon: Icon(
                                        state.isConfirmPasswordObscured
                                            ? Icons.visibility_off
                                            : Icons.visibility,
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                      ),
                                      onPressed: () => context
                                          .read<AuthCubit>()
                                          .toggleConfirmPasswordVisibility(),
                                    ),
                                  ),
                                ),
                        ),

                        const SizedBox(height: 16),

                        // Main Action Button
                        ElevatedButton(
                          onPressed: state.isLoading ? null : _submitAuth,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppTheme.accentRed,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: state.isLoading
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : Text(
                                  state.isLoginMode
                                      ? 'Sign In'
                                      : 'Create Account',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),

                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: Divider(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              child: Text(
                                'OR',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.4),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Divider(
                                color: Colors.white.withValues(alpha: 0.1),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Google OAuth Button
                        ElevatedButton(
                          onPressed: state.isLoading
                              ? null
                              : () => context
                                    .read<AuthCubit>()
                                    .signInWithGoogle(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: Colors.black87,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              // Hardcoded Google "G" representation or Icon since we don't have SVG
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Text(
                                  'G',
                                  style: TextStyle(
                                    color: Colors.blue,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              const Text(
                                'Continue with Google',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),
                        
                        // Guest Mode Button
                        TextButton(
                          onPressed: state.isLoading ? null : _submitGuestAuth,
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.white.withValues(alpha: 0.7),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: const Text(
                            'Continue as Guest',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),

                        // Toggle Login/Signup
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              state.isLoginMode
                                  ? 'Don\'t have an account? '
                                  : 'Already have an account? ',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.6),
                              ),
                            ),
                            GestureDetector(
                              onTap: () =>
                                  context.read<AuthCubit>().toggleMode(),
                              child: Text(
                                state.isLoginMode ? 'Sign Up' : 'Sign In',
                                style: const TextStyle(
                                  color: AppTheme.accentRed,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
