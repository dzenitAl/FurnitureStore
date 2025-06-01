import 'dart:convert';
import 'package:furniturestore_admin/models/order/order.dart';
import 'package:furniturestore_admin/models/order_item/order_item.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';
import 'package:furniturestore_admin/providers/order_item_provider.dart';
import 'package:http/http.dart' as http;

class OrderProvider extends BaseProvider<OrderModel> {
  late OrderItemProvider _orderItemProvider;

  OrderProvider() : super("Order") {
    _orderItemProvider = OrderItemProvider();
  }

  @override
  OrderModel fromJson(data) {
    return OrderModel.fromJson(data);
  }

  Future<OrderModel?> getOrderDetails(int orderId) async {
    try {
      var url = "${BaseProvider.baseUrl}Order/$orderId";
      print("Calling API at URL: $url");

      var uri = Uri.parse(url);
      var headers = createHeaders();
      print("Headers used: $headers");

      var response = await http.get(uri, headers: headers);
      print("Response status code: ${response.statusCode}");

      if (response.statusCode == 200) {
        if (response.body.isEmpty) {
          print("API returned empty response body");
          return null;
        }

        try {
          var jsonData = json.decode(response.body);
          print("Parsed JSON: $jsonData");

          var orderItems = await _orderItemProvider.getByOrderId(orderId);

          var order = OrderModel.fromJson(jsonData);
          order.orderItems = orderItems;

          return order;
        } catch (e) {
          print("Error parsing JSON: $e");
          return null;
        }
      } else {
        print("API returned status code: ${response.statusCode}");
        print("Response: ${response.body}");
        return null;
      }
    } catch (e) {
      print("Error fetching order: $e");
      return null;
    }
  }
}
