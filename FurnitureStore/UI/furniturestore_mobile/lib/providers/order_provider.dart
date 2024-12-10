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
}
