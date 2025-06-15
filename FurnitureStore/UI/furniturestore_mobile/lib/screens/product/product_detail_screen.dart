import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:io';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/providers/product_provider.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';

class ProductDetailScreen extends StatelessWidget {
  final ProductModel product;

  const ProductDetailScreen({super.key, required this.product});

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
              const SizedBox(height: 24),
              _buildRecommendedProducts(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageCarousel() {
    if (product.productPictures == null || product.productPictures!.isEmpty) {
      return Container(
        height: 250,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey[200],
        ),
        child: const Center(
          child: Icon(Icons.image_not_supported, size: 50, color: Colors.grey),
        ),
      );
    }

    return Container(
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
        items: product.productPictures!.map((picture) {
          const baseUrlWithoutApi = 'http://10.0.2.2:7015';
          final directImageUrl =
              '$baseUrlWithoutApi/api/ProductPicture/direct-image/${picture.id}';
          final pathBasedUrl = '$baseUrlWithoutApi${picture.imagePath}';

          return ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: const Color(0xFFE0E0E0),
              ),
              child: picture.imagePath != null
                  ? _buildImageWithFallback(
                      directImageUrl,
                      pathBasedUrl,
                      picture,
                    )
                  : const Center(
                      child: Icon(
                        Icons.image_not_supported,
                        size: 40,
                        color: Colors.grey,
                      ),
                    ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildImageWithFallback(
    String directUrl,
    String pathUrl,
    dynamic picture,
  ) {
    return Image.network(
      directUrl,
      fit: BoxFit.cover,
      headers: {'Authorization': 'Bearer ${Authorization.token}'},
      errorBuilder: (context, error, stackTrace) {
        return Image.network(
          pathUrl,
          fit: BoxFit.cover,
          headers: {'Authorization': 'Bearer ${Authorization.token}'},
          errorBuilder: (context, error2, stackTrace2) {
            return Image.network(
              pathUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error3, stackTrace3) {
                return Container(
                  color: Colors.red[100],
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 40,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Failed to load image\nID: ${picture.id}\nPath: ${picture.imagePath}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
                );
              },
            );
          },
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          return child;
        }
        return const Center(child: CircularProgressIndicator());
      },
    );
  }

  Widget _buildProductInfo() {
    return Card(
      margin: const EdgeInsets.only(top: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
              style: const TextStyle(fontSize: 16, color: Color(0xFF424530)),
            ),
            const SizedBox(height: 8),
            Text(
              'Dimenzije: ${product.dimensions}',
              style: const TextStyle(fontSize: 16, color: Color(0xFF424530)),
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
                WishList.cacheProduct(product);
                _showSnackBar(context, 'Proizvod dodan u listu želja');
              }
            } else {
              _showSnackBar(context, 'Proizvod nema validan ID');
            }
          },
          icon: const Icon(Icons.favorite),
          label: const Text('Dodaj u listu želja'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 104, 201, 51),
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
          onPressed: () async {
            if (product.id != null) {
              await ProductReservation.addProductToReservation(product);
              _showSnackBar(context, 'Proizvod dodan u listu za rezervaciju');
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

  Widget _buildRecommendedProducts() {
    final productProvider = ProductProvider();

    return FutureBuilder<List<ProductModel>>(
      future: productProvider.getRecommendedProducts(product.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(
            child: Text(
              'Greška pri dohvaćanju preporučenih proizvoda: ${snapshot.error}',
              style: const TextStyle(color: Colors.red),
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text(
              'Nema preporučenih proizvoda',
              style: TextStyle(color: Color(0xFF424530)),
            ),
          );
        } else {
          final recommendedProducts = snapshot.data!;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Preporučeni proizvodi',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D3557),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: recommendedProducts.length,
                  itemBuilder: (context, index) {
                    final product = recommendedProducts[index];
                    return _buildRecommendedProductCard(product, context);
                  },
                ),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _buildRecommendedProductCard(
      ProductModel product, BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailScreen(product: product),
          ),
        );
      },
      child: Container(
        width: 150,
        margin: const EdgeInsets.only(right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: product.productPictures != null &&
                      product.productPictures!.isNotEmpty
                  ? _buildImageWithFallback(
                      'http://10.0.2.2:7015/api/ProductPicture/direct-image/${product.productPictures!.first.id}',
                      'http://10.0.2.2:7015${product.productPictures!.first.imagePath}',
                      product.productPictures!.first,
                    )
                  : Image.asset(
                      'assets/images/furniture_logo.jpg',
                      height: 120,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
            ),
            const SizedBox(height: 8),
            Text(
              product.name ?? '',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${product.price} KM',
              style: const TextStyle(fontSize: 14, color: Color(0xFF70BC69)),
            ),
          ],
        ),
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
