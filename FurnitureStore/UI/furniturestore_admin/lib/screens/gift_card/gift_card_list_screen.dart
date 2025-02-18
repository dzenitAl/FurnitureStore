import 'package:flutter/material.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/gift_card/gift_card.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/gift_card_provider.dart';
import 'package:furniturestore_admin/screens/gift_card/gift_card_detail_screen.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class GiftCardListScreen extends StatefulWidget {
  const GiftCardListScreen({super.key});

  @override
  State<GiftCardListScreen> createState() => _GiftCardListScreenState();
}

class _GiftCardListScreenState extends State<GiftCardListScreen> {
  SearchResult<GiftCardModel>? result;
  late GiftCardProvider _giftCardProvider;

  final TextEditingController _nameFilterController = TextEditingController();
  final TextEditingController _cardNumberFilterController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _giftCardProvider = context.read<GiftCardProvider>();
    _loadData();
  }

  Future<void> _loadData({Map<String, String>? filters}) async {
    var data = await _giftCardProvider.get(filter: filters);

    setState(() {
      result = data;

      for (var giftCard in result!.result) {
        giftCard.updateActivationStatus();
      }

      if (filters != null) {
        if (filters['name'] != null && filters['name']!.isNotEmpty) {
          result!.result = result!.result
              .where((giftCard) => giftCard.name!
                  .toLowerCase()
                  .contains(filters['name']!.toLowerCase()))
              .toList();
        }
        if (filters['cardNumber'] != null &&
            filters['cardNumber']!.isNotEmpty) {
          result!.result = result!.result
              .where((giftCard) => giftCard.cardNumber!
                  .toLowerCase()
                  .contains(filters['cardNumber']!.toLowerCase()))
              .toList();
        }
      }
    });
  }

  void _applyFilters() {
    _loadData(filters: {
      'name': _nameFilterController.text,
      'cardNumber': _cardNumberFilterController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("Lista poklon kartica"),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Lista poklon kartica",
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
                      labelText: 'Filtriraj po nazivu kartice',
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
                    controller: _cardNumberFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Filtriraj po broju kartice',
                      labelStyle: TextStyle(color: Color(0xFF2C5C7F)),
                      border: OutlineInputBorder(),
                      prefixIcon:
                          Icon(Icons.credit_card, color: Color(0xFFF4A258)),
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
                        builder: (context) => const GiftCardDetailScreen(
                          giftCard: null,
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
                  child: const Text("Dodaj novu poklon karticu"),
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
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Broj kartice',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Količina',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Datum isteka',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Aktivirana',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '',
                        ),
                      ),
                    ],
                    rows: result?.result.map((GiftCardModel giftCard) {
                          final expiryDate = giftCard.expiryDate;
                          final isExpired = expiryDate != null &&
                              expiryDate.isBefore(DateTime.now());
                          return DataRow(
                            onSelectChanged: (selected) {
                              if (selected == true) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => GiftCardDetailScreen(
                                      giftCard: giftCard,
                                    ),
                                  ),
                                );
                              }
                            },
                            cells: [
                              DataCell(
                                Text(
                                  giftCard.name ?? '',
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
                                  giftCard.cardNumber ?? '',
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
                                  giftCard.amount?.toString() ?? '',
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
                                  expiryDate != null
                                      ? expiryDate
                                          .toLocal()
                                          .toString()
                                          .split(' ')[0]
                                      : '',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: isExpired
                                        ? Colors.red
                                        : Color(0xFF2C5C7F),
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                              DataCell(
                                Text(
                                  giftCard.isActivated == true ? 'Da' : 'Ne',
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
                                      'Da li ste sigurni da želite obrisati ovu poklon karticu?',
                                  onDelete: () async {
                                    await _giftCardProvider
                                        .delete(giftCard.id!);
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
