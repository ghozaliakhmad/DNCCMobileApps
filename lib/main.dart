import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'models/product_model.dart';
import 'screens/auth_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/history_screen.dart';
import 'screens/home_screen.dart';
import 'screens/notification_screen.dart';
import 'screens/profile_screen.dart';
import 'services/vegetable_api.dart';

const green = Color(0xFF5EAA4F);
const darkGreen = Color(0xFF3E7838);
const paleGreen = Color(0xFFE5F1E1);
const ink = Color(0xFF20252B);
const muted = Color(0xFF92979D);

class CartLine {
  CartLine({required this.product, this.quantity = 1});
  final Product product;
  int quantity;
  int get subtotal => product.price * quantity;
}

class PurchaseRecord {
  PurchaseRecord({
    required this.items,
    required this.total,
    required this.date,
    this.status = 'Berhasil',
  });
  final List<CartLine> items;
  final int total;
  final DateTime date;
  final String status;
}

class ShopStore extends ChangeNotifier {
  ShopStore._();
  static final ShopStore instance = ShopStore._();
  final Map<String, CartLine> _cart = {};
  final List<PurchaseRecord> history = [];
  String customerName = 'Pelanggan VegBox';
  String phone = '';
  List<CartLine> get cart => _cart.values.toList();
  int get itemCount => _cart.values.fold(0, (sum, item) => sum + item.quantity);
  int get total => _cart.values.fold(0, (sum, item) => sum + item.subtotal);

  void add(Product product, [int quantity = 1]) {
    if (_cart.containsKey(product.id)) {
      _cart[product.id]!.quantity += quantity;
    } else {
      _cart[product.id] = CartLine(product: product, quantity: quantity);
    }
    notifyListeners();
  }

  void changeQuantity(Product product, int amount) {
    final line = _cart[product.id];
    if (line == null) return;
    line.quantity += amount;
    if (line.quantity <= 0) _cart.remove(product.id);
    notifyListeners();
  }

  void remove(Product product) {
    _cart.remove(product.id);
    notifyListeners();
  }

  void checkout() {
    if (_cart.isEmpty) return;
    history.insert(
      0,
      PurchaseRecord(
        items: _cart.values
            .map((item) =>
                CartLine(product: item.product, quantity: item.quantity))
            .toList(),
        total: total,
        date: DateTime.now(),
      ),
    );
    _cart.clear();
    notifyListeners();
  }
}

void main() => runApp(const VegBoxApp());

class VegBoxApp extends StatelessWidget {
  const VegBoxApp({super.key, this.vegetableApi});

  final VegetableApi? vegetableApi;

  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'VegBox',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: green),
          scaffoldBackgroundColor: Colors.white,
          textTheme: GoogleFonts.poppinsTextTheme().apply(
            bodyColor: ink,
            displayColor: ink,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.white,
            foregroundColor: ink,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: ink,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            hintStyle: const TextStyle(color: muted, fontSize: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE8EAEC)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFE8EAEC)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: green, width: 1.5),
            ),
          ),
        ),
        home: AuthScreen(vegetableApi: vegetableApi),
      );
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key, this.vegetableApi});

  final VegetableApi? vegetableApi;

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int index = 0;
  @override
  Widget build(BuildContext context) => AnimatedBuilder(
        animation: ShopStore.instance,
        builder: (context, _) => Scaffold(
          body: IndexedStack(
            index: index,
            children: [
              HomeScreen(vegetableApi: widget.vegetableApi),
              const NotificationScreen(),
              const CartScreen(),
              const HistoryScreen(),
              const ProfileScreen(),
            ],
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              height: 70,
              margin: const EdgeInsets.fromLTRB(18, 0, 18, 8),
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: const Color(0xFFE8EAEC)),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x10000000),
                    blurRadius: 18,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _NavButton(
                    icon: Icons.home_rounded,
                    selected: index == 0,
                    onTap: () => setState(() => index = 0),
                  ),
                  _NavButton(
                    icon: Icons.notifications_rounded,
                    selected: index == 1,
                    onTap: () => setState(() => index = 1),
                  ),
                  _CartNavButton(
                    count: ShopStore.instance.itemCount,
                    onTap: () => setState(() => index = 2),
                  ),
                  _NavButton(
                    icon: Icons.receipt_long_rounded,
                    selected: index == 3,
                    onTap: () => setState(() => index = 3),
                  ),
                  _NavButton(
                    icon: Icons.person_outline_rounded,
                    selected: index == 4,
                    onTap: () => setState(() => index = 4),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
}

class _NavButton extends StatelessWidget {
  const _NavButton({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onTap,
        icon: Icon(icon, size: 23),
        color: selected ? green : const Color(0xFFB8BBC0),
        splashRadius: 24,
      );
}

class _CartNavButton extends StatelessWidget {
  const _CartNavButton({required this.count, required this.onTap});

  final int count;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Transform.translate(
        offset: const Offset(0, -8),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Material(
              color: green,
              shape: const CircleBorder(),
              child: InkWell(
                onTap: onTap,
                customBorder: const CircleBorder(),
                child: const SizedBox(
                  width: 52,
                  height: 52,
                  child: Icon(Icons.shopping_basket_rounded,
                      color: Colors.white, size: 24),
                ),
              ),
            ),
            if (count > 0)
              Positioned(
                right: -2,
                top: -2,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  constraints:
                      const BoxConstraints(minWidth: 19, minHeight: 19),
                  child: Text(
                    '$count',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
}
