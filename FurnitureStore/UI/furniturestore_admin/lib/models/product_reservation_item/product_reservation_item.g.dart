// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_reservation_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductReservationItemModel _$ProductReservationItemModelFromJson(
        Map<String, dynamic> json) =>
    ProductReservationItemModel(
      id: (json['id'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      productReservationId: (json['productReservationId'] as num?)?.toInt(),
      productId: (json['productId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductReservationItemModelToJson(
        ProductReservationItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'productReservationId': instance.productReservationId,
      'productId': instance.productId,
    };
