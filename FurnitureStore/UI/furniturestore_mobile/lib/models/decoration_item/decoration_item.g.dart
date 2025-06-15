// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'decoration_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DecorationItemModel _$DecorationItemModelFromJson(Map<String, dynamic> json) =>
    DecorationItemModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      dimensions: json['dimensions'] as String?,
      material: json['material'] as String?,
      style: json['style'] as String?,
      color: json['color'] as String?,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
      categoryId: (json['categoryId'] as num?)?.toInt(),
      isAvailableInStore: json['isAvailableInStore'] as bool?,
      isAvailableOnline: json['isAvailableOnline'] as bool?,
      pictures: (json['pictures'] as List<dynamic>?)
          ?.map((e) => ProductPicturesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      productPictures: (json['productPictures'] as List<dynamic>?)
          ?.map((e) => ProductPicturesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      pictureUrls: (json['pictureUrls'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
    );

Map<String, dynamic> _$DecorationItemModelToJson(
        DecorationItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'dimensions': instance.dimensions,
      'material': instance.material,
      'style': instance.style,
      'color': instance.color,
      'stockQuantity': instance.stockQuantity,
      'categoryId': instance.categoryId,
      'isAvailableInStore': instance.isAvailableInStore,
      'isAvailableOnline': instance.isAvailableOnline,
      'pictures': instance.pictures,
      'productPictures': instance.productPictures,
      'pictureUrls': instance.pictureUrls,
    };
