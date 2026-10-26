import 'package:flutter/material.dart';
import '../main.dart';
import '../services/vegetable_api.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key, this.vegetableApi});

  final VegetableApi? vegetableApi;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool isLogin = true;
  bool obscure = true;
  bool rememberMe = false;

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void enterShop() {
    if (!formKey.currentState!.validate()) return;
    ShopStore.instance.customerName = nameController.text.trim().isEmpty
        ? 'Pelanggan VegBox'
        : nameController.text.trim();
    ShopStore.instance.phone = phoneController.text.trim();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (_) => MainNavigation(vegetableApi: widget.vegetableApi),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: 290,
              child: Image.asset(
                'assets/images/bg_photo.png',
                fit: BoxFit.cover,
                alignment: Alignment.topCenter,
              ),
            ),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              height: 235,
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.white.withValues(alpha: 0),
                        Colors.white.withValues(alpha: .80),
                        Colors.white,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ),
            ),
            SafeArea(
              child: Form(
                key: formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF4E8).withValues(alpha: .95),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(Icons.eco_rounded,
                            color: darkGreen, size: 27),
                      ),
                      const SizedBox(height: 27),
                      const Text(
                        'Selamat datang di VegBox',
                        style: TextStyle(color: muted, fontSize: 14),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        isLogin ? 'Masuk ke akunmu' : 'Mulai belanja segar',
                        style: const TextStyle(
                          fontSize: 29,
                          height: 1.15,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -.7,
                        ),
                      ),
                      const SizedBox(height: 25),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F6F5),
                          borderRadius: BorderRadius.circular(13),
                          border: Border.all(color: const Color(0xFFE9EAEC)),
                        ),
                        child: Row(
                          children: [
                            _AuthTab(
                              label: 'Masuk',
                              selected: isLogin,
                              onTap: () => setState(() => isLogin = true),
                            ),
                            _AuthTab(
                              label: 'Daftar',
                              selected: !isLogin,
                              onTap: () => setState(() => isLogin = false),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      if (!isLogin) ...[
                        const _FieldLabel('Nama lengkap'),
                        const SizedBox(height: 7),
                        TextFormField(
                          controller: nameController,
                          textCapitalization: TextCapitalization.words,
                          decoration: const InputDecoration(
                            prefixIcon:
                                Icon(Icons.person_outline, color: green),
                            hintText: 'Nama lengkap',
                          ),
                          validator: (value) => !isLogin &&
                                  (value == null || value.trim().isEmpty)
                              ? 'Nama wajib diisi'
                              : null,
                        ),
                        const SizedBox(height: 16),
                      ],
                      const _FieldLabel('Nomor telepon'),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: phoneController,
                        keyboardType: TextInputType.phone,
                        decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.phone_iphone, color: green),
                          hintText: 'Masukkan nomor telepon',
                        ),
                        validator: (value) =>
                            value == null || value.trim().length < 8
                                ? 'Masukkan nomor telepon yang valid'
                                : null,
                      ),
                      const SizedBox(height: 16),
                      _FieldLabel(isLogin ? 'Kata sandi' : 'Buat kata sandi'),
                      const SizedBox(height: 7),
                      TextFormField(
                        controller: passwordController,
                        obscureText: obscure,
                        decoration: InputDecoration(
                          prefixIcon:
                              const Icon(Icons.lock_outline, color: green),
                          hintText: 'Masukkan kata sandi',
                          suffixIcon: IconButton(
                            onPressed: () => setState(() => obscure = !obscure),
                            icon: Icon(
                              obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                              color: green,
                            ),
                          ),
                        ),
                        validator: (value) => value == null || value.length < 4
                            ? 'Kata sandi minimal 4 karakter'
                            : null,
                      ),
                      if (isLogin) ...[
                        const SizedBox(height: 11),
                        Row(
                          children: [
                            SizedBox(
                              width: 24,
                              height: 24,
                              child: Checkbox(
                                value: rememberMe,
                                activeColor: green,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                visualDensity: VisualDensity.compact,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                onChanged: (value) =>
                                    setState(() => rememberMe = value ?? false),
                              ),
                            ),
                            const SizedBox(width: 7),
                            const Text(
                              'Ingat saya',
                              style: TextStyle(color: muted, fontSize: 12),
                            ),
                            const Spacer(),
                            TextButton(
                              onPressed: () => showDialog<void>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text('Lupa kata sandi?'),
                                  content: const Text(
                                    'Fitur pemulihan kata sandi belum tersedia '
                                    'di versi demo ini.',
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: const Text('Mengerti'),
                                    ),
                                  ],
                                ),
                              ),
                              style: TextButton.styleFrom(
                                foregroundColor: green,
                                padding: EdgeInsets.zero,
                                minimumSize: Size.zero,
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: const Text(
                                'Lupa kata sandi?',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 52,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: green,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(13),
                            ),
                            elevation: 1,
                          ),
                          onPressed: enterShop,
                          child: Text(
                            isLogin ? 'Masuk' : 'Daftar',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 19),
                      Row(
                        children: [
                          const Expanded(child: Divider()),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              isLogin
                                  ? 'atau masuk dengan'
                                  : 'atau daftar dengan',
                              style:
                                  const TextStyle(color: muted, fontSize: 11),
                            ),
                          ),
                          const Expanded(child: Divider()),
                        ],
                      ),
                      const SizedBox(height: 15),
                      const Row(
                        children: [
                          Expanded(
                            child: _SocialButton(
                              icon: Icons.g_mobiledata_rounded,
                              label: 'Google',
                            ),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: _SocialButton(
                              icon: Icons.apple,
                              label: 'Apple',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 22),
                      const Text.rich(
                        TextSpan(
                          style: TextStyle(color: muted, fontSize: 10),
                          children: [
                            TextSpan(
                                text: 'Dengan melanjutkan, kamu menyetujui '),
                            TextSpan(
                              text: 'Syarat Layanan',
                              style: TextStyle(
                                  color: ink, fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: ' dan '),
                            TextSpan(
                              text: 'Kebijakan Privasi',
                              style: TextStyle(
                                  color: ink, fontWeight: FontWeight.w700),
                            ),
                            TextSpan(text: ' VegBox.'),
                          ],
                        ),
                        textAlign: TextAlign.center,
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

class _AuthTab extends StatelessWidget {
  const _AuthTab({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
        child: GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 160),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: selected ? Colors.white : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: selected
                  ? const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 5,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: selected ? ink : muted,
                fontSize: 14,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
              ),
            ),
          ),
        ),
      );
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
      );
}

class _SocialButton extends StatelessWidget {
  const _SocialButton({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        height: 46,
        decoration: BoxDecoration(
          border: Border.all(color: const Color(0xFFE8EAEC)),
          borderRadius: BorderRadius.circular(11),
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 20, color: label == 'Google' ? green : ink),
              const SizedBox(width: 7),
              Text(
                label,
                style: const TextStyle(
                  color: ink,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      );
}
