import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/notification/notification.dart';

class NotificationDetailScreen extends StatelessWidget {
  final NotificationModel? notification;

  const NotificationDetailScreen({super.key, this.notification});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Obavijesti'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              notification?.heading ?? 'Nema naslova',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2C5C7F),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              notification?.content ?? 'Nema sadržaja',
              style: const TextStyle(
                fontSize: 16,
                color: Color(0xFF4B4B4B),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
