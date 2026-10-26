import 'package:flutter/material.dart';
import '../main.dart';
import 'auth_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: ShopStore.instance,
      builder: (context, _) {
        final store = ShopStore.instance;
        return Scaffold(
          appBar: AppBar(title: const Text('Profil')),
          body: ListView(
            padding: const EdgeInsets.fromLTRB(20, 15, 20, 28),
            children: [
              Container(
                padding: const EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE7E9E8)),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x0D000000),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 52,
                      height: 52,
                      decoration: const BoxDecoration(
                        color: paleGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.person_rounded,
                          color: darkGreen, size: 29),
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            store.customerName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            store.phone.isEmpty
                                ? 'Pelanggan VegBox'
                                : store.phone,
                            style: const TextStyle(color: muted, fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: ink,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(Icons.arrow_forward_rounded,
                          color: Colors.white, size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              _ProfileOption(
                icon: Icons.badge_outlined,
                title: 'Edit profil',
                onTap: () => _showInfo(context, 'Edit profil',
                    'Pengaturan profil belum tersedia.'),
              ),
              _ProfileOption(
                icon: Icons.access_time_rounded,
                title: 'Riwayat pesanan',
                trailing: Text(
                  '${store.history.length}',
                  style: const TextStyle(color: muted, fontSize: 12),
                ),
                onTap: () => _showInfo(
                  context,
                  'Riwayat pesanan',
                  'Pilih menu riwayat pada navigasi bawah untuk melihat pesanan.',
                ),
              ),
              _ProfileOption(
                icon: Icons.help_outline_rounded,
                title: 'Bantuan',
                onTap: () => _showInfo(
                  context,
                  'Bantuan',
                  'VegBox adalah aplikasi demo belanja produk segar.',
                ),
              ),
              _ProfileOption(
                icon: Icons.info_outline_rounded,
                title: 'Tentang VegBox',
                onTap: () => _showInfo(
                  context,
                  'Tentang VegBox',
                  'Belanja bahan segar pilihan untuk keluarga.',
                ),
              ),
              const SizedBox(height: 15),
              OutlinedButton.icon(
                onPressed: () => showDialog<void>(
                  context: context,
                  builder: (dialogContext) => AlertDialog(
                    title: const Text('Keluar dari akun?'),
                    content: const Text('Kamu akan kembali ke halaman masuk.'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialogContext),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const AuthScreen()),
                            (_) => false,
                          );
                        },
                        child: const Text('Keluar'),
                      ),
                    ],
                  ),
                ),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Keluar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: darkGreen,
                  minimumSize: const Size.fromHeight(48),
                  side: const BorderSide(color: Color(0xFFDDE8D9)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ],
          ),
        );
      });

  static void _showInfo(BuildContext context, String title, String message) {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }
}

class _ProfileOption extends StatelessWidget {
  const _ProfileOption({
    required this.icon,
    required this.title,
    required this.onTap,
    this.trailing = const Icon(Icons.chevron_right_rounded, size: 20),
  });

  final IconData icon;
  final String title;
  final Widget trailing;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 2),
            leading: Icon(icon, size: 21, color: ink),
            title: Text(title, style: const TextStyle(fontSize: 14)),
            trailing: trailing,
            onTap: onTap,
          ),
          const Divider(height: 1, indent: 46),
        ],
      );
}
