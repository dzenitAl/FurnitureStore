// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AccountModel _$AccountModelFromJson(Map<String, dynamic> json) => AccountModel(
      json['role'] as String?,
      json['fullName'] as String?,
      json['id'] as String?,
      json['firstName'] as String?,
      json['lastName'] as String?,
      json['email'] as String?,
      (json['gender'] as num?)?.toInt(),
      json['phoneNumber'] as String?,
      json['userName'] as String?,
      json['password'] as String?,
      json['confirmPassword'] as String?,
      (json['userType'] as num?)?.toInt(),
      json['birthDate'] == null
          ? null
          : DateTime.parse(json['birthDate'] as String),
    );

Map<String, dynamic> _$AccountModelToJson(AccountModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'fullName': instance.fullName,
      'email': instance.email,
      'gender': instance.gender,
      'phoneNumber': instance.phoneNumber,
      'userName': instance.userName,
      'password': instance.password,
      'confirmPassword': instance.confirmPassword,
      'userType': instance.userType,
      'role': instance.role,
      'birthDate': instance.birthDate?.toIso8601String(),
    };
