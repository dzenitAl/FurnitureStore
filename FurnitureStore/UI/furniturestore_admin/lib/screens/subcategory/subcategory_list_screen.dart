import 'package:flutter/material.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/category/category.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/models/subcategory/subcategory.dart';
import 'package:furniturestore_admin/providers/category_provider.dart';
import 'package:furniturestore_admin/providers/subcategory_provider.dart';
import 'package:furniturestore_admin/screens/subcategory/subcategory_detail_screen.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class SubcategoryListScreen extends StatefulWidget {
  const SubcategoryListScreen({super.key});

  @override
  State<SubcategoryListScreen> createState() => _SubcategoryListScreenState();
}

class _SubcategoryListScreenState extends State<SubcategoryListScreen> {
  late SubcategoryProvider _subcategoryProvider;
  late CategoryProvider _categoryProvider;
  SearchResult<SubcategoryModel>? result;
  SearchResult<CategoryModel>? categoryResult;
  final TextEditingController _nameFilterController = TextEditingController();
  final TextEditingController _categoryNameFilterController =
      TextEditingController();
  Map<int, String> categoryIdToName = {};

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _subcategoryProvider = context.read<SubcategoryProvider>();
    _categoryProvider = context.read<CategoryProvider>();
    _loadData();
  }

  Future<void> _loadData({Map<String, String>? filters}) async {
    var subcategoryData = await _subcategoryProvider.get(filter: filters);
    var categoryData = await _categoryProvider.get();

    setState(() {
      result = subcategoryData;
      categoryResult = categoryData;
      categoryIdToName = {
        for (var category in categoryResult!.result)
          category.id!: category.name ?? ''
      };

      if (filters != null) {
        if (filters['name'] != null && filters['name']!.isNotEmpty) {
          result!.result = result!.result
              .where((subcategory) => subcategory.name!
                  .toLowerCase()
                  .contains(filters['name']!.toLowerCase()))
              .toList();
        }

        if (filters['categoryName'] != null &&
            filters['categoryName']!.isNotEmpty) {
          var filteredCategoryIds = categoryResult!.result
              .where((category) => category.name!
                  .toLowerCase()
                  .contains(filters['categoryName']!.toLowerCase()))
              .map((category) => category.id)
              .toList();

          result!.result = result!.result
              .where((subcategory) =>
                  filteredCategoryIds.contains(subcategory.categoryId))
              .toList();
        }
      }
    });
  }

  void _applyFilters() {
    _loadData(filters: {
      'name': _nameFilterController.text,
      'categoryName': _categoryNameFilterController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("Lista potkategorija"),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Lista potkategorija",
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
                    controller: _categoryNameFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Filtriraj po nazivu kategorije',
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
                  child: const Text("Pretraga"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const SubcategoryDetailScreen(
                          subcategory: null,
                        ),
                      ),
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
                  child: const Text("Dodaj novu potkategoriju"),
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
                          'Kategorija',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1D3557)),
                        ),
                      ),
                      DataColumn(
                          label: Text(
                        '',
                      )),
                    ],
                    rows: result?.result.map((SubcategoryModel subcategory) {
                          return DataRow(
                            onSelectChanged: (selected) {
                              if (selected == true) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SubcategoryDetailScreen(
                                            subcategory: subcategory),
                                  ),
                                );
                              }
                            },
                            cells: [
                              DataCell(
                                Text(
                                  subcategory.name ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C5C7F),
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  categoryIdToName[subcategory.categoryId] ??
                                      '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C5C7F),
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                              DataCell(
                                DeleteModal(
                                  title: 'Potvrda brisanja',
                                  content:
                                      'Da li ste sigurni da želite obrisati ovu potkategoriju?',
                                  onDelete: () async {
                                    await _subcategoryProvider
                                        .delete(subcategory.id!);
                                    _loadData();
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