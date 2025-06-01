import 'package:flutter/material.dart';
import 'package:furniturestore_admin/models/wish_list/wish_list.dart';
import 'package:furniturestore_admin/models/search_result.dart';
import 'package:furniturestore_admin/providers/wish_list_provider.dart';
import 'package:furniturestore_admin/screens/wish_list/wishlist_detail_screen.dart';
import 'package:furniturestore_admin/widgets/master_screen.dart';
import 'package:provider/provider.dart';

class WishListListScreen extends StatefulWidget {
  const WishListListScreen({super.key});

  @override
  State<WishListListScreen> createState() => _WishListListScreenState();
}

class _WishListListScreenState extends State<WishListListScreen> {
  late WishListProvider _wishListProvider;
  SearchResult<WishListModel>? result;
  final TextEditingController _customerIdFilterController =
      TextEditingController();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _wishListProvider = context.read<WishListProvider>();
  }

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  _loadData({Map<String, String>? filters}) async {
    try {
      var data = await _wishListProvider.get(filter: filters);
      setState(() {
        result = data;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("Wish List"),
      child: Container(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const Text("Wish List", style: TextStyle(fontSize: 24)),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _customerIdFilterController,
                    decoration: const InputDecoration(
                      labelText: 'Filter by Customer ID',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: _applyFilters,
                  child: const Text("Search"),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () async {
                    final result = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const WishListDetailScreen(
                          wishList: null,
                        ),
                      ),
                    );
                    if (result == true) {
                      _loadData();
                    }
                  },
                  child: const Text("Add New Wish List"),
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
                      DataColumn(label: Text('ID')),
                      DataColumn(label: Text('Date Created')),
                      DataColumn(label: Text('Customer Name')),
                    ],
                    rows: result?.result.map((WishListModel wishList) {
                          return DataRow(
                              onSelectChanged: (selected) async {
                                if (selected == true) {
                                  final result = await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          WishListDetailScreen(
                                        wishList: wishList,
                                      ),
                                    ),
                                  );
                                  if (result == true) {
                                    _loadData();
                                  }
                                }
                              },
                              cells: [
                                DataCell(Text(wishList.id.toString())),
                                DataCell(Text(wishList.dateCreated.toString())),
                                DataCell(Text(wishList.customerId ?? '')),
                              ]);
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
