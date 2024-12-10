import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:furniturestore_admin/models/enums/delivery.dart';
import 'package:furniturestore_admin/models/order/order.dart';
import 'package:furniturestore_admin/providers/order_provider.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class OrderDetailScreen extends StatefulWidget {
  final OrderModel? order;

  OrderDetailScreen({Key? key, this.order}) : super(key: key);

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
  final _formKey = GlobalKey<FormBuilderState>();
  late OrderProvider _orderProvider;
  late AccountProvider _accountProvider;
  late Map<String, String> customerNameMap;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _orderProvider = context.read<OrderProvider>();
    _accountProvider = context.read<AccountProvider>();
    _initialLoad();
  }

  Future<void> _initialLoad() async {
    try {
      var customerResult = await _accountProvider.getAll();
      customerNameMap = {
        for (var customer in customerResult.result)
          if (customer.id != null) customer.id!: customer.fullName ?? ''
      };
    } catch (e) {
      customerNameMap = {};
    }

    setState(() {
      isLoading = false;
    });
  }

  Delivery? getDeliveryById(int? id) {
    if (id == null) return null;
    return Delivery.values[id];
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      child:
          isLoading ? Center(child: CircularProgressIndicator()) : _buildForm(),
      showBackButton: true,
      title: 'Detalji narudžbe',
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
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
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDetailRow('Datum narudžbe',
                            _formatDateTime(widget.order?.orderDate)),
                        SizedBox(height: 8),
                        _buildDetailRow('Ukupna cijena',
                            widget.order?.totalPrice?.toString() ?? ''),
                        SizedBox(height: 8),
                        _buildDetailRow(
                            'Dostava',
                            getDeliveryById(widget.order?.delivery)
                                    ?.displayName ??
                                ''),
                        SizedBox(height: 8),
                        _buildDetailRow(
                            'Korisnik',
                            customerNameMap[widget.order?.customerId ?? ''] ??
                                'Nepoznato'),
                        SizedBox(height: 8),
                        _buildDetailRow('Odobreno',
                            widget.order?.isApproved == true ? 'Da' : 'Ne'),
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
                              SizedBox(
                                child: SingleChildScrollView(
                                  child: TableCalendar(
                                    firstDay: DateTime.utc(2000, 1, 1),
                                    lastDay: DateTime.utc(2100, 12, 31),
                                    focusedDay: widget.order?.orderDate ??
                                        DateTime.now(),
                                    selectedDayPredicate: (day) =>
                                        isSameDay(day, widget.order?.orderDate),
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
                                      setState(() {});
                                    },
                                    onDaySelected: (selectedDay, focusedDay) {},
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
      ],
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

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return DateFormat('d.M.yyyy HH:mm:ss').format(dateTime);
  }

  void _onSubmit() async {
    if (_formKey.currentState?.saveAndValidate() ?? false) {
      final formData = _formKey.currentState?.value;
      print('Form Data: $formData');

      var request = new Map.from(_formKey.currentState!.value);

      try {
        if (widget.order == null) {
          await _orderProvider.insert(request);
        } else {
          await _orderProvider.update(widget.order!.id!, request);
        }
      } on Exception catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
                  title: Text("Greška"),
                  content: Text(e.toString()),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Uredu"))
                  ],
                ));
      }
    } else {
      print('Validacija nije uspjela');
    }
  }
}
