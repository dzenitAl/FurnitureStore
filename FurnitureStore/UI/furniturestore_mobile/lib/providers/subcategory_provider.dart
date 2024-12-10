import 'package:furniturestore_mobile/models/subcategory/subcategory.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';

class SubcategoryProvider extends BaseProvider<SubcategoryModel> {
  SubcategoryProvider() : super("Subcategory");

  @override
  SubcategoryModel fromJson(data) {
    return SubcategoryModel.fromJson(data);
  }
}
