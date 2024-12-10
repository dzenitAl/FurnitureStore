import 'package:furniturestore_admin/models/category/category.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';

class CategoryProvider extends BaseProvider<CategoryModel> {
  CategoryProvider() : super("Category");

  @override
  CategoryModel fromJson(data) {
    // TODO: implement fromJson
    return CategoryModel.fromJson(data);
  }
}
