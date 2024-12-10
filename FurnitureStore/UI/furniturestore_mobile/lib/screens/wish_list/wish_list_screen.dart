import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({Key? key}) : super(key: key);

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  late Future<List<ProductModel>> wishlistItems;

  @override
  void initState() {
    super.initState();
    wishlistItems = loadWishList();
  }

  Future<List<ProductModel>> loadWishList() async {
    await WishList.loadWishList();
    return await WishList.getProductsByIds(WishList.productIds);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Lista želja',
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<ProductModel>>(
          future: wishlistItems,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                  child: Text('Greška pri učitavanju liste želja'));
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return _buildEmptyState();
            } else {
              return _buildWishList(snapshot.data!);
            }
          },
        ),
      ),
    );
  }

  Widget _buildWishList(List<ProductModel> wishlistItems) {
    return ListView.builder(
      itemCount: wishlistItems.length,
      itemBuilder: (context, index) {
        final product = wishlistItems[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 16),
                Expanded(child: _buildProductDetails(product)),
                IconButton(
                  icon: const Icon(Icons.remove_circle, color: Colors.red),
                  onPressed: () async {
                    await _removeFromWishList(product.id!);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _removeFromWishList(int productId) async {
    await WishList.removeProductFromWishList(productId);
    setState(() {
      wishlistItems = loadWishList();
    });
  }

  Widget _buildProductDetails(ProductModel product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name ?? "",
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Cijena: ${product.price} KM',
          style: const TextStyle(fontSize: 16, color: Colors.green),
        ),
        const SizedBox(height: 4),
        Text(
          'Opis: ${product.description}',
          style: const TextStyle(fontSize: 14, color: Colors.grey),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.favorite_border, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Vaša lista želja je prazna',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
