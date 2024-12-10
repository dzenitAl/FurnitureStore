import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';

class ProductProvider extends BaseProvider<ProductModel> {
  ProductProvider() : super("Product");

  @override
  ProductModel fromJson(data) {
    return ProductModel.fromJson(data);
  }
}
