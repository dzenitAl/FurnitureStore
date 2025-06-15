import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/decoration_item/decoration_item.dart';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/providers/wish_list_provider.dart';
import 'package:furniturestore_mobile/screens/product/product_detail_screen.dart';
import 'package:furniturestore_mobile/screens/decoration_item/decoration_item_detail_screen.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:furniturestore_mobile/widgets/wish_list_item_card.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  late Future<List<dynamic>> wishlistItems;
  final WishListProvider _wishListProvider = WishListProvider();

  @override
  void initState() {
    super.initState();
    _loadWishList();
  }

  void _loadWishList() {
    setState(() {
      wishlistItems = Future.wait([
        WishList.loadWishList()
            .then((_) => WishList.getProductsByIds(WishList.productIds))
            .catchError((error) {
          print('Error loading products: $error');
          return <ProductModel>[];
        }),
        WishList.loadWishList()
            .then((_) =>
                WishList.getDecorationItemsByIds(WishList.decorationItemIds))
            .catchError((error) {
          print('Error loading decoration items: $error');
          return <DecorationItemModel>[];
        })
      ]).then((results) {
        final products = results[0] as List<ProductModel>;
        final decorationItems = results[1] as List<DecorationItemModel>;
        return [...products, ...decorationItems];
      });
    });
  }

  Future<void> _handleRemoveFromWishList(dynamic item) async {
    try {
      if (item is ProductModel) {
        await WishList.removeProductFromWishList(item.id!);
      } else if (item is DecorationItemModel) {
        await WishList.removeDecorationItemFromWishList(item.id!);
      }
      _showSnackBar('Proizvod uklonjen iz liste želja');
      _loadWishList();
    } catch (e) {
      _showSnackBar('Greška prilikom uklanjanja proizvoda: $e');
    }
  }

  Future<void> _handleAddToCart(dynamic item) async {
    try {
      if (item is ProductModel) {
        Order.addProductToOrder(item);
      } else if (item is DecorationItemModel) {
        Order.addDecorationItemToOrder(item);
      }
      _showSnackBar('Proizvod dodan u korpu');
    } catch (e) {
      _showSnackBar('Greška prilikom dodavanja u korpu: $e');
    }
  }

  void _navigateToDetails(dynamic item) {
    if (item is ProductModel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailScreen(product: item),
        ),
      );
    } else if (item is DecorationItemModel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DecorationItemDetailScreen(item: item),
        ),
      );
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Lista želja',
      showBackButton: true,
      child: FutureBuilder<List<dynamic>>(
        future: wishlistItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Greška: ${snapshot.error}'),
            );
          }

          final items = snapshot.data ?? [];

          if (items.isEmpty) {
            return const Center(
              child: Text(
                'Vaša lista želja je prazna',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              print('Product: ${item.name}');
              print('Product Pictures: ${item.productPictures}');
              final imageId = item is ProductModel
                  ? (item.productPictures != null &&
                          item.productPictures!.isNotEmpty)
                      ? item.productPictures!.first.id
                      : null
                  : item is DecorationItemModel
                      ? (item.productPictures != null &&
                              item.productPictures!.isNotEmpty)
                          ? item.productPictures!.first.id
                          : null
                      : null;
              print('Image ID: $imageId');

              return WishListItemCard(
                name: item.name ?? '',
                price: item.price ?? 0.0,
                imageId: imageId,
                itemType: item is ProductModel ? 'product' : 'decoration',
                isAvailable: (item.isAvailableInStore ?? false) ||
                    (item.isAvailableOnline ?? false),
                onRemove: () => _handleRemoveFromWishList(item),
                onAddToCart: () => _handleAddToCart(item),
                onTap: () => _navigateToDetails(item),
              );
            },
          );
        },
      ),
    );
  }
}
