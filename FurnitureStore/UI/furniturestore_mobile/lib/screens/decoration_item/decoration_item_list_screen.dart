import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/decoration_item/decoration_item.dart';
import 'package:furniturestore_mobile/models/product_pictures/product_pictures.dart';
import 'package:furniturestore_mobile/providers/decoration_item_provider.dart';
import 'package:furniturestore_mobile/providers/category_provider.dart';
import 'package:furniturestore_mobile/screens/decoration_item/decoration_item_detail_screen.dart';
import 'package:furniturestore_mobile/utils/common_methods.dart';
import 'package:provider/provider.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:furniturestore_mobile/constants/app_constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:furniturestore_mobile/widgets/master_screen.dart';

class DecorationItemListScreen extends StatefulWidget {
  const DecorationItemListScreen({super.key});

  @override
  State<DecorationItemListScreen> createState() =>
      _DecorationItemListScreenState();
}

class _DecorationItemListScreenState extends State<DecorationItemListScreen> {
  late DecorationItemProvider _decorationItemProvider;
  late CategoryProvider _categoryProvider;
  final TextEditingController _searchController = TextEditingController();
  List<DecorationItemModel>? _allItems;
  List<DecorationItemModel>? _filteredItems;
  bool _isLoading = false;

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
      print('Loading decoration items data...');
      print(
          'Auth token: ${Authorization.token != null ? 'Token exists' : 'Token is null'}');

      var itemData = await _decorationItemProvider.get("");
      print('Loaded ${itemData.result.length} decoration items');

      if (itemData.result.isNotEmpty) {
        print(
            'First item details: ${jsonEncode(itemData.result.first.toJson())}');
      }

      var categoryData = await _categoryProvider.get("");
      var categoryMap = {
        for (var category in categoryData.result)
          category.id: category.name ?? ''
      };

      setState(() {
        _isLoading = false;
        _allItems = itemData.result;
        _filteredItems = _allItems;
      });
    } catch (e) {
      debugPrint('Error loading decoration items: $e');
      print('Error loading decoration items: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _applyFilters() {
    String searchText = _searchController.text.toLowerCase();
    setState(() {
      _filteredItems = _allItems?.where((item) {
        return item.name?.toLowerCase().contains(searchText) ?? true;
      }).toList();
    });
  }

  Future<List<ProductPicturesModel>> loadDecorationImages(int itemId) async {
    try {
      final headers = {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer ${Authorization.token}'
      };

      final url =
          'http://10.0.2.2:7015/api/ProductPicture/GetByEntityTypeAndId/DecorativeItem/$itemId';
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body) as List;
        return jsonData
            .map((item) => ProductPicturesModel.fromJson(item))
            .toList();
      }
      return [];
    } catch (e) {
      print('Greška pri učitavanju slika za item $itemId: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("Lista dekorativnih artikala"),
      showBackButton: true,
      child: Scaffold(
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFF4A258)))
            : Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        labelText: 'Filtriraj po nazivu',
                        prefixIcon:
                            const Icon(Icons.search, color: Color(0xFFF4A258)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide:
                              const BorderSide(color: Color(0xFFF4A258)),
                        ),
                      ),
                      onChanged: (_) => _applyFilters(),
                    ),
                  ),
                  Expanded(
                    child: _filteredItems == null || _filteredItems!.isEmpty
                        ? const Center(
                            child: Text(
                              'Nema podataka za prikaz.',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey),
                            ),
                          )
                        : GridView.builder(
                            padding: const EdgeInsets.all(16),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.75,
                              crossAxisSpacing: 16,
                              mainAxisSpacing: 16,
                            ),
                            itemCount: _filteredItems!.length,
                            itemBuilder: (context, index) {
                              final item = _filteredItems![index];
                              return GestureDetector(
                                onTap: () async {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          DecorationItemDetailScreen(
                                        item: item,
                                      ),
                                    ),
                                  );
                                  if (result == true) {
                                    _loadData();
                                  }
                                },
                                child: Card(
                                  elevation: 4,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 160,
                                        width: double.infinity,
                                        child: ClipRRect(
                                          borderRadius:
                                              const BorderRadius.vertical(
                                                  top: Radius.circular(12)),
                                          child: FutureBuilder<
                                              List<ProductPicturesModel>>(
                                            future:
                                                loadDecorationImages(item.id!),
                                            builder: (context, snapshot) {
                                              if (snapshot.connectionState ==
                                                  ConnectionState.waiting) {
                                                return const Center(
                                                    child:
                                                        CircularProgressIndicator(
                                                            color: Color(
                                                                0xFFF4A258)));
                                              }

                                              if (!snapshot.hasData ||
                                                  snapshot.data!.isEmpty) {
                                                return const Center(
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                    color: Colors.grey,
                                                    size: 40,
                                                  ),
                                                );
                                              }

                                              final imageUrl = snapshot
                                                  .data!.first.imagePath;
                                              return Image.network(
                                                'http://10.0.2.2:7015$imageUrl',
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                                height: double.infinity,
                                                headers: {
                                                  'Authorization':
                                                      'Bearer ${Authorization.token}'
                                                },
                                                loadingBuilder: (context, child,
                                                    loadingProgress) {
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
                                                      color: const Color(
                                                          0xFFF4A258),
                                                    ),
                                                  );
                                                },
                                                errorBuilder: (context, error,
                                                    stackTrace) {
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
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                const Icon(Icons.label,
                                                    color: Color(0xFF2C5C7F),
                                                    size: 20),
                                                const SizedBox(width: 6),
                                                Expanded(
                                                  child: Text(
                                                    item.name ?? '',
                                                    style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Color(0xFF2C5C7F),
                                                    ),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 4),
                                            Row(
                                              children: [
                                                const Icon(
                                                    Icons.monetization_on,
                                                    color: Color(0xFFF4A258),
                                                    size: 20),
                                                const SizedBox(width: 6),
                                                Text(
                                                  '${formatNumber(item.price)} KM',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    color: Color(0xFFF4A258),
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              ),
      ),
    );
  }
}
