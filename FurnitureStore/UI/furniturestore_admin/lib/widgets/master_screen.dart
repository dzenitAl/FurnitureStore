import 'package:flutter/material.dart';
import 'package:furniturestore_admin/main.dart';
import 'package:furniturestore_admin/screens/category/category_list_screen.dart';
import 'package:furniturestore_admin/screens/custom_furniture_reservation/custom_reservation_list_screen.dart';
import 'package:furniturestore_admin/screens/decoration_item/decoration_item_list_screen.dart';
import 'package:furniturestore_admin/screens/gift_card/gift_card_list_screen.dart';
import 'package:furniturestore_admin/screens/notification/notification_list_screen.dart';
import 'package:furniturestore_admin/screens/order/order_list_screen.dart';
import 'package:furniturestore_admin/screens/product/product_list_screen.dart';
import 'package:furniturestore_admin/screens/product_reservation/product_reservation_list_screen.dart';
import 'package:furniturestore_admin/screens/promotion/promotion_list_screen.dart';
import 'package:furniturestore_admin/screens/report/report_list_screen.dart';
import 'package:furniturestore_admin/screens/subcategory/subcategory_list_screen.dart';
import 'package:furniturestore_admin/screens/users/user_list_screen.dart';
import 'package:furniturestore_admin/utils/utils.dart';

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

  void _toggleDrawer() {
    setState(() {
      _scaffoldKey.currentState!.openDrawer();
    });
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
        title: widget.titleWidget ?? Text(widget.title ?? ""),
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
                      leading: const Icon(Icons.category_rounded,
                          color: Colors.white),
                      title: const Text("Dekoracijske stavke",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const DecorationItemListScreen()),
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
                      leading: const Icon(Icons.category_outlined,
                          color: Colors.white),
                      title: const Text("Potkategorije",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) =>
                                  const SubcategoryListScreen()),
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
                      title: const Text("Notifikacije - INFOPANEL",
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
                      leading:
                          const Icon(Icons.shopping_cart, color: Colors.white),
                      title: const Text("Narudzbe",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const OrderListScreen()),
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
                                  const CustomFurnitureReservationListScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.report, color: Colors.white),
                      title: const Text("Izvještaj",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ReportListScreen()),
                        );
                      },
                    ),
                    ListTile(
                      leading:
                          const Icon(Icons.person_outline, color: Colors.white),
                      title: const Text("Lista korisnika",
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const UserListScreen()),
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
    );
  }
}
