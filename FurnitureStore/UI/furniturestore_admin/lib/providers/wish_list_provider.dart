import 'package:furniturestore_admin/models/wish_list/wish_list.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';

class WishListProvider extends BaseProvider<WishListModel> {
  WishListProvider() : super("WishList");

  @override
  WishListModel fromJson(data) {
    return WishListModel.fromJson(data);
  }
}
