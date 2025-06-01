import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/product_reservation/product_reservation.dart';
import 'package:furniturestore_mobile/models/product_reservation_item/product_reservation_item.dart';
import 'package:furniturestore_mobile/providers/product_reservation.dart';
import 'package:furniturestore_mobile/providers/product_reservation_item.dart';
import 'package:furniturestore_mobile/screens/product_reservation/product_reservation_detail_screen.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:intl/intl.dart';

class SentReservationsScreen extends StatefulWidget {
  final String currentUserId;

  const SentReservationsScreen({
    super.key,
    required this.currentUserId,
  });

  @override
  State<SentReservationsScreen> createState() => _SentReservationsScreenState();
}

class _SentReservationsScreenState extends State<SentReservationsScreen> {
  final _reservationProvider = ProductReservationProvider();
  final _reservationItemProvider = ProductReservationItemProvider();

  List<ProductReservationModel> _reservations = [];
  Map<int, List<ProductReservationItemModel>> _itemsByReservation = {};
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadReservations();
  }

  Future<void> _loadReservations() async {
    try {
      final result = await _reservationProvider.get(
        "",
        filter: {'customerId': widget.currentUserId},
      );

      final reservations = result.result.cast<ProductReservationModel>();

      reservations
          .sort((a, b) => a.reservationDate!.compareTo(b.reservationDate!));

      _itemsByReservation.clear();

      for (var reservation in reservations) {
        if (reservation.id != null) {
          final itemResult = await _reservationItemProvider.get(
            "",
            filter: {'productReservationId': reservation.id},
          );

          final items = itemResult.result.cast<ProductReservationItemModel>();

          _itemsByReservation[reservation.id!] = items;
        }
      }

      setState(() {
        _reservations = reservations;
        _isLoading = false;
      });
    } catch (e, st) {
      print("Greška prilikom učitavanja rezervacija: $e");
      print(st);
      setState(() {
        _isLoading = false;
      });
    }
  }

  Map<String, int> _calculateProductStats(
      List<ProductReservationItemModel> items) {
    int totalQuantity = 0;
    final uniqueProductIds = <int>{};

    for (var item in items) {
      if (item.quantity != null) {
        totalQuantity += item.quantity!;
      }
      if (item.productId != null) {
        uniqueProductIds.add(item.productId!);
      }
    }

    return {
      'totalQuantity': totalQuantity,
      'uniqueCount': uniqueProductIds.length,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Vaše poslane rezervacije',
      showBackButton: true,
      child: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _reservations.isEmpty
              ? const Center(child: Text('Nemate nijednu poslanu rezervaciju.'))
              : ListView.builder(
                  itemCount: _reservations.length,
                  itemBuilder: (context, index) {
                    final reservation = _reservations[index];
                    final items = _itemsByReservation[reservation.id] ?? [];
                    final productStats = _calculateProductStats(items);
                    final totalQuantity = productStats['totalQuantity'] ?? 0;
                    final uniqueCount = productStats['uniqueCount'] ?? 0;

                    final formattedDate = DateFormat('dd.MM.yyyy')
                        .format(reservation.reservationDate!);

                    final isApproved = reservation.isApproved ?? false;
                    final statusColor =
                        isApproved ? Colors.green : Colors.orange;
                    final statusText = isApproved ? 'Odobreno' : 'Na čekanju';
                    final statusIcon =
                        isApproved ? Icons.check_circle : Icons.hourglass_top;

                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.teal.shade700,
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                            ),
                            child: ListTile(
                              title: Text(
                                'Rezervacija ${index + 1}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.white,
                                ),
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  color: Colors.white),
                              onTap: () {
                                Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      ProductReservationDetailScreen(
                                    reservation: reservation,
                                    items: items,
                                  ),
                                ));
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Datum: $formattedDate',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Ukupna količina proizvoda: $totalQuantity',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Broj različitih proizvoda: $uniqueCount',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                if (reservation.isApproved != null)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Row(
                                      children: [
                                        Icon(
                                          reservation.isApproved!
                                              ? Icons.check_circle
                                              : Icons.error,
                                          color: reservation.isApproved!
                                              ? Colors.green
                                              : Colors.red,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          reservation.isApproved!
                                              ? 'Odobreno'
                                              : 'Nije odobreno',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: reservation.isApproved!
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }
}
