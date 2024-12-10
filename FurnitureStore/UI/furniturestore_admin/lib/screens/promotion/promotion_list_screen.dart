import 'package:flutter/material.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/promotion/promotion.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/providers/promotion_provider.dart';
import 'package:furniturestore_admin/screens/promotion/promotion_detail_screen.dart';
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _promotionProvider = context.read<PromotionProvider>();
    _accountProvider = context.read<AccountProvider>();
    _loadData();
  }

  Future<void> _loadData({Map<String, String>? filters}) async {
    try {
      var promotionData = await _promotionProvider.get();

      var adminResult = await _accountProvider.getAll();

      adminNameMap = {
        for (var admin in adminResult.result)
          if (admin.id != null) admin.id!: admin.fullName ?? ''
      };

      final nameFilter = _nameFilterController.text.toLowerCase();

      setState(() {
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

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("Lista promocija"),
      child: Container(
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
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => PromotionDetailScreen(
                          promotion: null,
                        ),
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
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Naslov',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Sadržaj',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Admin',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Proizvodi',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      DataColumn(label: Text(""))
                    ],
                    rows: result?.result.map((PromotionModel promotion) {
                          return DataRow(
                            // onSelectChanged: (selected) {
                            //   if (selected == true) {
                            //     Navigator.of(context).push(
                            //       MaterialPageRoute(
                            //         builder: (context) => PromotionDetailScreen(
                            //           promotion: promotion,
                            //         ),
                            //       ),
                            //     );
                            //   }
                            // },
                            onSelectChanged: (selected) async {
                              if (selected == true) {
                                // Ovdje koristimo `await` kako bismo pričekali povratak sa `DetailScreen`.
                                var shouldRefresh =
                                    await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => PromotionDetailScreen(
                                      promotion: promotion,
                                    ),
                                  ),
                                );

                                // Ako se vrati `true` sa `PromotionDetailScreen`, osvježi podatke.
                                if (shouldRefresh == true) {
                                  _loadData(); // Ponovno dohvaćanje podataka
                                }
                              }
                            },
                            cells: [
                              DataCell(
                                Text(
                                  promotion.heading ?? '',
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
                                  promotion.content ?? '',
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
                                  adminNameMap[promotion.adminId ?? ''] ?? '',
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
                                  promotion.products != null &&
                                          promotion.products!.isNotEmpty
                                      ? promotion.products!
                                          .map((product) => product.name)
                                          .join(', ')
                                      : 'No products',
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
