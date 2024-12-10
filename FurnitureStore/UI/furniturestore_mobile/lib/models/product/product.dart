import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class ProductModel {
  int? id;
  String? name;
  String? description;
  String? barcode;
  double? price;
  String? dimensions;
  bool? isAvailableInStore;
  bool? isAvailableOnline;
  int? subcategoryId;

  ProductModel({
    this.id,
    this.name,
    this.description,
    this.barcode,
    this.price,
    this.dimensions,
    this.isAvailableInStore,
    this.isAvailableOnline,
    this.subcategoryId,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) =>
      _$ProductModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductModelToJson(this);
}
