import 'package:flutter/material.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/product_reservation/product_reservation.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/providers/product_reservation.dart';
import 'package:furniturestore_admin/screens/product_reservation/product_reservation_detail_screen.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProductReservationListScreen extends StatefulWidget {
  const ProductReservationListScreen({super.key});

  @override
  State<ProductReservationListScreen> createState() =>
      _ProductReservationListScreenState();
}

class _ProductReservationListScreenState
    extends State<ProductReservationListScreen> {
  late ProductReservationProvider _productReservationProvider;
  late AccountProvider _customerProvider;
  SearchResult<ProductReservationModel>? result;
  Map<String, String> customerNameMap = {};
  TextEditingController _customerIdFilterController = TextEditingController();
  TextEditingController _notesFilterController = TextEditingController();
  TextEditingController _customerNameFilterController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productReservationProvider = context.read<ProductReservationProvider>();
    _customerProvider = context.read<AccountProvider>();
    _loadData();
  }

  Future<void> _loadData({Map<String, String>? filters}) async {
    try {
      var reservationData =
          await _productReservationProvider.get(filter: filters);
      var customerResult = await _customerProvider.getAll();

      customerNameMap = {
        for (var customer in customerResult.result)
          if (customer.id != null) customer.id!: customer.fullName ?? ''
      };
      print('API response: $reservationData');

      // Apply filter by customer name if provided
      if (filters != null &&
          filters['customerName'] != null &&
          filters['customerName']!.isNotEmpty) {
        reservationData.result = reservationData.result.where((reservation) {
          String customerName = customerNameMap[reservation.customerId] ?? '';
          return customerName
              .toLowerCase()
              .contains(filters['customerName']!.toLowerCase());
        }).toList();
      }

      setState(() {
        result = reservationData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  void _applyFilters() {
    var filters = {
      'customerId': _customerIdFilterController.text.trim(),
      'notes': _notesFilterController.text.trim(),
      'customerName': _customerNameFilterController.text.trim(),
    };
    _loadData(filters: filters);
  }

  Future<void> _showApprovalDialog(ProductReservationModel reservation) async {
    if (reservation.isApproved ?? false) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Reservation Approved'),
            content: Text(
                'This reservation has already been approved and cannot be changed.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      bool? isApproved = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Odobri rezervaciju'),
            content: Text('Da li želiš odobriti ovu rezervaciju?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text('No'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text('Yes'),
              ),
            ],
          );
        },
      );

      if (isApproved != null && isApproved) {
        await _updateReservationApproval(reservation);
      }
    }
  }

  Future<void> _updateReservationApproval(
      ProductReservationModel reservation) async {
    try {
      reservation.isApproved = !(reservation.isApproved ?? false);
      if (reservation.id != null) {
        await _productReservationProvider.update(reservation.id!, reservation);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reservation approval status updated')),
        );
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Reservation ID is null')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Error updating reservation approval status: $e')),
      );
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return DateFormat('d.M.yyyy HH:mm:ss').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: Text("Lista rezervacija proizvoda"),
      child: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              "Lista rezervacija proizvoda",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3557),
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _notesFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Filtriraj po napomenama',
                      labelStyle: TextStyle(color: Color(0xFF2C5C7F)),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search, color: Color(0xFFF4A258)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF4A258)),
                      ),
                    ),
                    cursorColor: Color(0xFFF4A258),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _customerNameFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Filtriraj po imenu kupca',
                      labelStyle: TextStyle(color: Color(0xFF2C5C7F)),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search, color: Color(0xFFF4A258)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF4A258)),
                      ),
                    ),
                    cursorColor: Color(0xFFF4A258),
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _applyFilters,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xFFF4A258),
                    padding:
                        EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: Text("Pretraga"),
                ),
                SizedBox(width: 16),
              ],
            ),
            SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Datum Rezervacije',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Napomene',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Kupac',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Odobreno',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '',
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          '',
                        ),
                      ),
                    ],
                    rows: result?.result
                            ?.map((ProductReservationModel reservation) {
                          return DataRow(
                            onSelectChanged: (selected) {
                              if (selected == true) {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ProductReservationDetailScreen(
                                      reservation: reservation,
                                    ),
                                  ),
                                );
                              }
                            },
                            cells: [
                              DataCell(
                                Text(
                                  _formatDateTime(reservation.reservationDate),
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
                                  reservation.notes ?? '',
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
                                  customerNameMap[reservation.customerId] ?? '',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C5C7F),
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                              DataCell(
                                InkWell(
                                  child: Row(
                                    children: [
                                      Text(
                                        reservation.isApproved ?? false
                                            ? 'Odobreno'
                                            : 'Nije odobreno',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: reservation.isApproved ?? false
                                              ? const Color(0xFF70BC69)
                                              : const Color(0xFFE91E63),
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      SizedBox(width: 2),
                                      Icon(
                                        reservation.isApproved ?? false
                                            ? Icons.check
                                            : Icons.close,
                                        color: reservation.isApproved ?? false
                                            ? const Color(0xFF70BC69)
                                            : const Color(0xFFE91E63),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                              DataCell(
                                reservation.isApproved ?? false
                                    ? SizedBox.shrink()
                                    : ElevatedButton(
                                        onPressed: () =>
                                            _showApprovalDialog(reservation),
                                        style: ElevatedButton.styleFrom(
                                          foregroundColor: Colors.white,
                                          backgroundColor: Color(0xFFF4A258),
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 12.0, horizontal: 16.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                          ),
                                        ),
                                        child: Text('Odobri'),
                                      ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ProductReservationDetailScreen(
                                          reservation: reservation,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFF2C5C7F),
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: Text('Detalji'),
                                ),
                              ),
                              DataCell(
                                DeleteModal(
                                  title: 'Potvrda brisanja',
                                  content:
                                      'Da li ste sigurni da želite obrisati ovu rezervaciju?',
                                  onDelete: () async {
                                    await _productReservationProvider
                                        .delete(reservation.id!);
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
