import 'package:json_annotation/json_annotation.dart';
import 'package:furniturestore_admin/models/product_pictures/product_pictures.dart';

part 'decoration_item.g.dart';

@JsonSerializable()
class DecorationItemModel {
  int? id;
  String? name;
  String? description;
  double? price;
  String? dimensions;
  bool? isAvailableInStore;
  bool? isAvailableOnline;
  int? categoryId;
  List<ProductPicturesModel>? pictures;
  String? material;
  int? stockQuantity;
  String? style;
  String? color;
  bool? isFragile;
  String? careInstructions;

  DecorationItemModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.dimensions,
    this.isAvailableInStore,
    this.isAvailableOnline,
    this.categoryId,
    this.pictures,
    this.material,
    this.stockQuantity,
    this.style,
    this.color,
    this.isFragile,
    this.careInstructions,
  });

  factory DecorationItemModel.fromJson(Map<String, dynamic> json) =>
      _$DecorationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$DecorationItemModelToJson(this);
}
