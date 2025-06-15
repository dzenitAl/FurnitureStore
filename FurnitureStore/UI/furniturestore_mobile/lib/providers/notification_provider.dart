import 'dart:convert';

import 'package:furniturestore_mobile/models/search_result.dart';

import '../models/notification/notification.dart';
import 'base_provider.dart';

class NotificationProvider extends BaseProvider<NotificationModel> {
  NotificationProvider() : super("Notification") {}

  @override
  NotificationModel fromJson(data) {
    return NotificationModel.fromJson(data);
  }

  Future<SearchResult<NotificationModel>> getData({dynamic filter}) async {
    var url = "${BaseProvider.baseUrl}Notification";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();

    var response = await http!.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<NotificationModel>();
      for (var item in data) {
        result.result.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception("Unknown error");
    }
  }

  Future<NotificationModel> markAsRead(int id) async {
    var url = "${BaseProvider.baseUrl}Notification/$id/mark-read";
    var uri = Uri.parse(url);

    print('Calling URL: $url');

    try {
      var response =
          await http!.put(uri, headers: createAuthorizationHeaders());
      print('Response status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 500) {
        var errorData = jsonDecode(response.body);
        throw Exception(
            "Server error: ${errorData['errors']['ERROR']?[0] ?? 'Unknown server error'}");
      }

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        return fromJson(data);
      } else {
        throw Exception("Failed to mark notification as read");
      }
    } catch (e, stackTrace) {
      print('Error in markAsRead: $e');
      print('Stack trace: $stackTrace');
      throw Exception("Failed to mark notification as read: $e");
    }
  }
}
