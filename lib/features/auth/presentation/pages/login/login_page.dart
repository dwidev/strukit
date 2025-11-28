// ignore_for_file: public_member_api_docs, sort_constructors_first
// screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:strukit/core/themes/app_theme.dart';
import 'package:strukit/core/widgets/gradient_button_widget.dart';
import 'package:strukit/core/widgets/text_input_widget.dart';
import 'package:strukit/features/auth/presentation/pages/login/auth_page_listener.dart';
import 'package:strukit/features/auth/presentation/widgets/auth_background_widget.dart';
import 'package:strukit/features/auth/presentation/widgets/social_button_widget.dart';
import 'package:strukit/pages/main_page.dart';

import '../../bloc/authentication_bloc.dart';

class LoginPage extends StatefulWidget {
  static const path = '/';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _isPasswordVisible = ValueNotifier(false);
  bool _isLoading = false;

  @override
  void dispose() {
    _isPasswordVisible.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    // if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) =>
              const MainPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 800),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AuthPageListener(
      builder: (context, prov) {
        return Scaffold(
          resizeToAvoidBottomInset: true,
          body: Stack(
            children: [
              // Animated Background
              AuthBackgroundWidget(),

              // Main Content
              SafeArea(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        // Logo & Title Section
                        HeaderSection(),
                        const SizedBox(height: 30),

                        // Login Form
                        Card(
                              child: Container(
                                padding: const EdgeInsets.all(32),
                                child: Form(
                                  key: _formKey,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      // Welcome Text
                                      Text(
                                            'Selamat Datang! 👋',
                                            style: Theme.of(context)
                                                .textTheme
                                                .headlineSmall
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            textAlign: TextAlign.center,
                                          )
                                          .animate()
                                          .fadeIn(
                                            delay: 800.ms,
                                            duration: 800.ms,
                                          )
                                          .scaleXY(
                                            begin: 0.8,
                                            end: 1,
                                            delay: 800.ms,
                                            duration: 600.ms,
                                            curve: Curves.elasticOut,
                                          ),

                                      const SizedBox(height: 8),

                                      Text(
                                            'Masuk ke akun Anda untuk melanjutkan',
                                            style: Theme.of(
                                              context,
                                            ).textTheme.bodyMedium,
                                            textAlign: TextAlign.center,
                                          )
                                          .animate()
                                          .fadeIn(
                                            delay: 1000.ms,
                                            duration: 600.ms,
                                          )
                                          .slideY(
                                            begin: 0.3,
                                            end: 0,
                                            delay: 1000.ms,
                                            duration: 500.ms,
                                          ),

                                      const SizedBox(height: 32),

                                      // Email Field
                                      TextInputWidget(
                                            controller: _emailController,
                                            label: 'Email',
                                            icon: Icons.email_outlined,
                                            keyboardType:
                                                TextInputType.emailAddress,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Email tidak boleh kosong';
                                              }
                                              if (!value.contains('@')) {
                                                return 'Email tidak valid';
                                              }
                                              return null;
                                            },
                                          )
                                          .animate()
                                          .fadeIn(
                                            delay: 1200.ms,
                                            duration: 600.ms,
                                          )
                                          .slideX(
                                            begin: -0.3,
                                            end: 0,
                                            delay: 1200.ms,
                                            duration: 500.ms,
                                            curve: Curves.easeOutCubic,
                                          ),

                                      const SizedBox(height: 20),

                                      // Password Field
                                      TextInputWidget(
                                            passwordVisibleNotifier:
                                                _isPasswordVisible,
                                            controller: _passwordController,
                                            label: 'Password',
                                            icon: FontAwesomeIcons.lock,
                                            isPassword: true,
                                            validator: (value) {
                                              if (value == null ||
                                                  value.isEmpty) {
                                                return 'Password tidak boleh kosong';
                                              }
                                              if (value.length < 6) {
                                                return 'Password minimal 6 karakter';
                                              }
                                              return null;
                                            },
                                          )
                                          .animate()
                                          .fadeIn(
                                            delay: 1400.ms,
                                            duration: 600.ms,
                                          )
                                          .slideX(
                                            begin: 0.3,
                                            end: 0,
                                            delay: 1400.ms,
                                            duration: 500.ms,
                                            curve: Curves.easeOutCubic,
                                          ),

                                      const SizedBox(height: 16),

                                      // Login Button
                                      GradientButtonWidget(
                                            onPressed: _handleLogin,
                                            loading: _isLoading,
                                            options:
                                                GradientButtonWidgetOptions(
                                                  title: "Masuk",
                                                  icon: Icons.login,
                                                ),
                                          )
                                          .animate()
                                          .fadeIn(
                                            delay: 1600.ms,
                                            duration: 600.ms,
                                          )
                                          .scaleXY(
                                            begin: 0.9,
                                            end: 1,
                                            delay: 1600.ms,
                                            duration: 500.ms,
                                            curve: Curves.elasticOut,
                                          )
                                          .shimmer(
                                            delay: 2.ms,
                                            duration: 1500.ms,
                                          ),

                                      const SizedBox(height: 24),

                                      // Sign Up Link
                                      Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                'Belum punya akun? ',
                                                style: Theme.of(
                                                  context,
                                                ).textTheme.bodyMedium,
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  // Navigate to sign up
                                                },
                                                style: TextButton.styleFrom(
                                                  padding: EdgeInsets.zero,
                                                  minimumSize: Size.zero,
                                                  tapTargetSize:
                                                      MaterialTapTargetSize
                                                          .shrinkWrap,
                                                ),
                                                child: Text(
                                                  'Daftar sekarang',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color:
                                                            AppColors.primary,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                              ),
                                            ],
                                          )
                                          .animate()
                                          .fadeIn(
                                            delay: 1800.ms,
                                            duration: 600.ms,
                                          )
                                          .slideY(
                                            begin: 0.2,
                                            end: 0,
                                            delay: 1800.ms,
                                            duration: 400.ms,
                                          ),
                                    ],
                                  ),
                                ),
                              ),
                            )
                            .animate()
                            .fadeIn(
                              duration: 1500.ms,
                              delay: 300.ms,
                              curve: Curves.easeInOut,
                            )
                            .slideY(
                              begin: 0.3,
                              end: 0,
                              duration: 1200.ms,
                              delay: 300.ms,
                              curve: Curves.easeOutCubic,
                            )
                            .scaleXY(
                              begin: 0.95,
                              end: 1,
                              duration: 1200.ms,
                              delay: 300.ms,
                              curve: Curves.easeOutCubic,
                            ),

                        const SizedBox(height: 40),

                        // Social Login Options
                        SocialButtonSection(
                              onSignGoogle: () {
                                prov.add(const SignWithGoogleEvent());
                              },
                              onSignApple: () {},
                            )
                            .animate()
                            .fadeIn(
                              duration: 1000.ms,
                              delay: 600.ms,
                              curve: Curves.easeInOut,
                            )
                            .slideY(
                              begin: 0.2,
                              end: 0,
                              duration: 800.ms,
                              delay: 600.ms,
                              curve: Curves.easeOutCubic,
                            ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class SocialButtonSection extends StatelessWidget {
  final VoidCallback onSignGoogle, onSignApple;
  const SocialButtonSection({
    super.key,
    required this.onSignGoogle,
    required this.onSignApple,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Container(height: 1, color: Colors.white.toOpacity(0.3)),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'atau masuk dengan',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white.toOpacity(0.8),
                ),
              ),
            ),
            Expanded(
              child: Container(height: 1, color: Colors.white.toOpacity(0.3)),
            ),
          ],
        ),

        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child:
                  SocialButtonWidget(
                        type: SocialButtonType.google,
                        onTap: onSignGoogle,
                      )
                      .animate()
                      .fadeIn(delay: 2.seconds, duration: 600.ms)
                      .slideX(
                        begin: -0.3,
                        end: 0,
                        delay: 2.seconds,
                        duration: 500.ms,
                      )
                      .scaleXY(
                        begin: 0.8,
                        end: 1,
                        delay: 2.seconds,
                        duration: 500.ms,
                        curve: Curves.elasticOut,
                      ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child:
                  SocialButtonWidget(
                        type: SocialButtonType.apple,
                        onTap: onSignGoogle,
                      )
                      .animate()
                      .fadeIn(delay: 2.seconds, duration: 600.ms)
                      .slideX(
                        begin: 0.3,
                        end: 0,
                        delay: 2.seconds,
                        duration: 500.ms,
                      )
                      .scaleXY(
                        begin: 0.8,
                        end: 1,
                        delay: 2.seconds,
                        duration: 500.ms,
                        curve: Curves.elasticOut,
                      ),
            ),
          ],
        ),
      ],
    );
  }
}

class HeaderSection extends StatelessWidget {
  const HeaderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App Title
              Text(
                    'Strukit',
                    style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 2),
                          color: AppColors.darkBackground.toOpacity(0.3),
                          blurRadius: 10,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .shimmer(duration: 2.seconds, delay: 1000.ms)
                  .scaleXY(
                    begin: 0.8,
                    end: 1,
                    duration: 800.ms,
                    curve: Curves.elasticOut,
                  ),

              const SizedBox(height: 5),

              // Subtitle
              Text(
                    'Let AI Handle Your Receipts.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white,
                      fontSize: 16,
                      shadows: [
                        Shadow(
                          offset: const Offset(0, 1),
                          color: AppColors.darkBackground.toOpacity(0.3),
                          blurRadius: 5,
                        ),
                      ],
                    ),
                  )
                  .animate()
                  .fadeIn(delay: 500.ms, duration: 1000.ms)
                  .slideX(begin: -0.2, end: 0, delay: 500.ms, duration: 800.ms),
            ],
          ),
        )
        .animate()
        .fadeIn(duration: 1500.ms, curve: Curves.easeInOut)
        .slideY(
          begin: -0.3,
          end: 0,
          duration: 1200.ms,
          curve: Curves.easeOutCubic,
        );
  }
}
