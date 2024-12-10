import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class AccountModel {
  String? id;
  String? firstName;
  String? lastName;
  String? fullName;
  String? email;
  int? gender;
  String? phoneNumber;
  String? userName;
  String? password;
  String? confirmPassword;
  int? userType;
  String? role;
  DateTime? birthDate;
  AccountModel(
      this.role,
      this.fullName,
      this.id,
      this.firstName,
      this.lastName,
      this.email,
      this.gender,
      this.phoneNumber,
      this.userName,
      this.password,
      this.confirmPassword,
      this.userType,
      this.birthDate);

  factory AccountModel.fromJson(Map<String, dynamic> json) =>
      _$AccountModelFromJson(json);

  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}
