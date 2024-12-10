import 'package:furniturestore_admin/models/custom_furniture_reservation/custom_furniture_reservation.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';

class CustomReservationProvider
    extends BaseProvider<CustomFurnitureReservationModel> {
  CustomReservationProvider() : super("CustomFurnitureReservation");

  @override
  CustomFurnitureReservationModel fromJson(data) {
    return CustomFurnitureReservationModel.fromJson(data);
  }
}
