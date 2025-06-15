import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class NotificationModel {
  int? id;
  String? heading;
  String? content;
  String? adminId;
  @JsonKey(fromJson: _dateFromJson, toJson: _dateToJson)
  DateTime? createdAt;

  NotificationModel({
    this.id,
    this.heading,
    this.content,
    this.adminId,
    this.createdAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  static DateTime? _dateFromJson(dynamic date) {
    if (date == null) return null;
    if (date is DateTime) return date;
    try {
      return DateTime.parse(date.toString());
    } catch (e) {
      print('Error parsing date: $date');
      return null;
    }
  }

  static String? _dateToJson(DateTime? date) {
    if (date == null) return null;
    return date.toIso8601String();
  }
}
