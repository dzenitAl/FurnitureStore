import 'package:flutter/material.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/category/category.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';
import 'package:furniturestore_admin/providers/category_provider.dart';
import 'package:furniturestore_admin/screens/category/category_detail_screen.dart';
import 'package:furniturestore_admin/utils/utils.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  late CategoryProvider _categoryProvider;
  SearchResult<CategoryModel>? result;
  final TextEditingController _nameFilterController = TextEditingController();
  bool _isLoading = false;
  final String baseUrl = 'http://localhost:7015';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _categoryProvider = context.read<CategoryProvider>();
    _loadData();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _loadData({Map<String, String>? filters}) async {
    setState(() {
      _isLoading = true;
    });

    try {
      print("Loading categories...");
      var data = await _categoryProvider.get();

      print("Raw category data: ${data.result}");

      setState(() {
        result = data;
        _isLoading = false;
      });

      print("Categories loaded: ${result?.result.length}");
      for (var category in result?.result ?? []) {
        print(
            "Category: ${category.name}, Image path: ${category.imagePath}, Raw: $category");
      }
    } catch (e, stackTrace) {
      print("Error loading categories: $e");
      print("Stack trace: $stackTrace");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    _loadData(filters: {
      'name': _nameFilterController.text,
    });
  }

  Widget _buildCategoryImage(CategoryModel category) {
    if (category.imagePath == null || category.imagePath!.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported),
      );
    }

    final imageUrl = category.imagePath!.startsWith('http')
        ? category.imagePath!
        : '$baseUrl${category.imagePath}';

    return Image.network(
      imageUrl,
      fit: BoxFit.cover,
      headers: {'Authorization': 'Bearer ${Authorization.token}'},
      errorBuilder: (context, error, stackTrace) {
        print("Error loading image: $error");
        return Container(
          color: Colors.grey[200],
          child: const Icon(Icons.image_not_supported),
        );
      },
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return Center(
          child: CircularProgressIndicator(
            value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded /
                    loadingProgress.expectedTotalBytes!
                : null,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("Lista kategorija"),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Lista kategorija",
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
                          labelText: 'Filtriraj po nazivu kategorije',
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
                        bool? shouldRefresh = await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => CategoryDetailScreen(
                              category: null,
                            ),
                          ),
                        );

                        if (shouldRefresh ?? false) {
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
                      child: const Text("Dodaj novu kategoriju"),
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
                            label: Text(''),
                          ),
                        ],
                        rows: result?.result.map((CategoryModel category) {
                              return DataRow(
                                onSelectChanged: (selected) async {
                                  if (selected == true) {
                                    final result =
                                        await Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            CategoryDetailScreen(
                                                category: category),
                                      ),
                                    );

                                    if (result == true) {
                                      _loadData();
                                    }
                                  }
                                },
                                cells: [
                                  DataCell(
                                    Container(
                                      width: 60,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                          color: Colors.grey[300]!,
                                          width: 1,
                                        ),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: _buildCategoryImage(category),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      category.name ?? '',
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                  DataCell(
                                    Text(
                                      category.description ?? '',
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
                                          'Da li ste sigurni da želite obrisati ovu kategoriju?',
                                      onDelete: () async {
                                        await _categoryProvider
                                            .delete(category.id!);
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
