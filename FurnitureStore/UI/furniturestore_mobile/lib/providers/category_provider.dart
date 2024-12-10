import 'package:furniturestore_mobile/models/category/category.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';

class CategoryProvider extends BaseProvider<CategoryModel> {
  CategoryProvider() : super("Category");

  @override
  CategoryModel fromJson(data) {
    return CategoryModel.fromJson(data);
  }
}
