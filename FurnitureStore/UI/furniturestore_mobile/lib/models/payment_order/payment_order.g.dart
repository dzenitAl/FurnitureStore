// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'payment_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PaymentOrderModel _$PaymentOrderModelFromJson(Map<String, dynamic> json) =>
    PaymentOrderModel(
      json['cardNumber'] as String?,
      json['month'] as String?,
      json['year'] as String?,
      json['cvc'] as String?,
      (json['totalPrice'] as num?)?.toInt(),
    );

Map<String, dynamic> _$PaymentOrderModelToJson(PaymentOrderModel instance) =>
    <String, dynamic>{
      'cardNumber': instance.cardNumber,
      'month': instance.month,
      'year': instance.year,
      'cvc': instance.cvc,
      'totalPrice': instance.totalPrice,
    };
