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
      isAvailableInStore: json['isAvailableInStore'] as bool?,
      isAvailableOnline: json['isAvailableOnline'] as bool?,
      categoryId: (json['categoryId'] as num?)?.toInt(),
      pictures: (json['pictures'] as List<dynamic>?)
          ?.map((e) => ProductPicturesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      material: json['material'] as String?,
      stockQuantity: (json['stockQuantity'] as num?)?.toInt(),
      style: json['style'] as String?,
      color: json['color'] as String?,
      isFragile: json['isFragile'] as bool?,
      careInstructions: json['careInstructions'] as String?,
    );

Map<String, dynamic> _$DecorationItemModelToJson(
        DecorationItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'dimensions': instance.dimensions,
      'isAvailableInStore': instance.isAvailableInStore,
      'isAvailableOnline': instance.isAvailableOnline,
      'categoryId': instance.categoryId,
      'pictures': instance.pictures,
      'material': instance.material,
      'stockQuantity': instance.stockQuantity,
      'style': instance.style,
      'color': instance.color,
      'isFragile': instance.isFragile,
      'careInstructions': instance.careInstructions,
    };
