// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'promotion.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PromotionModel _$PromotionModelFromJson(Map<String, dynamic> json) =>
    PromotionModel(
      id: (json['id'] as num?)?.toInt(),
      heading: json['heading'] as String?,
      content: json['content'] as String?,
      adminId: json['adminId'] as String?,
      admin: json['admin'] == null
          ? null
          : AccountModel.fromJson(json['admin'] as Map<String, dynamic>),
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PromotionModelToJson(PromotionModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'heading': instance.heading,
      'content': instance.content,
      'adminId': instance.adminId,
      'admin': instance.admin,
      'products': instance.products,
    };
