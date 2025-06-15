import 'package:flutter/material.dart';
import 'package:furniturestore_mobile/models/notification/notification.dart';
import 'package:furniturestore_mobile/models/search_result.dart';
import 'package:furniturestore_mobile/providers/notification_provider.dart';
import 'package:furniturestore_mobile/widgets/master_screen.dart';
import 'package:furniturestore_mobile/screens/notification/notification_detail_screen.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  late NotificationProvider _notificationProvider;
  SearchResult<NotificationModel>? result;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _notificationProvider = context.read<NotificationProvider>();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      var notificationData = await _notificationProvider.get("");

      setState(() {
        result = SearchResult<NotificationModel>();
        result!.count = notificationData.count;
        result!.result = notificationData.result;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Greška prilikom dohvatanja podataka: $e')),
      );
    }
  }

  String formatDate(DateTime? dateTime) {
    if (dateTime == null) return '';
    return DateFormat('dd.MM.yyyy. HH:mm').format(dateTime);
  }

  @override
  Widget build(BuildContext context) {
    return MasterScreenWidget(
      titleWidget: const Text("Lista notifikacija"),
      showBackButton: true,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: const Color(0xFFF9F9F9),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.75,
                  mainAxisSpacing: 16.0,
                  crossAxisSpacing: 16.0,
                ),
                itemCount: result?.result.length ?? 0,
                itemBuilder: (context, index) {
                  NotificationModel notification = result!.result[index];
                  return GestureDetector(
                    onTap: () async {
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => NotificationDetailScreen(
                            notification: notification,
                          ),
                        ),
                      );
                      _loadData();
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 222, 235, 245),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.notifications,
                                  color: Colors.blue[200]),
                              SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  notification.heading ?? '',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF1D3557),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Status: ${notification?.isRead == true ? "Obavijest je pročitana" : "Nova obavijest"}',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: notification?.isRead == true
                                  ? Colors.grey
                                  : Colors.red,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Expanded(
                            child: Text(
                              notification.content ?? '',
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: const TextStyle(
                                color: Color(0xFF2C5C7F),
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                " ${formatDate(notification.createdAt)}",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.grey[600]),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
