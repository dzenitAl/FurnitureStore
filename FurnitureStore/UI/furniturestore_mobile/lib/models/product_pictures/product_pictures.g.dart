// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_pictures.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductPicturesModel _$ProductPicturesModelFromJson(
        Map<String, dynamic> json) =>
    ProductPicturesModel(
      id: (json['id'] as num?)?.toInt(),
      imagePath: json['imagePath'] as String?,
    );

Map<String, dynamic> _$ProductPicturesModelToJson(
        ProductPicturesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imagePath': instance.imagePath,
    };
