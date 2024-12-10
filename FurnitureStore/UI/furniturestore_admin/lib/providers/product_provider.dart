import 'package:furniturestore_admin/models/product/product.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';

class ProductProvider extends BaseProvider<ProductModel> {
  ProductProvider() : super("Product");

  @override
  ProductModel fromJson(data) {
    return ProductModel.fromJson(data);
  }
}
