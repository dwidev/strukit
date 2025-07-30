// screens/login_screen.dart
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:strukit/core/themes/app_theme.dart';
import 'package:strukit/core/widgets/gradient_button_widget.dart';
import 'package:strukit/pages/home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isLoading = false;

  @override
  void dispose() {
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
              const HomePage(),
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
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          // Animated Background
          _buildAnimatedBackground(),

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
                    _buildHeaderSection()
                        .animate()
                        .fadeIn(duration: 1500.ms, curve: Curves.easeInOut)
                        .slideY(
                          begin: -0.3,
                          end: 0,
                          duration: 1200.ms,
                          curve: Curves.easeOutCubic,
                        ),

                    const SizedBox(height: 30),

                    // Login Form
                    _buildLoginForm()
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
                    _buildSocialLogin()
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
  }

  Widget _buildAnimatedBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: AppTheme.gradients,
          stops: [0.0, 0.3],
        ),
      ),
      child: Stack(
        children: [
          // Floating Circles with flutter_animate
          Positioned(
            top: 100,
            left: 50,
            child:
                Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.toOpacity(0.1),
                            Colors.white.toOpacity(0.05),
                          ],
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .moveY(
                      begin: 0,
                      end: 20,
                      duration: 3000.ms,
                      curve: Curves.easeInOut,
                    )
                    .moveX(
                      begin: 0,
                      end: 15,
                      duration: 2500.ms,
                      curve: Curves.easeInOut,
                    ),
          ),

          Positioned(
            top: 200,
            right: 30,
            child:
                Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.toOpacity(0.15),
                            Colors.white.toOpacity(0.03),
                          ],
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .moveY(
                      begin: 0,
                      end: -25,
                      duration: 2800.ms,
                      curve: Curves.easeInOut,
                    )
                    .moveX(
                      begin: 0,
                      end: 10,
                      duration: 3200.ms,
                      curve: Curves.easeInOut,
                    ),
          ),

          Positioned(
            bottom: 150,
            left: 30,
            child:
                Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.toOpacity(0.2),
                            Colors.white.toOpacity(0.05),
                          ],
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .moveY(
                      begin: 0,
                      end: 30,
                      duration: 2200.ms,
                      curve: Curves.easeInOut,
                    )
                    .moveX(
                      begin: 0,
                      end: -5,
                      duration: 2700.ms,
                      curve: Curves.easeInOut,
                    ),
          ),

          // Additional floating elements
          Positioned(
            top: 300,
            left: 200,
            child:
                Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.toOpacity(0.08),
                            Colors.white.toOpacity(0.02),
                          ],
                        ),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => controller.repeat(reverse: true),
                    )
                    .moveY(
                      begin: 0,
                      end: -15,
                      duration: 3500.ms,
                      curve: Curves.easeInOut,
                    )
                    .moveX(
                      begin: 0,
                      end: 20,
                      duration: 2000.ms,
                      curve: Curves.easeInOut,
                    ),
          ),

          // Mesh Gradient Overlay
          Container(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: const Alignment(0.0, -0.5),
                radius: 1.5,
                colors: [Colors.white.toOpacity(0.1), Colors.transparent],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderSection() {
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
                      blurRadius: 10,
                      color: AppColors.textPrimary.withAlpha(80),
                    ),
                  ],
                ),
              )
              .animate()
              .shimmer(duration: 2000.ms, delay: 1000.ms)
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
                      blurRadius: 5,
                      color: AppColors.textPrimary.withAlpha(80),
                    ),
                  ],
                ),
              )
              .animate()
              .fadeIn(delay: 500.ms, duration: 1000.ms)
              .slideX(begin: -0.2, end: 0, delay: 500.ms, duration: 800.ms),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.toOpacity(0.95),
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.toOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
          BoxShadow(
            color: Colors.white.toOpacity(0.5),
            blurRadius: 15,
            offset: const Offset(0, -5),
          ),
        ],
        border: Border.all(color: Colors.white.toOpacity(0.3), width: 1),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Welcome Text
            Text(
                  'Selamat Datang! 👋',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 800.ms, duration: 800.ms)
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
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                )
                .animate()
                .fadeIn(delay: 1000.ms, duration: 600.ms)
                .slideY(begin: 0.3, end: 0, delay: 1000.ms, duration: 500.ms),

            const SizedBox(height: 32),

            // Email Field
            _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'Masukkan email Anda',
                  icon: Icons.email_outlined,
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email tidak boleh kosong';
                    }
                    if (!value.contains('@')) {
                      return 'Email tidak valid';
                    }
                    return null;
                  },
                )
                .animate()
                .fadeIn(delay: 1200.ms, duration: 600.ms)
                .slideX(
                  begin: -0.3,
                  end: 0,
                  delay: 1200.ms,
                  duration: 500.ms,
                  curve: Curves.easeOutCubic,
                ),

            const SizedBox(height: 20),

            // Password Field
            _buildTextField(
                  controller: _passwordController,
                  label: 'Password',
                  hint: 'Masukkan password Anda',
                  icon: Icons.lock_outline,
                  isPassword: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password tidak boleh kosong';
                    }
                    if (value.length < 6) {
                      return 'Password minimal 6 karakter';
                    }
                    return null;
                  },
                )
                .animate()
                .fadeIn(delay: 1400.ms, duration: 600.ms)
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
                  options: GradientButtonWidgetOptions(
                    title: "Masuk",
                    icon: Icons.login,
                  ),
                )
                .animate()
                .fadeIn(delay: 1600.ms, duration: 600.ms)
                .scaleXY(
                  begin: 0.9,
                  end: 1,
                  delay: 1600.ms,
                  duration: 500.ms,
                  curve: Curves.elasticOut,
                )
                .shimmer(delay: 2200.ms, duration: 1500.ms),

            const SizedBox(height: 24),

            // Sign Up Link
            Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Belum punya akun? ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        // Navigate to sign up
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Daftar sekarang',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                )
                .animate()
                .fadeIn(delay: 1800.ms, duration: 600.ms)
                .slideY(begin: 0.2, end: 0, delay: 1800.ms, duration: 400.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    TextInputType? keyboardType,
    bool isPassword = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          obscureText: isPassword && !_isPasswordVisible,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: AppColors.textSecondary),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
                  )
                : null,
            filled: true,
            fillColor: AppColors.surfaceVariant.toOpacity(0.5),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.grey.toOpacity(0.2),
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.primary, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error, width: 1),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 16,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLogin() {
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
                  _buildSocialButton(
                        icon: Icons.g_mobiledata_rounded,
                        label: 'Google',
                        onTap: () {
                          // Handle Google login
                        },
                      )
                      .animate()
                      .fadeIn(delay: 2000.ms, duration: 600.ms)
                      .slideX(
                        begin: -0.3,
                        end: 0,
                        delay: 2000.ms,
                        duration: 500.ms,
                      )
                      .scaleXY(
                        begin: 0.8,
                        end: 1,
                        delay: 2000.ms,
                        duration: 500.ms,
                        curve: Curves.elasticOut,
                      ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child:
                  _buildSocialButton(
                        icon: Icons.facebook,
                        label: 'Facebook',
                        onTap: () {
                          // Handle Facebook login
                        },
                      )
                      .animate()
                      .fadeIn(delay: 2200.ms, duration: 600.ms)
                      .slideX(
                        begin: 0.3,
                        end: 0,
                        delay: 2200.ms,
                        duration: 500.ms,
                      )
                      .scaleXY(
                        begin: 0.8,
                        end: 1,
                        delay: 2200.ms,
                        duration: 500.ms,
                        curve: Curves.elasticOut,
                      ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 52,
      decoration: BoxDecoration(
        color: Colors.white.toOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.toOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.white.toOpacity(0.3), width: 1),
      ),
      child: MaterialButton(
        onPressed: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (label.contains('g'))
              Image.asset("assets/images/google.png", width: 20),

            if (!label.contains('g'))
              Icon(icon, color: AppColors.textPrimary, size: 24),
            const SizedBox(width: 8),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
