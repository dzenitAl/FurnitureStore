import 'package:furniturestore_mobile/models/order_item/order_item.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';

class OrderItemProvider extends BaseProvider<OrderItemModel> {
  OrderItemProvider() : super("OrderItem");

  @override
  OrderItemModel fromJson(data) {
    return OrderItemModel.fromJson(data);
  }
}
