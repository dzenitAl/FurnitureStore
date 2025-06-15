import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:furniturestore_mobile/widgets/base_item_card.dart';

class WishListItemCard extends StatelessWidget {
  final String name;
  final double price;
  final int? imageId;
  final VoidCallback onRemove;
  final VoidCallback onAddToCart;
  final VoidCallback? onTap;
  final bool isAvailable;
  final String itemType;

  const WishListItemCard({
    super.key,
    required this.name,
    required this.price,
    this.imageId,
    required this.onRemove,
    required this.onAddToCart,
    this.onTap,
    required this.isAvailable,
    required this.itemType,
  });

  @override
  Widget build(BuildContext context) {
    return BaseItemCard(
      name: name,
      price: price,
      imageId: imageId,
      itemType: itemType,
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            onPressed: isAvailable ? onAddToCart : null,
            tooltip: isAvailable ? 'Dodaj u korpu' : 'Proizvod nije dostupan',
            color: isAvailable ? null : Colors.grey,
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: onRemove,
            tooltip: 'Ukloni iz liste želja',
          ),
        ],
      ),
    );
  }
}
