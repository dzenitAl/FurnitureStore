import 'package:furniturestore_mobile/models/wish_list/wish_list.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WishListProvider extends BaseProvider<WishListModel> {
  WishListProvider() : super("WishList");

  @override
  WishListModel fromJson(data) {
    return WishListModel.fromJson(data);
  }

  Future<WishListModel> addProductToWishList(
      int wishListId, int productId) async {
    final url =
        '${BaseProvider.baseUrl}WishList/$wishListId/AddProduct/$productId';
    final response = await http.put(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return WishListModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to add product to wish list');
    }
  }

  Future<WishListModel> removeProductFromWishList(
      int wishListId, int productId) async {
    final url =
        '${BaseProvider.baseUrl}WishList/$wishListId/RemoveProduct/$productId';
    final response = await http.delete(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return WishListModel.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to remove product from wish list');
    }
  }
}
