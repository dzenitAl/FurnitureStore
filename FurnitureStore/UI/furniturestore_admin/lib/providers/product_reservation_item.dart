import 'package:furniturestore_admin/models/product_reservation_item/product_reservation_item.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';

class ProductReservationItemProvider
    extends BaseProvider<ProductReservationItemModel> {
  ProductReservationItemProvider() : super("ProductReservationItem");

  @override
  ProductReservationItemModel fromJson(data) {
    return ProductReservationItemModel.fromJson(data);
  }
}