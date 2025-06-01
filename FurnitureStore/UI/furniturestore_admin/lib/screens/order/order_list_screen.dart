import 'package:flutter/material.dart';
import 'package:furniturestore_admin/components/DeleteModal.dart';
import 'package:furniturestore_admin/models/enums/delivery.dart';
import 'package:furniturestore_admin/models/order/order.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/account_provider.dart';
import 'package:furniturestore_admin/providers/order_provider.dart';
import 'package:furniturestore_admin/screens/order/order_detail_screen.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class OrderListScreen extends StatefulWidget {
  const OrderListScreen({super.key});

  @override
  State<OrderListScreen> createState() => _OrderListScreenState();
}

class _OrderListScreenState extends State<OrderListScreen> {
  late OrderProvider _orderProvider;
  late AccountProvider _customerProvider;
  SearchResult<OrderModel>? orders;
  Map<String, String> customerNameMap = {};
  final TextEditingController _orderDateFilterController =
      TextEditingController();
  final TextEditingController _customerIdFilterController =
      TextEditingController();
  final TextEditingController _customerNameFilterController =
      TextEditingController();

  Delivery? _selectedDeliveryFilter;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _orderProvider = context.read<OrderProvider>();
    _customerProvider = context.read<AccountProvider>();
    _loadData();
  }

  Future<void> _loadData({Map<String, String>? filters}) async {
    try {
      var orderData = await _orderProvider.get(filter: filters);
      var customerResult = await _customerProvider.getAll();

      if (filters != null && filters['delivery'] != null) {
        int deliveryFilter = int.parse(filters['delivery']!);
        orderData.result = orderData.result.where((order) {
          return order.delivery == deliveryFilter;
        }).toList();
      }

      customerNameMap = {
        for (var customer in customerResult.result)
          if (customer.id != null) customer.id!: customer.fullName ?? ''
      };

      setState(() {
        orders = orderData;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching data: $e')),
      );
    }
  }

  void _applyFilters() {
    final filters = {
      'orderDate': _orderDateFilterController.text,
      'customerId': _customerIdFilterController.text,
      'customerName': _customerNameFilterController.text,
      if (_selectedDeliveryFilter != null)
        'delivery': _selectedDeliveryFilter!.index.toString(),
    };
    _loadData(filters: filters);
  }

  void _resetFilters() {
    _orderDateFilterController.clear();
    _customerIdFilterController.clear();
    _customerNameFilterController.clear();
    setState(() {
      _selectedDeliveryFilter = null;
    });
    _loadData(); // Reload data with no filters applied
  }

  Future<void> _showApprovalDialog(OrderModel order) async {
    if (order.isApproved ?? false) {
      await showDialog<void>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Narudžba odobrena'),
            content: const Text(
                'Ova narudžba je već odobrena i to se ne može promijeniti.'),
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
      bool? isApproved = await showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Odobri narudžbu'),
            content: const Text('Da li želite odobriti ovu narudžbu?'),
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

      if (isApproved != null && isApproved) {
        await _updateOrderApproval(order);
      }
    }
  }

  Future<void> _updateOrderApproval(OrderModel order) async {
    try {
      order.isApproved = !(order.isApproved ?? false);
      if (order.id != null) {
        await _orderProvider.update(order.id!, order);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order approval status updated')),
        );
        _loadData();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Order ID is null')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating order approval status: $e')),
      );
    }
  }

  String _formatDateTime(DateTime? dateTime) {
    if (dateTime == null) {
      return '';
    }
    return DateFormat('d.M.yyyy HH:mm:ss').format(dateTime);
  }

  Delivery? getDeliveryById(int? id) {
    if (id == null) return null;
    return Delivery.values[id];
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: "Lista narudžbi",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text(
              "Lista narudžbi",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1D3557),
                fontFamily: 'Roboto',
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customerNameFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Filtriraj po imenu kupca',
                      labelStyle: TextStyle(color: Color(0xFF1D3557)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1D3557)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1D3557)),
                      ),
                    ),
                    style: const TextStyle(color: Color(0xFF1D3557)),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: DropdownButtonFormField<Delivery>(
                    value: _selectedDeliveryFilter,
                    decoration: const InputDecoration(
                      labelText: 'Filtriraj po dostavi',
                      labelStyle: TextStyle(color: Color(0xFF1D3557)),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1D3557)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF1D3557)),
                      ),
                    ),
                    items: Delivery.values.map((Delivery delivery) {
                      return DropdownMenuItem<Delivery>(
                        value: delivery,
                        child: Text(
                          delivery.displayName,
                          style: const TextStyle(color: Color(0xFF1D3557)),
                        ),
                      );
                    }).toList(),
                    onChanged: (Delivery? newValue) {
                      setState(() {
                        _selectedDeliveryFilter = newValue;
                      });
                    },
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
                  onPressed: _resetFilters,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: const Color(0xFF1D3557),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16.0, horizontal: 24.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  child: const Text("Poništi filtere"),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: DataTable(
                    columns: const [
                      DataColumn(
                        label: Text(
                          'Datum narudžbe',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Kupac',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Iznos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                            fontFamily: 'Roboto',
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Dostava',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF1D3557),
                            fontFamily: 'Roboto',
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
                      DataColumn(label: Text(""))
                    ],
                    rows: orders?.result.map((order) {
                          return DataRow(
                            cells: [
                              DataCell(Text(
                                _formatDateTime(order.orderDate),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C5C7F),
                                  fontFamily: 'Roboto',
                                ),
                              )),
                              DataCell(
                                Text(
                                  customerNameMap[order.customerId] ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF2C5C7F),
                                    fontFamily: 'Roboto',
                                  ),
                                ),
                              ),
                              DataCell(Text(
                                order.totalPrice.toString(),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C5C7F),
                                  fontFamily: 'Roboto',
                                ),
                              )),
                              DataCell(Text(
                                getDeliveryById(order.delivery)?.displayName ??
                                    '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF2C5C7F),
                                  fontFamily: 'Roboto',
                                ),
                              )),
                              DataCell(
                                Checkbox(
                                  value: order.isApproved,
                                  onChanged: (bool? value) {
                                    if (value != null) {
                                      _showApprovalDialog(order);
                                    }
                                  },
                                ),
                              ),
                              DataCell(
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            OrderDetailScreen(order: order),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white,
                                    backgroundColor: const Color(0xFF1D3557),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8.0, horizontal: 16.0),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8.0),
                                    ),
                                  ),
                                  child: const Text("Detaljni prikaz"),
                                ),
                              ),
                              DataCell(
                                DeleteModal(
                                  title: 'Potvrda brisanja',
                                  content:
                                      'Da li ste sigurni da želite obrisati ovu narudžbu?',
                                  onDelete: () async {
                                    await _orderProvider.delete(order.id!);
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
