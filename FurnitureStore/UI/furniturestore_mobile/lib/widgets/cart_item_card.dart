import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/constants/app_constants.dart';

class CartItemCard extends StatelessWidget {
  final String name;
  final double unitPrice;
  final int quantity;
  final String? imageUrl;
  final int? imageId;
  final String? imagePath;
  final VoidCallback onDecrement;
  final VoidCallback onIncrement;
  final VoidCallback onRemove;
  final String itemType; // 'product', 'giftCard', or 'decoration'

  const CartItemCard({
    super.key,
    required this.name,
    required this.unitPrice,
    required this.quantity,
    this.imageUrl,
    this.imageId,
    this.imagePath,
    required this.onDecrement,
    required this.onIncrement,
    required this.onRemove,
    required this.itemType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _buildImage(),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildName(),
                      const SizedBox(height: 6),
                      _buildUnitPrice(),
                      const SizedBox(height: 8),
                      _buildQuantityControls(),
                      const SizedBox(height: 10),
                      _buildTotalPrice(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildRemoveButton(context),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFFE0E0E0),
        image: DecorationImage(
          image: _getImageProvider(),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  ImageProvider _getImageProvider() {
    if (itemType == 'giftCard' && imagePath != null && imagePath!.isNotEmpty) {
      final imageUrl = imagePath!.startsWith('http')
          ? imagePath!
          : '${AppConstants.baseUrl}$imagePath';
      return NetworkImage(imageUrl);
    }

    if (imageId != null) {
      return NetworkImage(
          '${AppConstants.baseUrl}/api/ProductPicture/direct-image/$imageId');
    }

    return const AssetImage('assets/images/furniture_logo.jpg')
        as ImageProvider;
  }

  Widget _buildName() {
    return Text(
      name,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF1D3557),
      ),
    );
  }

  Widget _buildUnitPrice() {
    return Text(
      'Jedinična cijena: ${unitPrice.toStringAsFixed(2)} BAM',
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xFF1D3557),
      ),
    );
  }

  Widget _buildQuantityControls() {
    return Row(
      children: [
        _buildQuantityButton(Icons.remove, onDecrement),
        const SizedBox(width: 12),
        Text(
          '$quantity',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 12),
        _buildQuantityButton(Icons.add, onIncrement),
      ],
    );
  }

  Widget _buildQuantityButton(IconData icon, VoidCallback onPressed) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(icon, size: 20),
      ),
    );
  }

  Widget _buildTotalPrice() {
    return Text(
      'Ukupno: ${(unitPrice * quantity).toStringAsFixed(2)} BAM',
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF70BC69),
      ),
    );
  }

  Widget _buildRemoveButton(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: InkWell(
        onTap: () => _showRemoveConfirmationDialog(context),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.red.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          padding: const EdgeInsets.all(6),
          child: const Icon(
            Icons.close,
            color: Colors.white,
            size: 18,
          ),
        ),
      ),
    );
  }

  void _showRemoveConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Potvrda brisanja'),
        content: Text(
            'Da li ste sigurni da želite ukloniti ovaj ${itemType == 'product' ? 'proizvod' : itemType == 'giftCard' ? 'poklon bon' : 'dekoraciju'} iz korpe?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Odustani'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
          ),
          ElevatedButton(
            onPressed: () {
              onRemove();
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
            ),
            child: const Text('Ukloni'),
          ),
        ],
      ),
    );
  }
}
