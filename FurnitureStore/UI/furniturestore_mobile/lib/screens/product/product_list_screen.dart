import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/providers/subcategory_provider.dart';
import 'package:furniturestore_mobile/providers/product_provider.dart';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/screens/product/product_detail_screen.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:provider/provider.dart';

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
      setState(() {
        _allProducts = widget.promotionProducts;
        _applyFilters();
      });
    } else {
      var productData = await _productProvider.get("");
      setState(() {
        _allProducts = productData.result;
        _applyFilters();
      });
    }
  }

  void _applyFilters() {
    String nameFilter = _nameFilterController.text.toLowerCase();

    setState(() {
      _filteredProducts = _allProducts?.where((product) {
        bool matchesSubcategory = widget.subcategoryId == null ||
            product.subcategoryId == widget.subcategoryId;

        bool matchesName =
            product.name?.toLowerCase().contains(nameFilter) ?? true;

        return matchesSubcategory && matchesName;
      }).toList();
    });
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
                const SizedBox(width: 16),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: _filteredProducts != null && _filteredProducts!.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredProducts!.length,
                      itemBuilder: (context, index) {
                        var product = _filteredProducts![index];
                        return Card(
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            title: Text(
                              product.name ?? '',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1D3557),
                              ),
                            ),
                            subtitle: Text(
                              _subcategoryIdToName[product.subcategoryId] ?? '',
                              style: const TextStyle(color: Color(0xFF2C5C7F)),
                            ),
                            trailing: Text(
                              "${product.price ?? 0.0} KM",
                              style: const TextStyle(
                                color: Color(0xFFF4A258),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => ProductDetailScreen(
                                    product: product,
                                    imageFiles: [], // for now
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      },
                    )
                  : const Center(child: Text("Nema pronađenih proizvoda")),
            ),
          ],
        ),
      ),
    );
  }
}
