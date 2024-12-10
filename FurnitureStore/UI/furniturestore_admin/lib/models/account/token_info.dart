
import 'package:json_annotation/json_annotation.dart';

part 'token_info.g.dart';

@JsonSerializable()
class TokenInfoModel {
String? nameid ;

TokenInfoModel(this.nameid);

 factory TokenInfoModel.fromJson(Map<String, dynamic> json) => _$TokenInfoModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$TokenInfoModelToJson(this);
}