import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/constants/app_constants.dart';
import 'package:furniturestore_mobile/models/decoration_item/decoration_item.dart';
import 'package:furniturestore_mobile/models/product_pictures/product_pictures.dart';
import 'package:furniturestore_mobile/providers/category_provider.dart';
import 'package:furniturestore_mobile/providers/decoration_item_provider.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:furniturestore_mobile/widgets/master_screen.dart';

class DecorationItemDetailScreen extends StatefulWidget {
  final DecorationItemModel? item;

  const DecorationItemDetailScreen({super.key, this.item});

  @override
  State<DecorationItemDetailScreen> createState() =>
      _DecorationItemDetailScreenState();
}

class _DecorationItemDetailScreenState
    extends State<DecorationItemDetailScreen> {
  late DecorationItemProvider _decorationItemProvider;
  late CategoryProvider _categoryProvider;
  String? _categoryName;
  bool _isLoading = false;
  List<ProductPicturesModel> _pictures = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _decorationItemProvider = context.read<DecorationItemProvider>();
    _categoryProvider = context.read<CategoryProvider>();
    if (widget.item?.categoryId != null) {
      _loadCategoryName();
    }
    if (widget.item?.id != null) {
      _loadImages();
    }
  }

  Future<void> _loadCategoryName() async {
    try {
      final category =
          await _categoryProvider.getById(widget.item!.categoryId!);
      setState(() {
        _categoryName = category.name;
      });
    } catch (e) {
      debugPrint('Error loading category: $e');
    }
  }

  Future<void> _loadImages() async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Authorization.token}'
      };

      final url =
          'http://10.0.2.2:7015/api/ProductPicture/GetByEntityTypeAndId/DecorativeItem/${widget.item!.id}';
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        setState(() {
          _pictures = jsonData
              .map((item) => ProductPicturesModel.fromJson(item))
              .toList();
        });
        print('Loaded ${_pictures.length} images for item ${widget.item!.id}');
      }
    } catch (e) {
      print('Error loading images: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    if (item == null) return const SizedBox.shrink();

    return MasterScreenWidget(
      titleWidget: const Text("Detalji o dekorativnom artiklu"),
      showBackButton: true,
      child: Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFF4A258)),
              )
            : Padding(
                padding: const EdgeInsets.all(16),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildImageCarousel(item),
                      const SizedBox(height: 16),
                      _buildItemInfo(item),
                      const SizedBox(height: 24),
                      _buildActionButtons(item),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildImageCarousel(DecorationItemModel item) {
    if (_pictures.isEmpty) {
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

    return CarouselSlider(
      options: CarouselOptions(
        height: 250,
        viewportFraction: 1.0,
        enableInfiniteScroll: false,
        autoPlay: true,
      ),
      items: _pictures.map((picture) {
        final imageUrl = 'http://10.0.2.2:7015${picture.imagePath}';
        print('Loading image from URL: $imageUrl');

        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            imageUrl,
            fit: BoxFit.cover,
            headers: {'Authorization': 'Bearer ${Authorization.token}'},
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return const Center(
                  child: CircularProgressIndicator(color: Color(0xFFF4A258)));
            },
            errorBuilder: (context, error, stackTrace) {
              print('Error loading image: $error');
              print('Stack trace: $stackTrace');
              return const Center(
                child: Icon(Icons.error_outline, size: 40, color: Colors.grey),
              );
            },
          ),
        );
      }).toList(),
    );
  }

  Widget _buildItemInfo(DecorationItemModel item) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.name ?? '',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3557),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Cijena: ${item.price} KM',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF70BC69),
              ),
            ),
            const SizedBox(height: 8),
            _buildInfoRow('Kategorija', _categoryName ?? ''),
            _buildInfoRow('Opis', item.description ?? ''),
            if (item.dimensions != null && item.dimensions!.isNotEmpty)
              _buildInfoRow('Dimenzije', item.dimensions!),
            if (item.material != null && item.material!.isNotEmpty)
              _buildInfoRow('Materijal', item.material!),
            if (item.style != null && item.style!.isNotEmpty)
              _buildInfoRow('Stil', item.style!),
            if (item.color != null && item.color!.isNotEmpty)
              _buildInfoRow('Boja', item.color!),
            _buildInfoRow(
                'Količina na stanju', item.stockQuantity?.toString() ?? '0'),
            _buildInfoRow(
              'Dostupno u radnji',
              (item.isAvailableInStore == true) ? 'Da' : 'Ne',
            ),
            _buildInfoRow(
              'Dostupno online',
              (item.isAvailableOnline == true) ? 'Da' : 'Ne',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C5C7F),
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF2C5C7F),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(DecorationItemModel item) {
    return Wrap(
      spacing: 16,
      runSpacing: 12,
      children: [
        ElevatedButton.icon(
          onPressed: () {
            if (item.id != null) {
              if (WishList.isDecorationItemInWishList(item.id!)) {
                _showSnackBar(context, 'Artikal je već u listi želja');
              } else {
                WishList.addDecorationItemToWishList(item.id!);
                WishList.cacheDecorationItem(item);
                _showSnackBar(context, 'Artikal dodan u listu želja');
              }
            } else {
              _showSnackBar(context, 'Artikal nema validan ID');
            }
          },
          icon: const Icon(Icons.favorite),
          label: const Text('Dodaj u listu želja'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color.fromARGB(255, 104, 201, 51),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(fontSize: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            if ((item.isAvailableInStore == true) ||
                (item.isAvailableOnline == true)) {
              Order.addDecorationItemToOrder(item);
              _showSnackBar(context, 'Artikal dodan u korpu');
            } else {
              _showUnavailableItemDialog(context);
            }
          },
          icon: const Icon(Icons.add_shopping_cart),
          label: const Text('Dodaj u korpu'),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(fontSize: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () async {
            if (item.id != null) {
              await ProductReservation.addDecorationItemToReservation(item);
              _showSnackBar(context, 'Artikal dodan u listu za rezervaciju');
            } else {
              _showSnackBar(context, 'Artikal nema validan ID');
            }
          },
          icon: const Icon(Icons.bookmark),
          label: const Text('Rezerviši artikal'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF1D3557),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            textStyle: const TextStyle(fontSize: 16),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }

  void _showUnavailableItemDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Nije moguće dodati artikal'),
        content: const Text(
          'Artikal trenutno nije dostupan ni online ni u radnji.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('U redu'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: const Color(0xFF1D3557),
      duration: const Duration(seconds: 2),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
