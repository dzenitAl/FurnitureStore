import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/providers/subcategory_provider.dart';
import 'package:furniturestore_mobile/providers/product_provider.dart';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/screens/product/product_detail_screen.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:furniturestore_mobile/utils/utils.dart';

class ProductListScreen extends StatefulWidget {
  final int? subcategoryId;
  final List<ProductModel>? promotionProducts;

  const ProductListScreen(
      {super.key, this.subcategoryId, this.promotionProducts});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider _productProvider;
  late SubcategoryProvider _subcategoryProvider;
  List<ProductModel>? _allProducts;
  List<ProductModel>? _filteredProducts;
  final Map<int, String> _subcategoryIdToName = {};
  final TextEditingController _nameFilterController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productProvider = context.read<ProductProvider>();
    _subcategoryProvider = context.read<SubcategoryProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    if (widget.promotionProducts != null) {
      _allProducts = widget.promotionProducts;
    } else {
      var productData = await _productProvider.get("");
      _allProducts = productData.result;
    }

    var subcategoryData = await _subcategoryProvider.get("");
    _subcategoryIdToName.clear();
    for (var subcategory in subcategoryData.result) {
      _subcategoryIdToName[subcategory.id!] = subcategory.name!;
    }

    _applyFilters();
  }

  void _applyFilters() {
    String nameFilter = _nameFilterController.text.toLowerCase();

    setState(() {
      _filteredProducts = _allProducts?.where((product) {
        final matchesSubcategory = widget.subcategoryId == null ||
            product.subcategoryId == widget.subcategoryId;
        final matchesName =
            product.name?.toLowerCase().contains(nameFilter) ?? true;
        return matchesSubcategory && matchesName;
      }).toList();
    });
  }

  String _formatPrice(double? price) {
    final formatter =
        NumberFormat.currency(locale: 'bs_BA', symbol: '', decimalDigits: 2);
    return formatter.format(price ?? 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Lista proizvoda",
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _nameFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Filtriraj po nazivu',
                      prefixIcon: Icon(Icons.search, color: Color(0xFFF4A258)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF4A258)),
                      ),
                    ),
                    onChanged: (value) => _applyFilters(),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredProducts != null && _filteredProducts!.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredProducts!.length,
                      itemBuilder: (context, index) {
                        final product = _filteredProducts![index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => ProductDetailScreen(
                                  product: product,
                                  // imageFiles: const [],
                                ),
                              ),
                            );
                          },
                          child: Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Row(
                                children: [
                                  Container(
                                    width: 120,
                                    height: 120,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(8),
                                      color: Colors.grey[200],
                                    ),
                                    child: product.productPictures != null &&
                                            product.productPictures!.isNotEmpty
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            child: Builder(
                                              builder: (context) {
                                                // Debug prints
                                                print(
                                                    'Product: ${product.name}');
                                                print(
                                                    'Pictures length: ${product.productPictures?.length}');
                                                print(
                                                    'First picture ID: ${product.productPictures?.firstOrNull?.id}');

                                                if (product.productPictures
                                                        ?.firstOrNull?.id ==
                                                    null) {
                                                  return const Center(
                                                    child: Icon(
                                                      Icons.image_not_supported,
                                                      color: Colors.grey,
                                                      size: 40,
                                                    ),
                                                  );
                                                }

                                                return Image.network(
                                                  'http://10.0.2.2:7015/api/ProductPicture/direct-image/${product.productPictures!.first.id}',
                                                  fit: BoxFit.cover,
                                                  loadingBuilder: (context,
                                                      child, loadingProgress) {
                                                    if (loadingProgress == null)
                                                      return child;
                                                    return Center(
                                                      child:
                                                          CircularProgressIndicator(
                                                        value: loadingProgress
                                                                    .expectedTotalBytes !=
                                                                null
                                                            ? loadingProgress
                                                                    .cumulativeBytesLoaded /
                                                                loadingProgress
                                                                    .expectedTotalBytes!
                                                            : null,
                                                      ),
                                                    );
                                                  },
                                                  errorBuilder: (context, error,
                                                      stackTrace) {
                                                    print(
                                                        'Error loading image: $error');
                                                    return const Center(
                                                      child: Icon(
                                                        Icons.error_outline,
                                                        color: Colors.grey,
                                                        size: 40,
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                            ),
                                          )
                                        : const Center(
                                            child: Icon(
                                              Icons.image_not_supported,
                                              color: Colors.grey,
                                              size: 40,
                                            ),
                                          ),
                                  ),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          product.name ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: Color(0xFF1D3557),
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          "Podkategorija: ${_subcategoryIdToName[product.subcategoryId] ?? '-'}",
                                          style: const TextStyle(
                                            fontSize: 13,
                                            color: Color(0xFF1D3557),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          children: [
                                            Icon(
                                              product.isAvailableInStore == true
                                                  ? Icons.check_circle_outline
                                                  : Icons.cancel_outlined,
                                              color:
                                                  product.isAvailableInStore ==
                                                          true
                                                      ? Colors.green
                                                      : Colors.red,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              product.isAvailableInStore == true
                                                  ? "Dostupno u trgovini"
                                                  : "Nije dostupno u trgovini",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                    product.isAvailableInStore ==
                                                            true
                                                        ? Colors.green
                                                        : Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Row(
                                          children: [
                                            Icon(
                                              product.isAvailableOnline == true
                                                  ? Icons.check_circle_outline
                                                  : Icons.cancel_outlined,
                                              color:
                                                  product.isAvailableOnline ==
                                                          true
                                                      ? Colors.green
                                                      : Colors.red,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              product.isAvailableOnline == true
                                                  ? "Dostupno online"
                                                  : "Nije dostupno online",
                                              style: TextStyle(
                                                fontSize: 13,
                                                color:
                                                    product.isAvailableOnline ==
                                                            true
                                                        ? Colors.green
                                                        : Colors.red,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          "${_formatPrice(product.price)} KM",
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF1D3557),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        "Nema pronađenih proizvoda",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
            )
          ],
        ),
      ),
    );
  }
}
