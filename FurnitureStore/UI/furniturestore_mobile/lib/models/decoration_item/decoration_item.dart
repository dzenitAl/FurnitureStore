import 'package:json_annotation/json_annotation.dart';
import 'package:furniturestore_mobile/models/product_pictures/product_pictures.dart';

part 'decoration_item.g.dart';

@JsonSerializable()
class DecorationItemModel {
  int? id;
  String? name;
  String? description;
  double? price;
  String? dimensions;
  String? material;
  String? style;
  String? color;
  int? stockQuantity;
  int? categoryId;
  bool? isAvailableInStore;
  bool? isAvailableOnline;
  List<ProductPicturesModel>? pictures;
  List<ProductPicturesModel>? productPictures;
  List<String>? pictureUrls;

  DecorationItemModel({
    this.id,
    this.name,
    this.description,
    this.price,
    this.dimensions,
    this.material,
    this.style,
    this.color,
    this.stockQuantity,
    this.categoryId,
    this.isAvailableInStore,
    this.isAvailableOnline,
    this.pictures,
    this.productPictures,
    this.pictureUrls,
  });
  factory DecorationItemModel.fromJson(Map<String, dynamic> json) {
    var model = _$DecorationItemModelFromJson(json);

    // Ako postoje punopravni objekti slika (kao na desktopu)
    if (json['pictures'] != null) {
      model.pictures = (json['pictures'] as List)
          .map((x) => ProductPicturesModel.fromJson(x))
          .toList();
    }

    // Ako postoje samo URL-ovi (kao plan B)
    if (model.pictureUrls != null && model.pictureUrls!.isNotEmpty) {
      model.pictures = model.pictureUrls!
          .map((url) => ProductPicturesModel(id: null, imagePath: url))
          .toList();
    }

    return model;
  }

  Map<String, dynamic> toJson() => _$DecorationItemModelToJson(this);
}
