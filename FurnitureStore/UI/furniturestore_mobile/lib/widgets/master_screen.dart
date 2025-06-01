import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/main.dart';
import 'package:furniturestore_mobile/screens/account_profile/profile_screen.dart';
import 'package:furniturestore_mobile/screens/category/category_list_screen.dart';
import 'package:furniturestore_mobile/screens/custom_reservation/custom_reservation_overview.dart';
import 'package:furniturestore_mobile/screens/gift_card/gift_card_list_screen.dart';
import 'package:furniturestore_mobile/screens/home/home_screen.dart';
import 'package:furniturestore_mobile/screens/notification/notification_list_screen.dart';
import 'package:furniturestore_mobile/screens/order/order_screen.dart';
import 'package:furniturestore_mobile/screens/product/product_list_screen.dart';
import 'package:furniturestore_mobile/screens/product_reservation/product_reservation_list.dart';
import 'package:furniturestore_mobile/screens/promotion/promotion_list_screen.dart';
import 'package:furniturestore_mobile/screens/wish_list/wish_list_screen.dart';
import 'package:furniturestore_mobile/utils/utils.dart';

class MasterScreenWidget extends StatefulWidget {
  final Widget? child;
  final String? title;
  final Widget? titleWidget;
  final bool showBackButton;

  const MasterScreenWidget({
    this.child,
    this.title,
    this.titleWidget,
    this.showBackButton = false,
    super.key,
  });

  @override
  State<MasterScreenWidget> createState() => _MasterScreenWidgetState();
}

class _MasterScreenWidgetState extends State<MasterScreenWidget> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  int _selectedIndex = 1;
  int _cartItemCount = 0;

  @override
  void initState() {
    super.initState();
    _updateCartCount();
    Order.addListener(_updateCartCount);
  }

  @override
  void dispose() {
    Order.removeListener(_updateCartCount);
    super.dispose();
  }

  void _updateCartCount() {
    setState(() {
      _cartItemCount = Order.getOrderItems().length;
    });
  }

  final List<String> _titles = [
    'Korpa',
    'Početna',
    'Profil',
  ];

  void _navigateToScreen(int index) {
    setState(() {
      _selectedIndex = index;
    });

    Widget screen;
    switch (index) {
      case 0:
        screen = const OrderScreen();
        break;
      case 1:
        screen = const HomePageScreen();
        break;
      case 2:
        screen = const AccountProfileScreen();
        break;
      default:
        screen = const HomePageScreen();
    }

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  void _toggleDrawer() {
    setState(() {
      _scaffoldKey.currentState!.openDrawer();
    });
  }

  Widget buildCartIcon() {
    return SizedBox(
      width: 40,
      height: 40,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          const Center(
            child: Icon(
              Icons.shopping_cart,
            ),
          ),
          if (_cartItemCount > 0)
            Positioned(
              top: -3,
              right: -3,
              child: Container(
                padding: const EdgeInsets.all(1),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 240, 84, 72),
                  borderRadius: BorderRadius.circular(12),
                ),
                constraints: const BoxConstraints(
                  minWidth: 20,
                  minHeight: 20,
                ),
                child: Center(
                  child: Text(
                    _cartItemCount.toString(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: widget.showBackButton
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            : IconButton(
                icon: const Icon(Icons.menu),
                onPressed: _toggleDrawer,
              ),
        title:
            widget.titleWidget ?? Text(widget.title ?? _titles[_selectedIndex]),
      ),
      drawer: Drawer(
        child: Container(
          color: const Color(0xFF1D3557),
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    ListTile(
                      leading:
                          const Icon(Icons.arrow_back, color: Colors.white),
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.white),
                      title: const Text("Početna",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 0;
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const HomePageScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.home, color: Colors.white),
                      title: const Text("Proizvodi",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ProductListScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.category, color: Colors.white),
                      title: const Text("Kategorije",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const CategoryListScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.card_giftcard, color: Colors.white),
                      title: const Text("Poklon kartice",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const GiftCardListScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.notifications, color: Colors.white),
                      title: const Text("Obavijesti",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const NotificationListScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.local_offer, color: Colors.white),
                      title: const Text("Promocije - Akcije",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const PromotionListScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.favorite, color: Colors.white),
                      title: const Text("Lista zelja",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 2;
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const WishListScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.shopping_cart, color: Colors.white),
                      title: const Text("Narudzbe",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        setState(() {
                          _selectedIndex = 1;
                        });
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const OrderScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.bookmark, color: Colors.white),
                      title: const Text("Rezervacije Proizvoda",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ProductReservationListScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.calendar_month_rounded,
                          color: Colors.white),
                      title: const Text("Rezervacija termina",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                const CustomReservationOverviewScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: ListTile(
                  leading: const Icon(Icons.logout, color: Colors.white),
                  title: const Text("Odjavi se",
                      style: TextStyle(color: Colors.white)),
                  onTap: () {
                    Authorization.token = null;
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (route) => false,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      body: widget.child!,
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: buildCartIcon(),
            label: 'Korpa',
          ),
          const BottomNavigationBarItem(
            icon: SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.home),
            ),
            label: 'Početna',
          ),
          const BottomNavigationBarItem(
            icon: SizedBox(
              width: 40,
              height: 40,
              child: Icon(Icons.person),
            ),
            label: 'Profil',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color.fromARGB(255, 48, 98, 167),
        unselectedItemColor: const Color.fromARGB(255, 48, 98, 167),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        onTap: _navigateToScreen,
      ),
    );
  }
}
