import 'package:flutter/material.dart';
import '../main.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Notifikasi')),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(18, 8, 18, 24),
          children: const [
            Padding(
              padding: EdgeInsets.only(bottom: 9),
              child: Text('Hari ini',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            ),
            _NotificationTile(
              icon: Icons.eco_rounded,
              message:
                  'Selamat datang di VegBox! Temukan berbagai produk segar untuk kebutuhan harianmu.',
              time: 'Baru saja',
              unread: true,
            ),
            _NotificationTile(
              icon: Icons.local_offer_outlined,
              message:
                  'Produk pilihan dan paket hemat siap melengkapi belanja mingguanmu.',
              time: '2 jam lalu',
              unread: false,
            ),
            _NotificationTile(
              icon: Icons.shopping_basket_outlined,
              message:
                  'Jangan lupa cek keranjangmu dan nikmati bahan segar pilihan.',
              time: 'Kemarin',
              unread: false,
            ),
          ],
        ),
      );
}

class _NotificationTile extends StatelessWidget {
  const _NotificationTile({
    required this.icon,
    required this.message,
    required this.time,
    required this.unread,
  });

  final IconData icon;
  final String message;
  final String time;
  final bool unread;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Color(0xFFE9EAEC))),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  width: 54,
                  height: 54,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF0F1F1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: darkGreen, size: 23),
                ),
                if (unread)
                  Positioned(
                    right: -1,
                    bottom: 0,
                    child: Container(
                      width: 13,
                      height: 13,
                      decoration: BoxDecoration(
                        color: green,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.4,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    time,
                    style: const TextStyle(color: muted, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}
