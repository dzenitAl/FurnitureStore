import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';
import 'dart:convert';

class ProductProvider extends BaseProvider<ProductModel> {
  ProductProvider() : super("Product");

  @override
  ProductModel fromJson(data) {
    return ProductModel.fromJson(data);
  }

  Future<List<ProductModel>> getRecommendedProducts(int productId) async {
    var url = "${BaseProvider.baseUrl}Product/$productId/recommend";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();

    var response = await http!.get(uri, headers: headers);

    if (isValidResponse(response)) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch recommended products");
    }
  }

  Future<List<ProductModel>> getProductsWithPictures(List<int> ids) async {
    var url = "${BaseProvider.baseUrl}Product/with-pictures";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();

    var body = jsonEncode({"ids": ids});
    var response = await http!.post(uri, headers: headers, body: body);

    if (isValidResponse(response)) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch products with pictures");
    }
  }
}
