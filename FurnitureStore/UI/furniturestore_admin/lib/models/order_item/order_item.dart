import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItemModel {
  int? id;
  int? quantity;
  int? orderId;
  int? productId;

  OrderItemModel({
    this.id,
    this.quantity,
    this.orderId,
    this.productId,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) =>
      _$OrderItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}
