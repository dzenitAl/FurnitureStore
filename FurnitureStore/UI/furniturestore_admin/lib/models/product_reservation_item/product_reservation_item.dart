import 'package:json_annotation/json_annotation.dart';

part 'product_reservation_item.g.dart';

@JsonSerializable()
class ProductReservationItemModel {
  int? id;
  int? quantity;
  int? productReservationId;
  int? productId;

  ProductReservationItemModel({
    this.id,
    this.quantity,
    this.productReservationId,
    this.productId,
  });

  factory ProductReservationItemModel.fromJson(Map<String, dynamic> json) =>
      _$ProductReservationItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProductReservationItemModelToJson(this);
}
