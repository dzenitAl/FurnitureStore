import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/product_reservation/product_reservation.dart';
import 'package:furniturestore_mobile/models/product_reservation_item/product_reservation_item.dart';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/providers/product_provider.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:intl/intl.dart';

class ProductReservationDetailScreen extends StatefulWidget {
  final ProductReservationModel reservation;
  final List<ProductReservationItemModel> items;

  const ProductReservationDetailScreen({
    super.key,
    required this.reservation,
    required this.items,
  });

  @override
  State<ProductReservationDetailScreen> createState() =>
      _ProductReservationDetailScreenState();
}

class _ProductReservationDetailScreenState
    extends State<ProductReservationDetailScreen> {
  final ProductProvider _productProvider = ProductProvider();

  final Map<int, ProductModel> _productCache = {};

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      title: 'Detalji rezervacijee',
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Datum rezervacije: ${widget.reservation.reservationDate != null ? DateFormat('d.M.y').format(widget.reservation.reservationDate!.toLocal()) : 'N/A'}',
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Broj proizvoda: ${widget.items.length}',
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
            const Divider(height: 20),
            const Text(
              'Proizvodi:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: widget.items.length,
                itemBuilder: (context, index) {
                  final item = widget.items[index];

                  if (_productCache.containsKey(item.productId)) {
                    final product = _productCache[item.productId]!;
                    return _buildListTile(
                      item,
                      product.name ?? 'Nepoznat proizvod',
                    );
                  }

                  return FutureBuilder<ProductModel>(
                    future:
                        item.productId == null
                            ? Future.error('Proizvod ID je null')
                            : _productProvider.getById(item.productId!).then((
                              product,
                            ) {
                              _productCache[item.productId!] = product;
                              return product;
                            }),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const ListTile(
                          leading: CircularProgressIndicator(),
                          title: Text('Učitavanje proizvoda...'),
                        );
                      } else if (snapshot.hasError || !snapshot.hasData) {
                        return _buildListTile(item, 'Nepoznat proizvod');
                      } else {
                        final product = snapshot.data!;
                        return _buildListTile(
                          item,
                          product.name ?? 'Nepoznat proizvod',
                        );
                      }
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListTile(ProductReservationItemModel item, String productName) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.teal.shade700,
          child: Text(
            '${item.quantity}x',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        title: Text(
          productName,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
      ),
    );
  }
}
