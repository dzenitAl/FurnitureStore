import 'package:json_annotation/json_annotation.dart';

part 'category.g.dart';

@JsonSerializable()
class CategoryModel {
  int? id;
  String? name;
  String? description;
  String? imagePath;
  int? imageId;

  CategoryModel(
      this.id, this.name, this.description, this.imagePath, this.imageId);

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);
}
