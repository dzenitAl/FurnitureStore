// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductReservationModel _$ProductReservationModelFromJson(
        Map<String, dynamic> json) =>
    ProductReservationModel(
      id: (json['id'] as num?)?.toInt(),
      reservationDate: json['reservationDate'] == null
          ? null
          : DateTime.parse(json['reservationDate'] as String),
      isApproved: json['isApproved'] as bool?,
      notes: json['notes'] as String?,
      customerId: json['customerId'] as String?,
    );

Map<String, dynamic> _$ProductReservationModelToJson(
        ProductReservationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reservationDate': instance.reservationDate?.toIso8601String(),
      'isApproved': instance.isApproved,
      'notes': instance.notes,
      'customerId': instance.customerId,
    };
