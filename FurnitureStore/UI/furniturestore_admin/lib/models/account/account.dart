

import 'package:json_annotation/json_annotation.dart';

part 'account.g.dart';

@JsonSerializable()
class AccountModel {
  String ? id;
  String ? firstName;
  String ? lastName;
  String ? fullName;
  String ? email;
  int? gender ;
  String? phoneNumber;
  String ? userName;
  String? password;
  String? confirmPassword;
  int? userType;
  String ? role;
  DateTime ? birthDate;
AccountModel(this.role,this.fullName,this.id, this.firstName, this.lastName, this.email,this.gender, this.phoneNumber,this.userName,this.password,this.confirmPassword,this.userType,this.birthDate);
      /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory AccountModel.fromJson(Map<String, dynamic> json) => _$AccountModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$AccountModelToJson(this);
}