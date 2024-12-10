import 'package:furniturestore_admin/models/product_reservation/product_reservation.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';

class ProductReservationProvider extends BaseProvider<ProductReservationModel> {
  ProductReservationProvider() : super("ProductReservation");

  @override
  ProductReservationModel fromJson(data) {
    return ProductReservationModel.fromJson(data);
  }
}
