import 'dart:convert';

import 'package:furniturestore_mobile/models/search_result.dart';

import '../models/notification/notification.dart';
import 'base_provider.dart';

class NotificationProvider extends BaseProvider<NotificationModel> {
  @override
  NotificationModel fromJson(data) {
    return NotificationModel.fromJson(data);
  }

  String? _mainBaseUrl;

  NotificationProvider() : super("Notification") {
    _mainBaseUrl = const String.fromEnvironment("mainBaseUrl",
        defaultValue: "http://10.0.2.2:7055/api/");
  }

  Future<SearchResult<NotificationModel>> getData({dynamic filter}) async {
    var url = "${_mainBaseUrl}Notification";
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
}
