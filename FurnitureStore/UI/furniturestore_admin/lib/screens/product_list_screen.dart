import 'package:flutter/material.dart';
import 'package:furniturestore_admin/screens/product_detail_screen.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title_widget: Text("Product list"),
      child: Container(
          child: Column(children: [
        const Text("TEST"),
        const SizedBox(
          height: 8,
        ),
        ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).primaryColor,
            ),
            onPressed: () async {
              // Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const ProductDetailScreen(),
                ),
              );
            },
            child: const Text("Login"))
      ])),
    );
  }
}
