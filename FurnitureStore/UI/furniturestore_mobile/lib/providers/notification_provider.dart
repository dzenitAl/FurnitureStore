import 'package:furniturestore_mobile/models/notification/notification.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';

class NotificationProvider extends BaseProvider<NotificationModel> {
  NotificationProvider() : super("Notification");

  @override
  NotificationModel fromJson(data) {
    return NotificationModel.fromJson(data);
  }
}
