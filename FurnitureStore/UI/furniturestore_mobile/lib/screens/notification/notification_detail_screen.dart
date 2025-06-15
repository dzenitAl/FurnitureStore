import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/notification/notification.dart';
import 'package:furniturestore_mobile/providers/notification_provider.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NotificationDetailScreen extends StatefulWidget {
  final NotificationModel? notification;

  const NotificationDetailScreen({super.key, this.notification});

  @override
  State<NotificationDetailScreen> createState() =>
      _NotificationDetailScreenState();
}

class _NotificationDetailScreenState extends State<NotificationDetailScreen> {
  String formatDate(DateTime dateTime) {
    return DateFormat('dd.MM.yyyy.').format(dateTime);
  }

  @override
  void initState() {
    super.initState();
    _markAsRead();
  }

  Future<void> _markAsRead() async {
    if (widget.notification?.id != null &&
        widget.notification?.isRead == false) {
      try {
        final notificationProvider = context.read<NotificationProvider>();
        await notificationProvider.markAsRead(widget.notification!.id!);

        setState(() {
          widget.notification?.isRead = true;
        });
      } catch (e) {
        print('Error marking notification as read: $e');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content:
                  Text('Greška prilikom označavanja obavijesti kao pročitane'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text('Obavijesti'),
      showBackButton: true,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.notifications, color: Colors.blue[200]),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    widget.notification?.heading ?? 'Nema naslova',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2C5C7F),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              widget.notification?.content ?? 'Nema sadržaja',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4B4B4B),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.access_time, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Datum kreiranja: ${widget.notification?.createdAt != null ? formatDate(widget.notification!.createdAt!) : 'N/A'}',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
