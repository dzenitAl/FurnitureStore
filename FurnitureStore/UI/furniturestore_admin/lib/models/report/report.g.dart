// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'report.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ReportModel _$ReportModelFromJson(Map<String, dynamic> json) => ReportModel(
      id: (json['id'] as num?)?.toInt(),
      generationDate: json['generationDate'] == null
          ? null
          : DateTime.parse(json['generationDate'] as String),
      month: (json['month'] as num?)?.toInt(),
      year: (json['year'] as num?)?.toInt(),
      content: json['content'] as String?,
      admin: (json['admin'] as num?)?.toInt(),
      customerId: json['customerId'] as String?,
      customer: (json['customer'] as List<dynamic>?)
          ?.map((e) => AccountModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      reportType: (json['reportType'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ReportModelToJson(ReportModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'generationDate': instance.generationDate?.toIso8601String(),
      'month': instance.month,
      'year': instance.year,
      'content': instance.content,
      'admin': instance.admin,
      'customerId': instance.customerId,
      'customer': instance.customer,
      'reportType': instance.reportType,
    };
