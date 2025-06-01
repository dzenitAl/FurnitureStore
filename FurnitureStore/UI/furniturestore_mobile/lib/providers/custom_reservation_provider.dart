import 'package:furniturestore_mobile/models/custom_furniture_reservation/custom_furniture_reservation.dart';
import 'package:furniturestore_mobile/models/search_result.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';

class CustomReservationProvider
    extends BaseProvider<CustomFurnitureReservationModel> {
  CustomReservationProvider() : super("CustomFurnitureReservation");

  @override
  CustomFurnitureReservationModel fromJson(data) {
    return CustomFurnitureReservationModel.fromJson(data);
  }

  Future<SearchResult<CustomFurnitureReservationModel>> getByUserId(
      String userId) async {
    var response = await get("", filter: {"userId": userId});
    return response;
  }
}
