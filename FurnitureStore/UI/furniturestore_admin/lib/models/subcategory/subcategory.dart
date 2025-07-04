import 'package:json_annotation/json_annotation.dart';

part 'subcategory.g.dart';

@JsonSerializable()
class SubcategoryModel {
  int? id;
  String? name;
  int? categoryId;
  String? imagePath;

  SubcategoryModel(this.id, this.name, this.categoryId, this.imagePath);

  factory SubcategoryModel.fromJson(Map<String, dynamic> json) =>
      _$SubcategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$SubcategoryModelToJson(this);
}
