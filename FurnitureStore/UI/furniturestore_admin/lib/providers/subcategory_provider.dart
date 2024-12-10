import 'package:furniturestore_admin/models/subcategory/subcategory.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';

class SubcategoryProvider extends BaseProvider<SubcategoryModel> {
  SubcategoryProvider() : super("Subcategory");

  @override
  SubcategoryModel fromJson(data) {
    return SubcategoryModel.fromJson(data);
  }
}
