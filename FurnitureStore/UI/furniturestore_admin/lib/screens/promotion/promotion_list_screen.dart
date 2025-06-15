import 'package:flutter/material.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/promotion/promotion.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/providers/promotion_provider.dart';
import 'package:furniturestore_admin/screens/promotion/promotion_detail_screen.dart';
import 'package:furniturestore_admin/utils/utils.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class PromotionListScreen extends StatefulWidget {
  const PromotionListScreen({super.key});

  @override
  State<PromotionListScreen> createState() => _PromotionListScreenState();
}

class _PromotionListScreenState extends State<PromotionListScreen> {
  late PromotionProvider _promotionProvider;
  late AccountProvider _accountProvider;
  SearchResult<PromotionModel>? result;
  Map<String, String> adminNameMap = {};
  final TextEditingController _nameFilterController = TextEditingController();
  bool _isLoading = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _promotionProvider = context.read<PromotionProvider>();
    _accountProvider = context.read<AccountProvider>();
    _loadData();
  }

  Future<void> _loadData({Map<String, String>? filters}) async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(seconds: 1));

    try {
      var promotionData = await _promotionProvider.get();

      var adminResult = await _accountProvider.getAll();

      adminNameMap = {
        for (var admin in adminResult.result)
          if (admin.id != null) admin.id!: admin.fullName ?? ''
      };

      final nameFilter = _nameFilterController.text.toLowerCase();

      setState(() {
        _isLoading = false;

        result = SearchResult<PromotionModel>();
        result!.count = promotionData.count;

        if (nameFilter.isEmpty) {
          result!.result = promotionData.result;
        } else {
          result!.result = promotionData.result.where((promotion) {
            final promotionHeading = promotion.heading?.toLowerCase() ?? '';
            return promotionHeading.contains(nameFilter);
          }).toList();
        }
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška prilikom dohvatanja podataka: $e')),
      );
    }
  }

  void _applyFilters() {
    _loadData(filters: {
      'heading': _nameFilterController.text,
    });
  }

  Widget _buildPromotionImage(PromotionModel promotion) {
    if (promotion.imagePath == null || promotion.imagePath!.isEmpty) {
      return Container(
        width: 60,
        height: 60,
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported),
      );
    }

    final imageUrl = promotion.imagePath!.startsWith('http')
        ? promotion.imagePath!
        : '$baseUrl${promotion.imagePath}';

    return Container(
      width: 60,
      height: 60,
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Image.network(
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
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("Lista promocija"),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  "Lista promocija",
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
                        final result = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PromotionDetailScreen(
                              promotion: null,
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
                      child: const Text("Dodaj novu promociju"),
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
                          columns: [
                            DataColumn(
                              label: SizedBox(
                                width: 80,
                                child: const Text(
                                  'Slika',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.15,
                                child: const Text(
                                  'Naslov',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.2,
                                child: const Text(
                                  'Sadržaj',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.08,
                                child: const Text(
                                  'Promociju kreirao',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.3,
                                child: const Text(
                                  'Proizvodi',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557),
                                  ),
                                ),
                              ),
                            ),
                            DataColumn(
                              label: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.03,
                                child: const Text(''),
                              ),
                            ),
                          ],
                          rows: result?.result.map((PromotionModel promotion) {
                                return DataRow(
                                  onSelectChanged: (selected) async {
                                    if (selected == true) {
                                      final result = await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PromotionDetailScreen(
                                            promotion: promotion,
                                          ),
                                        ),
                                      );

                                      if (result == true) {
                                        _loadData();
                                      }
                                    }
                                  },
                                  cells: [
                                    DataCell(_buildPromotionImage(promotion)),
                                    DataCell(
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.15,
                                        child: Text(
                                          promotion.heading ?? '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF2C5C7F),
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.2,
                                        child: Text(
                                          promotion.content ?? '',
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF2C5C7F),
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.08,
                                        child: Text(
                                          adminNameMap[
                                                  promotion.adminId ?? ''] ??
                                              '',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF2C5C7F),
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.3,
                                        child: Text(
                                          promotion.products != null &&
                                                  promotion.products!.isNotEmpty
                                              ? promotion.products!
                                                  .map(
                                                      (product) => product.name)
                                                  .join(', ')
                                              : 'Nema proizvoda',
                                          maxLines: 1,
                                          textAlign: TextAlign.start,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF2C5C7F),
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      DeleteModal(
                                        title: 'Potvrda brisanja',
                                        content:
                                            'Da li ste sigurni da želite obrisati ovu promociju?',
                                        onDelete: () async {
                                          await _promotionProvider
                                              .delete(promotion.id!);
                                          _loadData();
                                        },
                                      ),
                                    ),
                                  ],
                                );
                              }).toList() ??
                              [],
                        )),
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
