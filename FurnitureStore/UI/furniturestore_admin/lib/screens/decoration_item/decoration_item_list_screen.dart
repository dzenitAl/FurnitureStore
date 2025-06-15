import 'package:flutter/material.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/decoration_item/decoration_item.dart';
import 'package:furniturestore_admin/providers/decoration_item_provider.dart';
import 'package:furniturestore_admin/providers/category_provider.dart';
import 'package:furniturestore_admin/screens/decoration_item/decoration_item_detail_screen.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:furniturestore_admin/utils/utils.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:furniturestore_admin/models/product_pictures/product_pictures.dart';

class DecorationItemListScreen extends StatefulWidget {
  const DecorationItemListScreen({super.key});

  @override
  State<DecorationItemListScreen> createState() =>
      _DecorationItemListScreenState();
}

class _DecorationItemListScreenState extends State<DecorationItemListScreen> {
  late DecorationItemProvider _decorationItemProvider;
  late CategoryProvider _categoryProvider;
  List<DecorationItemModel>? _allItems;
  List<DecorationItemModel>? _filteredItems;
  Map<int, String> _categoryIdToName = {};
  final TextEditingController _nameFilterController = TextEditingController();
  bool _isLoading = false;
  final String _baseUrl = 'http://localhost:7015';

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _decorationItemProvider = context.read<DecorationItemProvider>();
    _categoryProvider = context.read<CategoryProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      var itemData = await _decorationItemProvider.get();
      var categoryData = await _categoryProvider.get();
      var categoryMap = {
        for (var category in categoryData.result)
          category.id!: category.name ?? ''
      };

      await Future.delayed(const Duration(seconds: 1));

      setState(() {
        _isLoading = false;
        _allItems = itemData.result;
        _filteredItems = _allItems;
        _categoryIdToName = categoryMap;
      });
    } catch (e) {
      debugPrint('Error loading decoration items: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    String nameFilter = _nameFilterController.text.toLowerCase();

    setState(() {
      _filteredItems = _allItems?.where((item) {
        return item.name?.toLowerCase().contains(nameFilter) ?? true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text(
        "Lista dekorativnih proizvoda",
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1D3557),
        ),
      ),
      child: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFF4A258)))
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _nameFilterController,
                          decoration: const InputDecoration(
                            labelText: 'Pretraži po nazivu',
                            labelStyle: TextStyle(color: Color(0xFF2C5C7F)),
                            border: OutlineInputBorder(),
                            prefixIcon:
                                Icon(Icons.search, color: Color(0xFFF4A258)),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xFFF4A258)),
                            ),
                          ),
                          cursorColor: const Color(0xFFF4A258),
                          onChanged: (_) => _applyFilters(),
                        ),
                      ),
                      const SizedBox(width: 24),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const DecorationItemDetailScreen(),
                            ),
                          );

                          if (result == true) {
                            _loadData();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.white,
                          backgroundColor: const Color(0xFFF4A258),
                          padding: const EdgeInsets.symmetric(
                              vertical: 16.0, horizontal: 24.0),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: const Text("Dodaj novi"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Expanded(
                  child: _filteredItems == null || _filteredItems!.isEmpty
                      ? const Center(
                          child: Text(
                            'Nema podataka za prikaz.',
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        )
                      : SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingTextStyle: const TextStyle(
                                color: Color.fromARGB(255, 67, 85, 111),
                                fontWeight: FontWeight.bold,
                              ),
                              columns: const [
                                DataColumn(label: Text('Slika')),
                                DataColumn(label: Text('Naziv')),
                                DataColumn(label: Text('Opis')),
                                DataColumn(label: Text('Cijena')),
                                DataColumn(label: Text('Dimenzije')),
                                DataColumn(label: Text('Materijal')),
                                DataColumn(label: Text('Stil')),
                                DataColumn(label: Text('Boja')),
                                DataColumn(label: Text('Količina')),
                                DataColumn(label: Text('Kategorija')),
                                DataColumn(
                                    label: Text('Dostupno u prodavnici')),
                                DataColumn(label: Text('Dostupno online')),
                                DataColumn(label: Text('')),
                              ],
                              rows: _filteredItems!.map((item) {
                                return DataRow(
                                  onSelectChanged: (selected) async {
                                    if (selected == true) {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              DecorationItemDetailScreen(
                                                  item: item),
                                        ),
                                      );

                                      if (result == true) {
                                        _loadData();
                                      }
                                    }
                                  },
                                  cells: [
                                    DataCell(_buildDecorationImage(item)),
                                    DataCell(Text(
                                      item.name ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      item.description ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      formatNumber(item.price),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      item.dimensions ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      item.material ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      item.style ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      item.color ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      item.stockQuantity?.toString() ?? '0',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      _categoryIdToName[item.categoryId] ?? '',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(Text(
                                      item.isAvailableInStore == true
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
                                      item.isAvailableOnline == true
                                          ? 'Da'
                                          : 'Ne',
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    )),
                                    DataCell(
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: Colors.red),
                                        onPressed: () async {
                                          final shouldDelete =
                                              await showDialog<bool>(
                                            context: context,
                                            builder: (context) => DeleteModal(
                                              title:
                                                  'Brisanje dekorativnog predmeta',
                                              content:
                                                  'Da li ste sigurni da želite obrisati ovaj dekorativni predmet?',
                                              onDelete: () async {
                                                if (item.id != null) {
                                                  await _decorationItemProvider
                                                      .delete(item.id!);
                                                  _loadData();
                                                  Navigator.pop(context, true);
                                                }
                                              },
                                            ),
                                          );

                                          if (shouldDelete == true &&
                                              item.id != null) {
                                            await _decorationItemProvider
                                                .delete(item.id!);
                                            _loadData();
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildDecorationImage(DecorationItemModel item) {
    return FutureBuilder<List<ProductPicturesModel>>(
      future: _loadDecorationImages(item.id!),
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

  Future<List<ProductPicturesModel>> _loadDecorationImages(int itemId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Authorization.token}'
      };

      final url =
          '$_baseUrl/api/ProductPicture/GetByEntityTypeAndId/DecorativeItem/$itemId';
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
      print('Error loading images for decoration item $itemId: $e');
      return [];
    }
  }
}
