import 'package:flutter/material.dart';
import 'package:furniturestore_admin/models/account/account.dart';
import 'package:furniturestore_admin/models/custom_furniture_reservation/custom_furniture_reservation.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class CustomReservationDetailScreen extends StatefulWidget {
  final CustomFurnitureReservationModel? reservation;

  const CustomReservationDetailScreen({Key? key, this.reservation})
      : super(key: key);

  @override
  _CustomReservationDetailScreenState createState() =>
      _CustomReservationDetailScreenState();
}

class _CustomReservationDetailScreenState
    extends State<CustomReservationDetailScreen> {
  late AccountProvider _accountProvider;
  Map<String, AccountModel> userMap = {};
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _accountProvider = context.read<AccountProvider>();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      var userResult = await _accountProvider.getAll();
      userMap = {
        for (var user in userResult.result)
          if (user.id != null) user.id!: user
      };
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching user data: $e')),
      );
      setState(() {
        isLoading = false;
      });
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return DateFormat('d.M.yyyy HH:mm:ss').format(dateTime);
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1D3557),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16,
              color: Color(0xFF2C5C7F),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final reservation = widget.reservation;

    if (reservation == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Detalji rezervacije'),
        ),
        body: const Center(
          child: Text('Nema podataka o rezervaciji'),
        ),
      );
    }

    final userInfo = userMap[reservation.userId ?? ''];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalji rezervacije'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Napomena', reservation.note ?? ''),
                        const SizedBox(height: 4),
                        _buildDetailRow('Ime', userInfo?.firstName ?? ''),
                        const SizedBox(height: 4),
                        _buildDetailRow('Prezime', userInfo?.lastName ?? ''),
                        const SizedBox(height: 4),
                        _buildDetailRow('Email', userInfo?.email ?? ''),
                        const SizedBox(height: 4),
                        _buildDetailRow('Telefon', userInfo?.phoneNumber ?? ''),
                        const SizedBox(height: 4),
                        _buildDetailRow('Datum kreiranja',
                            _formatDateTime(reservation.createdDate)),
                        const SizedBox(height: 4),
                        _buildDetailRow('Datum rezervacije',
                            _formatDateTime(reservation.reservationDate)),
                        _buildDetailRow(
                            "Status rezervacije",
                            reservation.reservationStatus == false
                                ? "Nije odobrena"
                                : "Odobrena"),
                        const SizedBox(height: 16.0),
                        Expanded(
                          child: SingleChildScrollView(
                            child: TableCalendar(
                              focusedDay:
                                  reservation.reservationDate ?? DateTime.now(),
                              firstDay: DateTime(2000),
                              lastDay: DateTime(2100),
                              headerStyle: HeaderStyle(
                                titleCentered: true,
                                formatButtonVisible: false,
                                leftChevronVisible: false,
                                rightChevronVisible: false,
                              ),
                              calendarFormat: CalendarFormat.month,
                              selectedDayPredicate: (day) {
                                return isSameDay(
                                    day, reservation.reservationDate);
                              },
                              onDaySelected: (selectedDay, focusedDay) {},
                              availableGestures: AvailableGestures.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  Expanded(
                    flex: 1,
                    child: Container(
                      height: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: Color(0xFF2C5C7F),
                          width: 2,
                        ),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.asset(
                          'assets/images/reservation_photo.jpg',
                          fit: BoxFit.cover,
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
