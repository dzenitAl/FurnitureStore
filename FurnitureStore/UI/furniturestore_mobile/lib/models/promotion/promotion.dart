import 'package:furniturestore_mobile/models/account/account.dart';
import 'package:furniturestore_mobile/models/product/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'promotion.g.dart';

@JsonSerializable()
class PromotionModel {
  int? id;
  String? heading;
  String? content;
  String? adminId;
  AccountModel? admin;
  List<ProductModel>? products;
  DateTime? startDate;
  DateTime? endDate;

  PromotionModel({
    this.id,
    this.heading,
    this.content,
    this.adminId,
    this.admin,
    this.products,
    this.startDate,
    this.endDate,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) =>
      _$PromotionModelFromJson(json);

  Map<String, dynamic> toJson() => _$PromotionModelToJson(this);
}
