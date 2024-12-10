import 'package:json_annotation/json_annotation.dart';

part 'custom_furniture_reservation.g.dart';

@JsonSerializable()
class CustomFurnitureReservationModel {
  int? id;
  String? note;
  DateTime? reservationDate;
  DateTime? createdDate;
  bool? reservationStatus;
  String? userId;
  CustomFurnitureReservationModel({
    this.id,
    this.note,
    this.reservationDate,
    this.createdDate,
    this.reservationStatus,
    this.userId,
  });

  factory CustomFurnitureReservationModel.fromJson(Map<String, dynamic> json) =>
      _$CustomFurnitureReservationModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$CustomFurnitureReservationModelToJson(this);
}
