import 'package:json_annotation/json_annotation.dart';

part 'product_reservation.g.dart';

@JsonSerializable()
class ProductReservationModel {
  int? id;
  DateTime? reservationDate;
  bool? isApproved;
  String? notes;
  String? customerId;

  ProductReservationModel({
    this.id,
    this.reservationDate,
    this.isApproved,
    this.notes,
    this.customerId,
  });

  factory ProductReservationModel.fromJson(Map<String, dynamic> json) =>
      _$ProductReservationModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductReservationModelToJson(this);
}
