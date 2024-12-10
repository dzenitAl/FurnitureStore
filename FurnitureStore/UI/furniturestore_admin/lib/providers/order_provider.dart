import 'package:furniturestore_admin/models/order/order.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';

class OrderProvider extends BaseProvider<OrderModel> {
  OrderProvider() : super("Order");

  @override
  OrderModel fromJson(data) {
    return OrderModel.fromJson(data);
  }
}
