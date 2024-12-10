import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;
  final List<File> imageFiles;

  const ProductDetailScreen({
    super.key,
    required this.product,
    required this.imageFiles,
  });

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Detalji o proizvodu: ${product.name}',
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImageCarousel(),
              const SizedBox(height: 16),
              _buildProductInfo(),
              const SizedBox(height: 24),
              _buildActionButtons(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    return imageFiles.isNotEmpty
        ? Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey[200],
            ),
            child: CarouselSlider(
              options: CarouselOptions(
                height: 250,
                viewportFraction: 1.0,
                enableInfiniteScroll: false,
                autoPlay: true,
              ),
              items: imageFiles.map((imageFile) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    imageFile,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                );
              }).toList(),
            ),
          )
        : const Center(child: Text('No images available'));
  }

  Widget _buildProductInfo() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name ?? "",
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3557),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cijena: ${product.price} KM',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF70BC69),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Opis: ${product.description}',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF424530),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Dimenzije: ${product.dimensions}',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF424530),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildAvailabilityInfo(
                  label: 'Dostupno u radnji',
                  isAvailable: product.isAvailableInStore ?? false,
                ),
                const SizedBox(width: 16),
                _buildAvailabilityInfo(
                  label: 'Dostupno online',
                  isAvailable: product.isAvailableOnline ?? false,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAvailabilityInfo({
    required String label,
    required bool isAvailable,
  }) {
    return Row(
      children: [
        Icon(
          isAvailable ? Icons.check_circle : Icons.cancel,
          color: isAvailable ? const Color(0xFF70BC69) : Colors.red,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 16,
            color: isAvailable ? const Color(0xFF424530) : Colors.red,
          ),
        ),
      ],
    );
  }

  void _showUnavailableProductDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nije moguće dodati proizvod'),
          content: const Text(
            'Proizvod trenutno nije dostupan ni online ni u radnji.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('U redu'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.start,
      spacing: 16.0,
      runSpacing: 12.0,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            if (product.id != null) {
              if (WishList.isProductInWishList(product.id!)) {
                _showSnackBar(context, 'Proizvod je već u listi želja');
              } else {
                WishList.addProductToWishList(product.id!);
                _showSnackBar(context, 'Proizvod dodan u listu želja');
              }
            } else {
              _showSnackBar(context, 'Proizvod nema validan ID');
            }
          },
          icon: const Icon(Icons.favorite),
          label: const Text('Dodaj u listu želja'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromARGB(255, 104, 201, 51),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if ((product.isAvailableInStore ?? false) ||
                (product.isAvailableOnline ?? false)) {
              Order.addProductToOrder(product);
              _showSnackBar(context, 'Proizvod dodan u narudžbu');
            } else {
              _showUnavailableProductDialog(context);
            }
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Dodaj u korpu'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if (product.id != null) {
              ProductReservation.addProductToReservation(product);
              _showSnackBar(context, 'Proizvod rezervisan');
            } else {
              _showSnackBar(context, 'Proizvod nema validan ID');
            }
          },
          icon: const Icon(Icons.bookmark),
          label: const Text('Rezerviši proizvod'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1D3557),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(fontSize: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      ],
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}
