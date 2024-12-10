import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'wish_list.g.dart';

@JsonSerializable()
class WishListModel {
  final int id;
  final DateTime dateCreated;
  final String customerId;
  final List<ProductModel> products;

  WishListModel(
      {required this.id,
      required this.dateCreated,
      required this.customerId,
      required this.products});

  factory WishListModel.fromJson(Map<String, dynamic> json) =>
      _$WishListModelFromJson(json);

  Map<String, dynamic> toJson() => _$WishListModelToJson(this);
}
