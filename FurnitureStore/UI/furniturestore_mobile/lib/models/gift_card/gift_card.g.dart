// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gift_card.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GiftCardModel _$GiftCardModelFromJson(Map<String, dynamic> json) =>
    GiftCardModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String?,
      cardNumber: json['cardNumber'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      expiryDate: json['expiryDate'] == null
          ? null
          : DateTime.parse(json['expiryDate'] as String),
      isActivated: json['isActivated'] as bool?,
      imagePath: json['imagePath'] as String?,
      imageId: (json['imageId'] as num?)?.toInt(),
    );

Map<String, dynamic> _$GiftCardModelToJson(GiftCardModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'cardNumber': instance.cardNumber,
      'amount': instance.amount,
      'expiryDate': instance.expiryDate?.toIso8601String(),
      'isActivated': instance.isActivated,
      'imagePath': instance.imagePath,
      'imageId': instance.imageId,
    };
