// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductModel _$ProductModelFromJson(Map<String, dynamic> json) => ProductModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      description: json['description'] as String?,
      barcode: json['barcode'] as String?,
      price: (json['price'] as num?)?.toDouble(),
      dimensions: json['dimensions'] as String?,
      isAvailableInStore: json['isAvailableInStore'] as bool?,
      isAvailableOnline: json['isAvailableOnline'] as bool?,
      subcategoryId: (json['subcategoryId'] as num?)?.toInt(),
      pictures: (json['pictures'] as List<dynamic>?)
          ?.map((e) => ProductPicturesModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductModelToJson(ProductModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'barcode': instance.barcode,
      'price': instance.price,
      'dimensions': instance.dimensions,
      'isAvailableInStore': instance.isAvailableInStore,
      'isAvailableOnline': instance.isAvailableOnline,
      'subcategoryId': instance.subcategoryId,
      'pictures': instance.pictures,
    };
