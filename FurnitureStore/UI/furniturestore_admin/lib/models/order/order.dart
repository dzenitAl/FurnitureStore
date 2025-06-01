import 'package:furniturestore_admin/models/order_item/order_item.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order.g.dart';

@JsonSerializable()
class OrderModel {
  int? id;
  DateTime? orderDate;
  int? delivery;
  double? totalPrice;
  bool? isApproved;
  String? customerId;
  List<OrderItemModel>? orderItems;

  OrderModel({
    this.id,
    this.orderDate,
    this.delivery,
    this.totalPrice,
    this.isApproved,
    this.customerId,
    this.orderItems,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);
}
