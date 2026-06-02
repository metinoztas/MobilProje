import 'package:flutter/material.dart';
import 'auth_service.dart';
import 'register_screen.dart';
import 'package:butce_takip/main.dart';

/// Login Ekranı
/// Koyu temalı, gradient arka planlı, modern tasarımlı giriş ekranı.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ─── Form & Controller'lar ────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _rememberMe = true;
  bool _isLoading = false;

  // ─── Animasyon ────────────────────────────────────────────
  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  // ─── Renk Paleti ──────────────────────────────────────────
  static const _bgDark = Color(0xFF0A0E21);
  static const _bgCard = Color(0xFF1A1F3A);
  static const _purple = Color(0xFF7C3AED);
  static const _blue = Color(0xFF3B82F6);
  static const _textSecondary = Color(0xFF8B8FA3);

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOut),
    );
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // ─── Giriş İşlemi ────────────────────────────────────────
  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await AuthService.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    setState(() => _isLoading = false);

    if (!mounted) return;

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('✅ ${result['message']}'),
          backgroundColor: Colors.green.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MainNavigation()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('❌ ${result['message']}'),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgDark,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0A0E21),
              Color(0xFF12163A),
              Color(0xFF0A0E21),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SlideTransition(
                position: _slideAnim,
                child: Column(
                  children: [
                    const SizedBox(height: 30),
                    _buildHeader(),
                    const SizedBox(height: 40),
                    _buildWelcomeText(),
                    const SizedBox(height: 32),
                    _buildForm(),
                    const SizedBox(height: 16),
                    _buildRememberAndForgot(),
                    const SizedBox(height: 28),
                    _buildLoginButton(),
                    const SizedBox(height: 28),
                    _buildDivider(),
                    const SizedBox(height: 28),
                    _buildSocialButtons(),
                    const SizedBox(height: 32),
                    _buildRegisterLink(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─── Logo & Başlık ────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        // Dekoratif arka plan ile logo
        Stack(
          alignment: Alignment.center,
          children: [
            // Parlama efekti
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    _purple.withOpacity(0.3),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            // Logo kutusu
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_purple, _blue],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _purple.withOpacity(0.4),
                    blurRadius: 30,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.show_chart_rounded,
                color: Colors.white,
                size: 42,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Uygulama adı
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'FinAsistan ',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              TextSpan(
                text: 'AI',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: _purple,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 6),
        const Text(
          'AI Destekli Harcama Analizi & Finans Asistanı',
          style: TextStyle(
            fontSize: 13,
            color: _textSecondary,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  // ─── Hoş Geldin Yazısı ───────────────────────────────────
  Widget _buildWelcomeText() {
    return const Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Hoş Geldin!',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Hesabına giriş yaparak finansal\nverilerini yönetmeye başla.',
            style: TextStyle(
              fontSize: 14,
              color: _textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  // ─── Form Alanları ────────────────────────────────────────
  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          // E-posta
          _buildTextField(
            controller: _emailController,
            hintText: 'E-posta adresi',
            icon: Icons.mail_outline_rounded,
            keyboardType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'E-posta adresi gerekli';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value.trim())) {
                return 'Geçerli bir e-posta adresi giriniz';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
          // Şifre
          _buildTextField(
            controller: _passwordController,
            hintText: 'Şifre',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscurePassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Şifre gerekli';
              }
              if (value.length < 6) {
                return 'Şifre en az 6 karakter olmalı';
              }
              return null;
            },
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_rounded
                    : Icons.visibility_rounded,
                color: _textSecondary,
                size: 22,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ─── Ortak TextField Widget'ı ─────────────────────────────
  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    Widget? suffixIcon,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white, fontSize: 15),
      cursorColor: _purple,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: _textSecondary, fontSize: 14),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 16, right: 12),
          child: Icon(icon, color: _textSecondary, size: 22),
        ),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: _bgCard,
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.white.withOpacity(0.06)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: _purple, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide(color: Colors.red.shade400, width: 1.5),
        ),
        errorStyle: TextStyle(color: Colors.red.shade300, fontSize: 12),
      ),
    );
  }

  // ─── Beni Hatırla & Şifremi Unuttum ──────────────────────
  Widget _buildRememberAndForgot() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Beni hatırla
        GestureDetector(
          onTap: () => setState(() => _rememberMe = !_rememberMe),
          child: Row(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                width: 22,
                height: 22,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(6),
                  gradient: _rememberMe
                      ? const LinearGradient(colors: [_purple, _blue])
                      : null,
                  border: _rememberMe
                      ? null
                      : Border.all(color: _textSecondary, width: 1.5),
                ),
                child: _rememberMe
                    ? const Icon(Icons.check, color: Colors.white, size: 16)
                    : null,
              ),
              const SizedBox(width: 8),
              const Text(
                'Beni hatırla',
                style: TextStyle(color: _textSecondary, fontSize: 13),
              ),
            ],
          ),
        ),
        // Şifremi unuttum
        GestureDetector(
          onTap: () {
            // TODO: Şifre sıfırlama sayfası
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Şifre sıfırlama yakında eklenecek.'),
                backgroundColor: _purple,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            );
          },
          child: const Text(
            'Şifremi Unuttum?',
            style: TextStyle(
              color: _purple,
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Giriş Yap Butonu ────────────────────────────────────
  Widget _buildLoginButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: const LinearGradient(
            colors: [_purple, _blue],
          ),
          boxShadow: [
            BoxShadow(
              color: _purple.withOpacity(0.4),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isLoading ? null : _handleLogin,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : const Text(
                  'Giriş Yap',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }

  // ─── "veya" Ayırıcı ──────────────────────────────────────
  Widget _buildDivider() {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 1,
            color: _textSecondary.withOpacity(0.3),
          ),
        ),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'veya',
            style: TextStyle(color: _textSecondary, fontSize: 13),
          ),
        ),
        Expanded(
          child: Container(
            height: 1,
            color: _textSecondary.withOpacity(0.3),
          ),
        ),
      ],
    );
  }

  // ─── Sosyal Giriş Butonları ───────────────────────────────
  Widget _buildSocialButtons() {
    return Row(
      children: [
        // Google ile Giriş
        Expanded(
          child: _buildSocialButton(
            icon: Icons.g_mobiledata_rounded,
            label: 'Google ile Giriş',
            iconColor: Colors.white,
            iconSize: 28,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Google ile giriş yakında eklenecek.'),
                  backgroundColor: _bgCard,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 14),
        // Apple ile Giriş
        Expanded(
          child: _buildSocialButton(
            icon: Icons.apple_rounded,
            label: 'Apple ile Giriş',
            iconColor: Colors.white,
            iconSize: 24,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Apple ile giriş yakında eklenecek.'),
                  backgroundColor: _bgCard,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    double iconSize = 24,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: _bgCard,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: iconColor, size: iconSize),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Kayıt Ol Linki ──────────────────────────────────────
  Widget _buildRegisterLink() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            pageBuilder: (_, _, _) => const RegisterScreen(),
            transitionsBuilder: (_, animation, _, child) {
              return FadeTransition(opacity: animation, child: child);
            },
            transitionDuration: const Duration(milliseconds: 400),
          ),
        );
      },
      child: RichText(
        text: const TextSpan(
          text: 'Hesabın yok mu? ',
          style: TextStyle(color: _textSecondary, fontSize: 14),
          children: [
            TextSpan(
              text: 'Kayıt Ol',
              style: TextStyle(
                color: _purple,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
