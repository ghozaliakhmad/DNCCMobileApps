import 'package:flutter/material.dart';
import '../main.dart';
import '../models/product_model.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
      animation: ShopStore.instance,
      builder: (context, _) {
        final records = ShopStore.instance.history;
        return Scaffold(
          appBar: AppBar(title: const Text('Riwayat Pesanan')),
          body: records.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 36),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 82,
                          height: 82,
                          decoration: const BoxDecoration(
                            color: paleGreen,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.receipt_long_rounded,
                            size: 37,
                            color: green,
                          ),
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum ada pesanan',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 17),
                        ),
                        const SizedBox(height: 5),
                        const Text(
                          'Pesananmu akan tampil di sini setelah checkout.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: muted, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                )
              : ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
                  itemCount: records.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final order = records[index];
                    final date = order.date;
                    final dateText =
                        '${date.day.toString().padLeft(2, '0')} ${_month(date.month)} ${date.year}';
                    final timeText =
                        '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
                    final orderId =
                        '${date.year}${date.month.toString().padLeft(2, '0')}${date.day.toString().padLeft(2, '0')}${date.hour.toString().padLeft(2, '0')}${date.minute.toString().padLeft(2, '0')}';

                    return Container(
                      padding: const EdgeInsets.all(13),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: const Color(0xFFE8ECF3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE7EDFF),
                              borderRadius: BorderRadius.circular(13),
                            ),
                            child: const Icon(
                              Icons.shopping_bag_outlined,
                              color: Color(0xFF7892E5),
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 11),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Pesanan #${records.length - index}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  order.items
                                      .map((item) =>
                                          '${item.product.name} x${item.quantity}')
                                      .join(', '),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                      fontSize: 11, color: muted),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'ID Transaksi',
                                  style: TextStyle(color: muted, fontSize: 10),
                                ),
                                Text(
                                  orderId,
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 7),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                rupiah(order.total),
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE1F8EE),
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Text(
                                  order.status,
                                  style: const TextStyle(
                                    color: Color(0xFF39B77A),
                                    fontSize: 9,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 9),
                              Text(
                                dateText,
                                style:
                                    const TextStyle(color: muted, fontSize: 9),
                              ),
                              Text(
                                timeText,
                                style:
                                    const TextStyle(color: muted, fontSize: 9),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
        );
      });

  static String _month(int month) => const [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'Mei',
        'Jun',
        'Jul',
        'Agu',
        'Sep',
        'Okt',
        'Nov',
        'Des',
      ][month - 1];
}
