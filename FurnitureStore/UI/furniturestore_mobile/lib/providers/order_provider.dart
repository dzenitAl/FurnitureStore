import 'dart:convert';

import 'package:furniturestore_mobile/models/order/order.dart';
import 'package:furniturestore_mobile/models/order_item/order_item.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';

class OrderProvider extends BaseProvider<OrderModel> {
  OrderProvider() : super("Order");

  @override
  OrderModel fromJson(data) {
    return OrderModel.fromJson(data);
  }

  Future<void> addProductToOrder(OrderItemModel orderItem) async {
    final order = await getCurrentOrder();
    orderItem.orderId = order.id;

    await insert(orderItem.toJson());
  }

  Future<OrderModel> getCurrentOrder() async {
    return await insert(OrderModel(orderDate: DateTime.now()).toJson());
  }

  Future<bool> pay([dynamic request]) async {
    var url = "${BaseProvider.baseUrl}Payment/pay";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      return false;
    }
  }

  Future save([dynamic request]) async {
    var url = "${BaseProvider.baseUrl}Payment/save";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http!.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      if (response.body != null && response.body.isNotEmpty) {
        var data = jsonDecode(response.body);
      } else {
        print("Empty response body");
      }
    } else {
      print("error $response");
    }
  }
}
