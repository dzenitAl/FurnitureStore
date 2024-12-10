// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wish_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WishListModel _$WishListModelFromJson(Map<String, dynamic> json) =>
    WishListModel(
      id: (json['id'] as num).toInt(),
      dateCreated: DateTime.parse(json['dateCreated'] as String),
      customerId: json['customerId'] as String,
      products: (json['products'] as List<dynamic>)
          .map((e) => ProductModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$WishListModelToJson(WishListModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'dateCreated': instance.dateCreated.toIso8601String(),
      'customerId': instance.customerId,
      'products': instance.products,
    };
