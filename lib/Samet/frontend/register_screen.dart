import 'package:flutter/material.dart';
import 'auth_service.dart';

/// Kayıt Ekranı
/// Login ekranı ile aynı tasarım dilini kullanır.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  // ─── Form & Controller'lar ────────────────────────────────
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
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
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // ─── Kayıt İşlemi ────────────────────────────────────────
  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    final result = await AuthService.register(
      name: _nameController.text.trim(),
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
      // Kayıt başarılı → Login ekranına geri dön
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) Navigator.pop(context);
      });
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
                    const SizedBox(height: 20),
                    _buildBackButton(),
                    const SizedBox(height: 16),
                    _buildHeader(),
                    const SizedBox(height: 36),
                    _buildWelcomeText(),
                    const SizedBox(height: 28),
                    _buildForm(),
                    const SizedBox(height: 32),
                    _buildRegisterButton(),
                    const SizedBox(height: 28),
                    _buildDivider(),
                    const SizedBox(height: 28),
                    _buildSocialButtons(),
                    const SizedBox(height: 32),
                    _buildLoginLink(),
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

  // ─── Geri Butonu ──────────────────────────────────────────
  Widget _buildBackButton() {
    return Align(
      alignment: Alignment.centerLeft,
      child: GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: _bgCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white.withOpacity(0.06)),
          ),
          child: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  // ─── Logo & Başlık ────────────────────────────────────────
  Widget _buildHeader() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
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
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [_purple, _blue],
                ),
                boxShadow: [
                  BoxShadow(
                    color: _purple.withOpacity(0.4),
                    blurRadius: 24,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: const Icon(
                Icons.person_add_rounded,
                color: Colors.white,
                size: 36,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'FinAsistan ',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              TextSpan(
                text: 'AI',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _purple,
                  letterSpacing: 1,
                ),
              ),
            ],
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
            'Hesap Oluştur',
            style: TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          SizedBox(height: 6),
          Text(
            'Finansal verilerini yönetmek için\nhemen kayıt ol.',
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
          // Ad Soyad
          _buildTextField(
            controller: _nameController,
            hintText: 'Ad Soyad',
            icon: Icons.person_outline_rounded,
            validator: (value) {
              if (value == null || value.trim().isEmpty) {
                return 'Ad Soyad gerekli';
              }
              if (value.trim().length < 2) {
                return 'Ad Soyad en az 2 karakter olmalı';
              }
              return null;
            },
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          // Şifre Tekrar
          _buildTextField(
            controller: _confirmPasswordController,
            hintText: 'Şifre Tekrar',
            icon: Icons.lock_outline_rounded,
            obscureText: _obscureConfirmPassword,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Şifre tekrarı gerekli';
              }
              if (value != _passwordController.text) {
                return 'Şifreler eşleşmiyor';
              }
              return null;
            },
            suffixIcon: IconButton(
              onPressed: () =>
                  setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
              icon: Icon(
                _obscureConfirmPassword
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

  // ─── Kayıt Ol Butonu ─────────────────────────────────────
  Widget _buildRegisterButton() {
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
          onPressed: _isLoading ? null : _handleRegister,
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
                  'Kayıt Ol',
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

  // ─── Sosyal Kayıt Butonları ───────────────────────────────
  Widget _buildSocialButtons() {
    return Row(
      children: [
        Expanded(
          child: _buildSocialButton(
            icon: Icons.g_mobiledata_rounded,
            label: 'Google ile Kayıt',
            iconSize: 28,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Google ile kayıt yakında eklenecek.'),
                  backgroundColor: _bgCard,
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
              );
            },
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: _buildSocialButton(
            icon: Icons.apple_rounded,
            label: 'Apple ile Kayıt',
            iconSize: 24,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Apple ile kayıt yakında eklenecek.'),
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
              Icon(icon, color: Colors.white, size: iconSize),
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

  // ─── Giriş Yap Linki ─────────────────────────────────────
  Widget _buildLoginLink() {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: RichText(
        text: const TextSpan(
          text: 'Zaten hesabın var mı? ',
          style: TextStyle(color: _textSecondary, fontSize: 14),
          children: [
            TextSpan(
              text: 'Giriş Yap',
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
