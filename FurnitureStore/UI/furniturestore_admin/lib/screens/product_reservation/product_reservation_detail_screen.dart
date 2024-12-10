import 'package:flutter/material.dart';
import 'package:furniturestore_admin/models/product_reservation/product_reservation.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/providers/product_reservation.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ProductReservationDetailScreen extends StatefulWidget {
  final ProductReservationModel reservation;

  const ProductReservationDetailScreen({Key? key, required this.reservation})
      : super(key: key);

  @override
  _ProductReservationDetailScreenState createState() =>
      _ProductReservationDetailScreenState();
}

class _ProductReservationDetailScreenState
    extends State<ProductReservationDetailScreen> {
  late ProductReservationProvider _productReservationProvider;
  late AccountProvider _customerProvider;
  Map<String, String> customerNameMap = {};

  String customerName = '';
  DateTime _focusedDay = DateTime.now();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _productReservationProvider = context.read<ProductReservationProvider>();
    _customerProvider = context.read<AccountProvider>();
    _fetchCustomerName();
  }

  Future<void> _fetchCustomerName() async {
    try {
      var customerResult = await _customerProvider.getAll();
      customerNameMap = {
        for (var customer in customerResult.result)
          if (customer.id != null) customer.id!: customer.fullName ?? ''
      };
      setState(() {
        customerName = customerNameMap[widget.reservation.customerId] ?? '';
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Detalji rezervacije'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height - kToolbarHeight - 32,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 20),
                        _buildDetailRow(
                            'Datum Rezervacije',
                            _formatDateTime(
                                widget.reservation.reservationDate)),
                        SizedBox(height: 8),
                        _buildDetailRow('Kupac', customerName),
                        SizedBox(height: 8),
                        _buildDetailRow(
                            'Napomene', widget.reservation.notes ?? ''),
                        SizedBox(height: 8),
                        _buildDetailRow(
                            'Odobreno',
                            widget.reservation.isApproved ?? false
                                ? 'Da'
                                : 'Ne'),
                        SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 2,
                                blurRadius: 5,
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Prikaz datuma rezervacije na kalendaru',
                                style:
                                    Theme.of(context).textTheme.headlineSmall,
                              ),
                              SizedBox(height: 20),
                              TableCalendar(
                                firstDay: DateTime.utc(2000, 1, 1),
                                lastDay: DateTime.utc(2100, 12, 31),
                                focusedDay: widget.reservation.reservationDate!,
                                selectedDayPredicate: (day) => isSameDay(
                                    day, widget.reservation.reservationDate),
                                headerStyle: HeaderStyle(
                                  titleCentered: true,
                                  formatButtonVisible: false,
                                  leftChevronVisible: false,
                                  rightChevronVisible: false,
                                ),
                                calendarStyle: CalendarStyle(
                                  selectedDecoration: BoxDecoration(
                                    color: Colors.blue,
                                    shape: BoxShape.circle,
                                  ),
                                  todayDecoration: BoxDecoration(
                                    color: Colors.blue.withOpacity(0.5),
                                    shape: BoxShape.circle,
                                  ),
                                  outsideDaysVisible: false,
                                ),
                                onPageChanged: (focusedDay) {
                                  setState(() {
                                    _focusedDay =
                                        widget.reservation.reservationDate!;
                                  });
                                },
                                onDaySelected: (selectedDay, focusedDay) {},
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  flex: 1,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 5,
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        "assets/images/reservation_photo.jpg",
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '$label:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF1D3557),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF2C5C7F),
            ),
          ),
        ),
      ],
    );
  }
}
