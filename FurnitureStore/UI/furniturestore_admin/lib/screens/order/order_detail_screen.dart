import 'package:flutter/material.dart';
import 'package:furniturestore_admin/models/enums/delivery.dart';
import 'package:furniturestore_admin/models/order/order.dart';
import 'package:furniturestore_admin/providers/order_provider.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

class OrderDetailScreen extends StatefulWidget {
  OrderModel? order;

  OrderDetailScreen({super.key, this.order});

  @override
  State<OrderDetailScreen> createState() => _OrderDetailScreenState();
}

class _OrderDetailScreenState extends State<OrderDetailScreen> {
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
    setState(() {
      isLoading = true;
    });

    try {
      try {
        var customerResult = await _accountProvider.getAll();
        customerNameMap = {
          for (var customer in customerResult.result)
            if (customer.id != null) customer.id!: customer.fullName ?? ''
        };
      } catch (e) {
        print("Greška pri učitavanju korisnika: $e");
        customerNameMap = {};
      }

      if (widget.order?.id != null) {
        try {
          print("Dohvaćam detalje za narudžbu ID: ${widget.order!.id}");
          var orderWithItems =
              await _orderProvider.getOrderDetails(widget.order!.id!);

          if (orderWithItems != null) {
            setState(() {
              widget.order = orderWithItems;
            });
            print("Uspješno učitani detalji narudžbe");
          } else {
            print("Nije moguće dobiti detalje narudžbe - API vratio null");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Nije moguće dohvatiti detalje narudžbe'),
                backgroundColor: Colors.red,
              ),
            );
          }
        } catch (e) {
          print("Greška pri dohvaćanju detalja narudžbe: $e");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Greška: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        print("ID narudžbe je null, ne mogu dohvatiti detalje");
      }
    } catch (e) {
      print("Opća greška pri učitavanju: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Delivery? getDeliveryById(int? id) {
    if (id == null) return null;
    return Delivery.values[id];
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      showBackButton: true,
      title: 'Detalji narudžbe',
      child: isLoading
          ? const Center(child: CircularProgressIndicator())
          : _buildForm(),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Expanded(
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.asset(
                            "assets/images/reservation_photo.jpg",
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      _buildDetailBox(),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                flex: 1,
                child: _buildCalendar(),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailBox() {
    bool hasBasicOrderData = widget.order?.id != null;

    return Container(
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
          if (!hasBasicOrderData)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text(
                  "Podaci o narudžbi nisu dostupni",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                  ),
                ),
              ),
            )
          else ...[
            _buildDetailRow(
                'Datum narudžbe', _formatDateTime(widget.order?.orderDate)),
            const SizedBox(height: 8),
            _buildDetailRow('Ukupna cijena',
                '${widget.order?.totalPrice?.toString() ?? ''} KM'),
            const SizedBox(height: 8),
            _buildDetailRow('Dostava',
                getDeliveryById(widget.order?.delivery)?.displayName ?? ''),
            const SizedBox(height: 8),
            _buildDetailRow('Korisnik',
                customerNameMap[widget.order?.customerId ?? ''] ?? 'Nepoznato'),
            const SizedBox(height: 8),
            _buildDetailRow(
                'Odobreno', widget.order?.isApproved == true ? 'Da' : 'Ne'),
            const SizedBox(height: 20),
            const Text(
              "Detalji narudžbe",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3557),
              ),
            ),
            const SizedBox(height: 12),
            _buildOrderDetailsTable(),
          ],
        ],
      ),
    );
  }

  Widget _buildCalendar() {
    return TableCalendar(
      firstDay: DateTime.utc(2020, 1, 1),
      lastDay: DateTime.utc(2030, 12, 31),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
    );
  }

  Widget _buildOrderDetailsTable() {
    if (widget.order?.orderItems == null || widget.order!.orderItems!.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.info_outline, color: Colors.orange, size: 32),
              SizedBox(height: 8),
              Text(
                "Nema proizvoda u narudžbi",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              SizedBox(height: 4),
              Text(
                "Moguće je da stavke nisu učitane s API-ja",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ],
          ),
        ),
      );
    }

    return DataTable(
      columns: const [
        DataColumn(label: Text("Naziv proizvoda")),
        DataColumn(label: Text("Količina")),
        DataColumn(label: Text("Cijena")),
      ],
      rows: widget.order!.orderItems!.map((item) {
        return DataRow(cells: [
          DataCell(Text(item.productName ?? "Nepoznato")),
          DataCell(Text(item.quantity.toString())),
          DataCell(Text("${item.price} KM")),
        ]);
      }).toList(),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      children: [
        Text('$label:',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1D3557))),
        const SizedBox(width: 8),
        Expanded(
            child: Text(value,
                style:
                    const TextStyle(fontSize: 16, color: Color(0xFF2C5C7F)))),
      ],
    );
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return 'Nije postavljeno';
    return DateFormat('dd.MM.yyyy HH:mm').format(dateTime);
  }
}
