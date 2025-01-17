import 'package:furniturestore_mobile/models/city/city.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';

class CityProvider extends BaseProvider<CityModel> {
  CityProvider() : super("City");

  @override
  CityModel fromJson(data) {
    return CityModel.fromJson(data);
  }
}
