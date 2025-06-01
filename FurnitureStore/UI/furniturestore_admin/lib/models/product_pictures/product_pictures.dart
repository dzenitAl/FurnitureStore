import 'package:json_annotation/json_annotation.dart';

part 'product_pictures.g.dart';

@JsonSerializable()
class ProductPicturesModel {
  int? id;
  String? imagePath;

  ProductPicturesModel({this.id, this.imagePath});

  factory ProductPicturesModel.fromJson(Map<String, dynamic> json) =>
      _$ProductPicturesModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductPicturesModelToJson(this);
}
