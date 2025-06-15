import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/constants/app_constants.dart';
import 'package:furniturestore_mobile/utils/utils.dart';

class BaseItemCard extends StatelessWidget {
  final String name;
  final double price;
  final String? imageUrl;
  final int? imageId;
  final List<Widget>? actions;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? subtitle;
  final bool showPrice;
  final String? itemType;

  const BaseItemCard({
    super.key,
    required this.name,
    required this.price,
    this.imageUrl,
    this.imageId,
    this.actions,
    this.onTap,
    this.trailing,
    this.subtitle,
    this.showPrice = true,
    this.itemType,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
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
                    if (subtitle != null) ...[
                      const SizedBox(height: 4),
                      subtitle!,
                    ],
                    if (showPrice) ...[
                      const SizedBox(height: 6),
                      _buildPrice(),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 8),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImage() {
    print('Building image with ID: $imageId');
    final imageUrl = imageId != null
        ? '${AppConstants.baseUrl}/api/ProductPicture/direct-image/$imageId'
        : null;
    print('Image URL: $imageUrl');

    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: AppConstants.colors['background'],
      ),
      child: imageId != null
          ? Image.network(
              imageUrl!,
              fit: BoxFit.cover,
              headers: {'Authorization': 'Bearer ${Authorization.token}'},
              errorBuilder: (context, error, stackTrace) {
                print('Error loading image: $error');
                return Icon(Icons.error_outline,
                    size: 40, color: Colors.grey[400]);
              },
            )
          : Icon(Icons.image_not_supported, size: 40, color: Colors.grey[400]),
    );
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

  Widget _buildPrice() {
    return Text(
      '${price.toStringAsFixed(2)} BAM',
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF70BC69),
      ),
    );
  }
}
