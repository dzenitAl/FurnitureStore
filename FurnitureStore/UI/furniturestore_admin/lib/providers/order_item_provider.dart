import 'package:furniturestore_admin/models/order_item/order_item.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';

class OrderItemProvider extends BaseProvider<OrderItemModel> {
  OrderItemProvider() : super("OrderItem");

  @override
  OrderItemModel fromJson(data) {
    return OrderItemModel.fromJson(data);
  }
}
