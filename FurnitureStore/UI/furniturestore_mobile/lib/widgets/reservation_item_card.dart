import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/widgets/base_item_card.dart';

class ReservationItemCard extends StatelessWidget {
  final String name;
  final double price;
  final int? imageId;
  final String reservationDate;
  final String status;
  final VoidCallback? onTap;
  final VoidCallback? onCancel;

  const ReservationItemCard({
    super.key,
    required this.name,
    required this.price,
    this.imageId,
    required this.reservationDate,
    required this.status,
    this.onTap,
    this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return BaseItemCard(
      name: name,
      price: price,
      imageId: imageId,
      onTap: onTap,
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Datum rezervacije: $reservationDate',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            'Status: $status',
            style: TextStyle(
              fontSize: 14,
              color: _getStatusColor(status),
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      trailing: onCancel != null
          ? IconButton(
              icon: const Icon(Icons.cancel_outlined),
              onPressed: onCancel,
              tooltip: 'Otkaži rezervaciju',
            )
          : null,
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
