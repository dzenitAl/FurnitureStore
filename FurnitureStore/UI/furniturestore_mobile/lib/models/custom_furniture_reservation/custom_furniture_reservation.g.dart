// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_furniture_reservation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CustomFurnitureReservationModel _$CustomFurnitureReservationModelFromJson(
        Map<String, dynamic> json) =>
    CustomFurnitureReservationModel(
      id: (json['id'] as num?)?.toInt(),
      note: json['note'] as String?,
      reservationDate: json['reservationDate'] == null
          ? null
          : DateTime.parse(json['reservationDate'] as String),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      reservationStatus: json['reservationStatus'] as bool?,
      userId: json['userId'] as String?,
    );

Map<String, dynamic> _$CustomFurnitureReservationModelToJson(
        CustomFurnitureReservationModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'note': instance.note,
      'reservationDate': instance.reservationDate?.toIso8601String(),
      'createdDate': instance.createdDate?.toIso8601String(),
      'reservationStatus': instance.reservationStatus,
      'userId': instance.userId,
    };
