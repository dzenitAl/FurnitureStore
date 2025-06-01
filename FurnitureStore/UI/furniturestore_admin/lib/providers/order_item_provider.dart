import 'dart:convert';
import 'package:furniturestore_admin/models/order_item/order_item.dart';
import 'package:furniturestore_admin/models/product/product.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';
import 'package:furniturestore_admin/providers/product_provider.dart';
import 'package:http/http.dart' as http;

class OrderItemProvider extends BaseProvider<OrderItemModel> {
  late ProductProvider _productProvider;

  OrderItemProvider() : super("OrderItem") {
    _productProvider = ProductProvider();
  }

  @override
  OrderItemModel fromJson(data) {
    return OrderItemModel.fromJson(data);
  }

  Future<List<OrderItemModel>> getByOrderId(int orderId) async {
    try {
      var url = "${BaseProvider.baseUrl}OrderItem/GetByOrderId/$orderId";
      var uri = Uri.parse(url);
      var headers = createHeaders();

      var response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        List<dynamic> itemsJson = json.decode(response.body);
        var items =
            itemsJson.map((item) => OrderItemModel.fromJson(item)).toList();

        for (var item in items) {
          if (item.productId != null) {
            var product = await _productProvider.getById(item.productId!);
            item.product = product;
            item.productName = product.name;
          }
        }

        return items;
      } else {
        throw Exception("Failed to load order items: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching order items: $e");
      throw Exception("Error fetching order items: $e");
    }
  }

  Future<OrderItemModel> getOrderItemWithDetails(int orderItemId) async {
    try {
      var orderItem = await getById(orderItemId);

      if (orderItem.productId != null) {
        var product = await _productProvider.getById(orderItem.productId!);
        orderItem.product = product;
        orderItem.productName ??= product.name;
      }

      return orderItem;
    } catch (e) {
      print("Error fetching order item details: $e");
      throw Exception("Error fetching order item details: $e");
    }
  }
}
