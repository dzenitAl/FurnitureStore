import 'package:flutter/material.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/product/product.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/product_provider.dart';
import 'package:furniturestore_admin/providers/subcategory_provider.dart';
import 'package:furniturestore_admin/screens/product/product_detail_screen.dart';
import 'package:furniturestore_admin/utils/utils.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productProvider = context.read<ProductProvider>();
    _subcategoryProvider = context.read<SubcategoryProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    var productData = await _productProvider.get();

    var subcategoryData = await _subcategoryProvider.get();
    var subcategoryMap = {
      for (var subcategory in subcategoryData.result)
        subcategory.id!: subcategory.name ?? ''
    };

    setState(() {
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("Lista proizvoda"),
      child: Container(
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
                      prefixIcon: Icon(Icons.search, color: Color(0xFFF4A258)),
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
                      prefixIcon: Icon(Icons.search, color: Color(0xFFF4A258)),
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            ProductDetailScreen(product: null),
                      ),
                    );
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
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Naziv',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D3557)),
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
                        label: Text(
                          '',
                        ),
                      ),
                    ],
                    rows: _filteredProducts?.map((prod) {
                          return DataRow(
                            onSelectChanged: (selected) {
                              if (selected == true) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductDetailScreen(product: prod),
                                  ),
                                );
                              }
                            },
                            cells: [
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
                                prod.isAvailableInStore == true ? 'Da' : 'Ne',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C5C7F),
                                  fontFamily: 'Roboto',
                                ),
                              )),
                              DataCell(Text(
                                prod.isAvailableOnline == true ? 'Da' : 'Ne',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C5C7F),
                                  fontFamily: 'Roboto',
                                ),
                              )),
                              DataCell(Text(
                                _subcategoryIdToName[prod.subcategoryId] ?? '',
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
                                    await _productProvider.delete(prod.id!);
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
          ],
        ),
      ),
    );
  }
}
