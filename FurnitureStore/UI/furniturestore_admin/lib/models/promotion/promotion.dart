import 'package:json_annotation/json_annotation.dart';
import 'package:furniturestore_admin/models/account/account.dart';
import 'package:furniturestore_admin/models/product/product.dart';

part 'promotion.g.dart';

@JsonSerializable()
class PromotionModel {
  int? id;
  String? heading;
  String? content;
  String? imagePath;
  String? adminId;
  AccountModel? admin;
  List<ProductModel>? products;

  PromotionModel({
    this.id,
    this.heading,
    this.content,
    this.imagePath,
    this.adminId,
    this.admin,
    this.products,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionModelToJson(this);
}
