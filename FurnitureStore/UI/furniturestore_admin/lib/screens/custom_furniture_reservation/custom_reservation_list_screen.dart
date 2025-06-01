import 'package:flutter/material.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/custom_furniture_reservation/custom_furniture_reservation.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/providers/custom_reservation_provider.dart';
import 'package:furniturestore_admin/screens/custom_furniture_reservation/custom_reservation_detail_screen.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class CustomFurnitureReservationListScreen extends StatefulWidget {
  const CustomFurnitureReservationListScreen({super.key});

  @override
  _CustomFurnitureReservationListScreenState createState() =>
      _CustomFurnitureReservationListScreenState();
}

class _CustomFurnitureReservationListScreenState
    extends State<CustomFurnitureReservationListScreen> {
  late CustomReservationProvider _reservationProvider;
  late AccountProvider _accountProvider;
  SearchResult<CustomFurnitureReservationModel>? result;
  Map<String, Map<String, String>> userMap = {};
  final TextEditingController _customerIdFilterController =
      TextEditingController();
  final TextEditingController _notesFilterController = TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _reservationProvider = context.read<CustomReservationProvider>();
    _accountProvider = context.read<AccountProvider>();
    _loadData();
  }

  Future<void> _loadData({Map<String, String>? filters}) async {
    try {
      var reservationData = await _reservationProvider.get(filter: filters);
      var userResult = await _accountProvider.getAll();

      userMap = {
        for (var user in userResult.result)
          if (user.id != null)
            user.id!: {
              'firstName': user.firstName ?? '',
              'lastName': user.lastName ?? '',
              'email': user.email ?? '',
              'phoneNumber': user.phoneNumber ?? ''
            }
      };

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
    _loadData(filters: {
      'customerId': _customerIdFilterController.text,
      'notes': _notesFilterController.text,
    });
  }

  Future<void> _showApprovalDialog(
      CustomFurnitureReservationModel reservation) async {
    if (reservation.reservationStatus ?? false) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Rezervacija je već odobrena'),
            content: const Text(
                'Ova rezervacija je već odobrena i ne može se mijenjati.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              ),
            ],
          );
        },
      );
    } else {
      bool? reservationStatus = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Odobri rezervaciju'),
            content: const Text('Želite li odobriti ovu rezervaciju?'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: const Text('Ne'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: const Text('Da'),
              ),
            ],
          );
        },
      );

      if (reservationStatus != null && reservationStatus) {
        await _updateReservationApproval(reservation);
      }
    }
  }

  Future<void> _updateReservationApproval(
      CustomFurnitureReservationModel reservation) async {
    try {
      reservation.reservationStatus = !(reservation.reservationStatus ?? false);
      if (reservation.id != null) {
        await _reservationProvider.update(reservation.id!, reservation);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Status odobrenja rezervacije je ažuriran')),
        );
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('ID rezervacije je null')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'Greška pri ažuriranju statusa odobrenja rezervacije: $e')),
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
      titleWidget: const Text(
        "Lista rezervacija namještaja po mjeri",
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Color(0xFF1D3557),
          fontFamily: 'Roboto',
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customerIdFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Filtriraj po ID kupca',
                      labelStyle: TextStyle(color: Color(0xFF2C5C7F)),
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.search, color: Color(0xFFF4A258)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFF4A258)),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF1D3557)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    controller: _notesFilterController,
                    style: const TextStyle(color: Color(0xFF1D3557)),
                    decoration: const InputDecoration(
                      labelText: 'Filtriraj po napomenama',
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
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 1200,
                      maxWidth: 1800,
                    ),
                    child: DataTable(
                      columnSpacing: 14.0,
                      headingTextStyle: const TextStyle(
                        color: Color(0xFF1D3557),
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Roboto',
                      ),
                      dataTextStyle: const TextStyle(
                        color: Color(0xFF1D3557),
                        fontFamily: 'Roboto',
                      ),
                      columns: const [
                        DataColumn(label: Text('Napomena')),
                        DataColumn(label: Text('Datum rezervacije')),
                        DataColumn(label: Text('Datum kreiranja')),
                        DataColumn(label: Text('Ime')),
                        DataColumn(label: Text('Prezime')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Telefon')),
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
                      ],
                      rows: result?.result.map(
                              (CustomFurnitureReservationModel reservation) {
                            var userInfo =
                                userMap[reservation.userId ?? ''] ?? {};
                            return DataRow(
                              onSelectChanged: (selected) {
                                if (selected == true) {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CustomReservationDetailScreen(
                                        reservation: reservation,
                                      ),
                                    ),
                                  );
                                }
                              },
                              cells: [
                                DataCell(
                                  Container(
                                    width: 220,
                                    child: Text(
                                      reservation.note ?? '',
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Color(0xFF2C5C7F),
                                        fontFamily: 'Roboto',
                                      ),
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    _formatDateTime(
                                        reservation.reservationDate),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2C5C7F),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                                DataCell(
                                  Text(
                                    _formatDateTime(reservation.createdDate),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF2C5C7F),
                                      fontFamily: 'Roboto',
                                    ),
                                  ),
                                ),
                                DataCell(Text(
                                  userInfo['firstName'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C5C7F),
                                    fontFamily: 'Roboto',
                                  ),
                                )),
                                DataCell(Text(
                                  userInfo['lastName'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C5C7F),
                                    fontFamily: 'Roboto',
                                  ),
                                )),
                                DataCell(Text(
                                  userInfo['email'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C5C7F),
                                    fontFamily: 'Roboto',
                                  ),
                                )),
                                DataCell(Text(
                                  userInfo['phoneNumber'] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C5C7F),
                                    fontFamily: 'Roboto',
                                  ),
                                )),
                                DataCell(
                                  Row(
                                    children: [
                                      Text(
                                        reservation.reservationStatus ?? false
                                            ? 'Odobreno'
                                            : 'Nije odobreno',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color:
                                              reservation.reservationStatus ??
                                                      false
                                                  ? const Color(0xFF70BC69)
                                                  : const Color(0xFFE91E63),
                                          fontFamily: 'Roboto',
                                        ),
                                      ),
                                      const SizedBox(width: 2),
                                      IconButton(
                                        icon: Icon(
                                          reservation.reservationStatus ?? false
                                              ? Icons.check
                                              : Icons.close,
                                          color:
                                              reservation.reservationStatus ??
                                                      false
                                                  ? const Color(0xFF70BC69)
                                                  : const Color(0xFFE91E63),
                                        ),
                                        onPressed: () =>
                                            _showApprovalDialog(reservation),
                                      ),
                                    ],
                                  ),
                                ),
                                DataCell(
                                  reservation.reservationStatus ?? false
                                      ? const SizedBox.shrink()
                                      : ElevatedButton(
                                          onPressed: () =>
                                              _showApprovalDialog(reservation),
                                          style: ElevatedButton.styleFrom(
                                            foregroundColor: Colors.white,
                                            backgroundColor:
                                                const Color(0xFFF4A258),
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 12.0,
                                                horizontal: 16.0),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8.0),
                                            ),
                                          ),
                                          child: const Text('Odobri'),
                                        ),
                                ),
                                DataCell(
                                  DeleteModal(
                                    title: 'Potvrda brisanja',
                                    content:
                                        'Da li ste sigurni da želite obrisati ovu rezervaciju?',
                                    onDelete: () async {
                                      await _reservationProvider
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
            ),
          ],
        ),
      ),
    );
  }
}
