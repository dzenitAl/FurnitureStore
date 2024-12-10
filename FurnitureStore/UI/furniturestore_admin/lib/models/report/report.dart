import 'package:furniturestore_admin/models/account/account.dart';
import 'package:json_annotation/json_annotation.dart';

part 'report.g.dart';

@JsonSerializable()
class ReportModel {
  int? id;
  DateTime? generationDate;
  int? month;
  int? year;
  String? content;
  int? admin;
  String? customerId;
  List<AccountModel>? customer;
  int? reportType;

  ReportModel({
    this.id,
    this.generationDate,
    this.month,
    this.year,
    this.content,
    this.admin,
    this.customerId,
    this.customer,
    this.reportType,
  });

  factory ReportModel.fromJson(Map<String, dynamic> json) =>
      _$ReportModelFromJson(json);
  Map<String, dynamic> toJson() => _$ReportModelToJson(this);
}
