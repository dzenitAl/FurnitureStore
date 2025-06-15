import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/decoration_item/decoration_item.dart';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/models/product_reservation/product_reservation.dart';
import 'package:furniturestore_mobile/providers/account_provider.dart';
import 'package:furniturestore_mobile/providers/product_reservation.dart';
import 'package:furniturestore_mobile/screens/product_reservation/sent_product_reservation_list_screen.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';

class ProductReservationListScreen extends StatefulWidget {
  const ProductReservationListScreen({super.key});

  @override
  _ProductReservationListScreenState createState() =>
      _ProductReservationListScreenState();
}

class _ProductReservationListScreenState
    extends State<ProductReservationListScreen> {
  String? _note;
  DateTime? _reservationDate;
  List<ProductReservationModel> _sentReservations = [];
  bool _isLoading = true;
  final AccountProvider _accountProvider = AccountProvider();

  final ProductReservationProvider _reservationProvider =
      ProductReservationProvider();

  String? _currentUserId;

  List<dynamic> get reservations {
    final products = ProductReservation.getReservedProducts();
    final decorationItems = ProductReservation.getReservedDecorationItems();
    return [...products, ...decorationItems];
  }

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('bs');
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final currentUser = _accountProvider.getCurrentUser();
      print("CURRENT USER:: ${currentUser.nameid}");
      setState(() {
        _currentUserId = currentUser.nameid;
      });
      await _loadSentReservations();
    } catch (e) {
      print("Greška pri dohvaćanju korisnika: $e");
    }
  }

  Future<void> _loadSentReservations() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final data = await _reservationProvider
          .get("", filter: {"userId": _currentUserId});
      setState(() {
        _sentReservations = data.result;
        _isLoading = false;
      });
    } catch (e) {
      print("Greška prilikom dohvaćanja rezervacija: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToSentReservations() {
    if (_currentUserId != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => SentReservationsScreen(
            currentUserId: _currentUserId!,
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Korisnik nije prijavljen.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final groupedReservations = <int, dynamic>{};

    for (var item in reservations) {
      if (item is ProductModel) {
        groupedReservations[item.id ?? 0] = item;
      } else if (item is DecorationItemModel) {
        groupedReservations[item.id ?? 0] = item;
      }
    }

    return MasterScreenWidget(
      title: 'Rezervacije proizvoda',
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_sentReservations.isNotEmpty)
              GestureDetector(
                onTap: _navigateToSentReservations,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue),
                  ),
                  child: const Text(
                    '📦 Lista već poslanih rezervacija',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
            if (groupedReservations.isNotEmpty)
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Lista proizvoda dodanih u rezervaciju',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            Expanded(
              child: groupedReservations.isNotEmpty
                  ? ListView.builder(
                      itemCount: groupedReservations.length,
                      itemBuilder: (context, index) {
                        final item =
                            groupedReservations.values.elementAt(index);
                        final quantity = item is ProductModel
                            ? ProductReservation.getProductQuantity(
                                item.id ?? 0)
                            : ProductReservation.getDecorationItemQuantity(
                                item.id ?? 0);

                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Row(
                              children: [
                                Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade400,
                                      width: 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: item.productPictures != null &&
                                          item.productPictures!.isNotEmpty
                                      ? ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          child: Image.network(
                                            'http://10.0.2.2:7015/api/ProductPicture/direct-image/${item.productPictures!.first.id}',
                                            fit: BoxFit.cover,
                                            headers: {
                                              'Authorization':
                                                  'Bearer ${Authorization.token}'
                                            },
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 116, 143, 187),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Icon(
                                                  Icons.image_not_supported,
                                                  size: 40,
                                                  color: Colors.white,
                                                ),
                                              );
                                            },
                                            loadingBuilder: (context, child,
                                                loadingProgress) {
                                              if (loadingProgress == null)
                                                return child;
                                              return Container(
                                                decoration: BoxDecoration(
                                                  color: const Color.fromARGB(
                                                      255, 116, 143, 187),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: const Center(
                                                  child:
                                                      CircularProgressIndicator(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              );
                                            },
                                          ),
                                        )
                                      : Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 116, 143, 187),
                                            borderRadius:
                                                BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.image_not_supported,
                                            size: 40,
                                            color: Colors.white,
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.name ?? 'Nepoznat proizvod',
                                        style: const TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text('Količina: $quantity',
                                          style: const TextStyle(fontSize: 16)),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle,
                                      color: Colors.red),
                                  onPressed: () async {
                                    if (item is ProductModel) {
                                      await ProductReservation
                                          .removeProductFromReservation(item);
                                    } else if (item is DecorationItemModel) {
                                      await ProductReservation
                                          .removeDecorationItemFromReservation(
                                              item);
                                    }
                                    setState(() {});
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )
                  : _buildEmptyState(),
            ),
            if (groupedReservations.isNotEmpty)
              ElevatedButton(
                onPressed: _openSubmitDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                  textStyle: const TextStyle(fontSize: 16),
                ),
                child: const Text('Pošalji zahtjev za rezervaciju'),
              ),
          ],
        ),
      ),
    );
  }

  void _openSubmitDialog() {
    if (reservations.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Lista rezervacija je prazna')),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Potvrda slanja'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                      'Da li ste sigurni da želite poslati zahtjev za narudžbu ovih proizvoda?'),
                  const SizedBox(height: 16),
                  TextField(
                    maxLines: 4,
                    decoration: const InputDecoration(
                      labelText: 'Napisite napomenu',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _note = value;
                    },
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () async {
                      final pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime(2101),
                      );
                      if (pickedDate != null) {
                        setState(() {
                          _reservationDate = pickedDate;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16, horizontal: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        _reservationDate == null
                            ? 'Odaberite datum'
                            : DateFormat.yMMMd('bs').format(_reservationDate!),
                        style: TextStyle(
                          color: _reservationDate == null
                              ? Colors.grey
                              : Colors.black,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('Otkaži'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (_reservationDate == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text('Molimo odaberite datum.')),
                      );
                      return;
                    }
                    _submitReservationRequest();
                    Navigator.of(context).pop();
                  },
                  child: const Text('Pošalji'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> _submitReservationRequest() async {
    debugPrint('Napomena: $_note');
    debugPrint('Datum: $_reservationDate');
    final List<int?> reservationItems = reservations
        .map((item) => (item is ProductModel || item is DecorationItemModel)
            ? item.id
            : null)
        .where((id) => id != null)
        .cast<int?>()
        .toList();

    final reservation = ProductReservationModel(
        notes: _note,
        reservationDate: _reservationDate,
        isApproved: false,
        customerId: _currentUserId ?? "Unknown",
        productReservationItemIds: reservationItems);

    print("REZERVACIJA ==> ${reservation.toJson()}");

    await _reservationProvider.insert(reservation);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Rezervacija je uspješno poslana!')),
    );

    setState(() {
      _reservationDate = null;
    });
    ProductReservation.clearReservations();
  }

  Widget _buildEmptyState() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.list_alt, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'Trenutno nemate dodanih proizvoda za rezervaciju.',
            style: TextStyle(fontSize: 18, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
