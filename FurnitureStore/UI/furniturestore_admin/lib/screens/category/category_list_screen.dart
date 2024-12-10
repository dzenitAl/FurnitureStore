import 'package:flutter/material.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/category/category.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/category_provider.dart';
import 'package:furniturestore_admin/screens/category/category_detail_screen.dart';
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

  _loadData({Map<String, String>? filters}) async {
    var data = await _categoryProvider.get();

    setState(() {
      result = SearchResult<CategoryModel>();
      result!.count = data.count;

      final nameFilter = _nameFilterController.text.toLowerCase();

      if (nameFilter.isEmpty) {
        result!.result = data.result;
      } else {
        result!.result = data.result.where((category) {
          final categoryName = category.name?.toLowerCase() ?? '';
          return categoryName.contains(nameFilter);
        }).toList();
      }
    });
  }

  void _applyFilters() {
    _loadData(filters: {
      'name': _nameFilterController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("Lista kategorija"),
      child: Container(
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
                          '',
                        ),
                      ),
                    ],
                    rows: result?.result.map((CategoryModel category) {
                          return DataRow(
                            onSelectChanged: (selected) {
                              if (selected == true) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => CategoryDetailScreen(
                                        category: category),
                                  ),
                                );
                              }
                            },
                            cells: [
                              DataCell(
                                Text(
                                  category.name ?? '',
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
                                  category.description ?? '',
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
    );
  }
}
