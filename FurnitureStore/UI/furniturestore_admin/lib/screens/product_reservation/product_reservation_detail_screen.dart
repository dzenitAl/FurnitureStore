import 'package:flutter/material.dart';
import 'package:furniturestore_admin/models/product_reservation/product_reservation.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/providers/product_reservation.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class ProductReservationDetailScreen extends StatefulWidget {
  final ProductReservationModel reservation;

  const ProductReservationDetailScreen({super.key, required this.reservation});

  @override
  _ProductReservationDetailScreenState createState() =>
      _ProductReservationDetailScreenState();
}

class _ProductReservationDetailScreenState
    extends State<ProductReservationDetailScreen> {
  late ProductReservationProvider _productReservationProvider;
  late AccountProvider _customerProvider;
  Map<String, String> customerNameMap = {};
  bool _isLoading = true;
  String _errorMessage = '';

  String customerName = '';
  DateTime _focusedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      _productReservationProvider = context.read<ProductReservationProvider>();
      _customerProvider = context.read<AccountProvider>();
      _fetchCustomerName();
    });
  }

  Future<void> _fetchCustomerName() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });
    
    try {
      var customerResult = await _customerProvider.getAll();
      customerNameMap = {
        for (var customer in customerResult.result)
          if (customer.id != null) customer.id!: customer.fullName ?? ''
      };
      setState(() {
        customerName = customerNameMap[widget.reservation.customerId] ?? '';
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Error fetching customer data: $e';
        _isLoading = false;
      });
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
        title: const Text('Detalji rezervacije'),
      ),
      body: _isLoading 
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        _errorMessage,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _fetchCustomerName,
                        child: const Text('Pokušaj ponovo'),
                      ),
                    ],
                  ),
                )
              : Padding(
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
                                  const SizedBox(height: 20),
                                  _buildDetailRow(
                                      'Datum Rezervacije',
                                      _formatDateTime(
                                          widget.reservation.reservationDate)),
                                  const SizedBox(height: 8),
                                  _buildDetailRow('Kupac', customerName),
                                  const SizedBox(height: 8),
                                  _buildDetailRow(
                                      'Napomene', widget.reservation.notes ?? ''),
                                  const SizedBox(height: 8),
                                  _buildDetailRow(
                                      'Odobreno',
                                      widget.reservation.isApproved ?? false
                                          ? 'Da'
                                          : 'Ne'),
                                  const SizedBox(height: 20),
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
                                        const SizedBox(height: 20),
                                        TableCalendar(
                                          firstDay: DateTime.utc(2000, 1, 1),
                                          lastDay: DateTime.utc(2100, 12, 31),
                                          focusedDay: widget.reservation.reservationDate ?? DateTime.now(),
                                          selectedDayPredicate: (day) => isSameDay(
                                              day, widget.reservation.reservationDate ?? DateTime.now()),
                                          headerStyle: const HeaderStyle(
                                            titleCentered: true,
                                            formatButtonVisible: false,
                                            leftChevronVisible: false,
                                            rightChevronVisible: false,
                                          ),
                                          calendarStyle: CalendarStyle(
                                            selectedDecoration: const BoxDecoration(
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
                                                  widget.reservation.reservationDate ?? DateTime.now();
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
                          const SizedBox(width: 16),
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
}
