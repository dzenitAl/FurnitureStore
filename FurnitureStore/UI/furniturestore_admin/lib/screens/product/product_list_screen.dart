import 'package:flutter/material.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/product/product.dart';
import 'package:furniturestore_admin/models/product_pictures/product_pictures.dart';
import 'package:furniturestore_admin/providers/product_provider.dart';
import 'package:furniturestore_admin/providers/subcategory_provider.dart';
import 'package:furniturestore_admin/screens/product/product_detail_screen.dart';
import 'package:furniturestore_admin/utils/utils.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late ProductProvider _productProvider;
  late SubcategoryProvider _subcategoryProvider;
  List<ProductModel>? _allProducts;
  List<ProductModel>? _filteredProducts;
  Map<int, String> _subcategoryIdToName = {};
  final TextEditingController _nameFilterController = TextEditingController();
  final TextEditingController _barcodeFilterController =
      TextEditingController();
  final String _baseUrl = 'http://localhost:7015';

  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productProvider = context.read<ProductProvider>();
    _subcategoryProvider = context.read<SubcategoryProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    var productData = await _productProvider.get();
    var subcategoryData = await _subcategoryProvider.get();
    var subcategoryMap = {
      for (var subcategory in subcategoryData.result)
        subcategory.id!: subcategory.name ?? ''
    };

    await Future.delayed(const Duration(seconds: 1));

    setState(() {
      _isLoading = false;

      _allProducts = productData.result;
      _filteredProducts = _allProducts;
      _subcategoryIdToName = subcategoryMap;
    });
  }

  void _applyFilters() {
    String nameFilter = _nameFilterController.text.toLowerCase();
    String barcodeFilter = _barcodeFilterController.text.toLowerCase();

    setState(() {
      _filteredProducts = _allProducts?.where((product) {
        bool matchesName =
            product.name?.toLowerCase().contains(nameFilter) ?? true;
        bool matchesBarcode =
            product.barcode?.toLowerCase().contains(barcodeFilter) ?? true;
        return matchesName && matchesBarcode;
      }).toList();
    });
  }

  Future<bool> _checkImageAccessible(String url) async {
    try {
      final response = await http.head(
        Uri.parse(url),
        headers: {'Authorization': 'Bearer ${Authorization.token}'},
      );
      print('Image accessibility check for $url: ${response.statusCode}');
      return response.statusCode >= 200 && response.statusCode < 300;
    } catch (e) {
      print('Error checking image accessibility: $e');
      return false;
    }
  }

  Widget _buildProductImage(ProductModel prod) {
    return FutureBuilder<List<ProductPicturesModel>>(
      future: _loadProductImages(prod.id!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            width: 50,
            height: 50,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Icon(Icons.image_not_supported);
        }

        final image = snapshot.data![0];
        if (image.id == null) {
          return const Icon(Icons.image_not_supported);
        }

        final directUrl =
            '$_baseUrl/api/ProductPicture/direct-image/${image.id}';

        return Container(
          width: 50,
          height: 50,
          child: Image.network(
            directUrl,
            fit: BoxFit.cover,
            headers: {'Authorization': 'Bearer ${Authorization.token}'},
            errorBuilder: (context, error, stackTrace) {
              if (image.imagePath != null && image.imagePath!.isNotEmpty) {
                final pathUrl = '$_baseUrl${image.imagePath}';
                return Image.network(
                  pathUrl,
                  fit: BoxFit.cover,
                  headers: {'Authorization': 'Bearer ${Authorization.token}'},
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.image_not_supported),
                );
              }
              return const Icon(Icons.image_not_supported);
            },
          ),
        );
      },
    );
  }

  Future<List<ProductPicturesModel>> _loadProductImages(int productId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Authorization.token}'
      };

      final url = '$_baseUrl/api/ProductPicture/GetByProductId/$productId';
      final response = await http.get(
        Uri.parse(url),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        return jsonData
            .map((item) => ProductPicturesModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      print('Error loading images for product $productId: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("Lista proizvoda"),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Lista proizvoda",
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1D3557),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _nameFilterController,
                        decoration: const InputDecoration(
                          labelText: 'Filtriraj po nazivu',
                          labelStyle: TextStyle(color: Color(0xFF2C5C7F)),
                          border: OutlineInputBorder(),
                          prefixIcon:
                              Icon(Icons.search, color: Color(0xFFF4A258)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF4A258)),
                          ),
                        ),
                        cursorColor: const Color(0xFFF4A258),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        controller: _barcodeFilterController,
                        decoration: const InputDecoration(
                          labelText: 'Filtriraj po barkodu',
                          labelStyle: TextStyle(color: Color(0xFF2C5C7F)),
                          border: OutlineInputBorder(),
                          prefixIcon:
                              Icon(Icons.search, color: Color(0xFFF4A258)),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Color(0xFFF4A258)),
                          ),
                        ),
                        cursorColor: const Color(0xFFF4A258),
                      ),
                    ),
                    const SizedBox(width: 24),
                    ElevatedButton(
                      onPressed: _applyFilters,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFFF4A258),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text("Pretraži"),
                    ),
                    const SizedBox(width: 24),
                    ElevatedButton(
                      onPressed: () async {
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  const ProductDetailScreen(product: null)),
                        );

                        if (result == true) {
                          _loadData();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: const Color(0xFF1D3557),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16.0, horizontal: 24.0),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
                      child: const Text("Dodaj novi proizvod"),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          minWidth: 1200,
                          maxWidth: 2000,
                        ),
                        child: DataTable(
                          columnSpacing: 20.0,
                          horizontalMargin: 12.0,
                          columns: const [
                            DataColumn(
                              label: Text(
                                'Slika',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Naziv',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 67, 85, 111)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Opis',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Barkod',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Cijena',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Dimenzije',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Dostupnost u radnji',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Dostupnost online',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557)),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'Naziv potkategorije',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557)),
                              ),
                            ),
                            DataColumn(
                              label: Text(''),
                            ),
                          ],
                          rows: _filteredProducts?.map((prod) {
                                return DataRow(
                                  onSelectChanged: (selected) async {
                                    if (selected == true) {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ProductDetailScreen(
                                                    product: prod)),
                                      );

                                      if (result == true) {
                                        _loadData();
                                      }
                                    }
                                  },
                                  cells: [
                                    DataCell(_buildProductImage(prod)),
                                    DataCell(Text(
                                      prod.name ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      prod.description ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      prod.barcode ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      formatNumber(prod.price),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      prod.dimensions ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      prod.isAvailableInStore == true
                                          ? 'Da'
                                          : 'Ne',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      prod.isAvailableOnline == true
                                          ? 'Da'
                                          : 'Ne',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      _subcategoryIdToName[
                                              prod.subcategoryId] ??
                                          '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(
                                      DeleteModal(
                                        title: 'Potvrda brisanja',
                                        content:
                                            'Da li ste sigurni da želite obrisati ovaj proizvod?',
                                        onDelete: () async {
                                          await _productProvider
                                              .delete(prod.id!);
                                          setState(() {
                                            _filteredProducts!.remove(prod);
                                          });
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }).toList() ??
                              [],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.3),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
