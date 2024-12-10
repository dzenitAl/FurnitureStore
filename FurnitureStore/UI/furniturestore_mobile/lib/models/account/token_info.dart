import 'package:json_annotation/json_annotation.dart';

part 'token_info.g.dart';

@JsonSerializable()
class TokenInfoModel {
  String? nameid;

  TokenInfoModel(this.nameid);

  factory TokenInfoModel.fromJson(Map<String, dynamic> json) =>
      _$TokenInfoModelFromJson(json);

  Map<String, dynamic> toJson() => _$TokenInfoModelToJson(this);
}
