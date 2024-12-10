import 'package:furniturestore_mobile/models/product_reservation/product_reservation.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';

class ProductReservationProvider extends BaseProvider<ProductReservationModel> {
  ProductReservationProvider() : super("ProductReservation");

  @override
  ProductReservationModel fromJson(data) {
    return ProductReservationModel.fromJson(data);
  }
}
