import 'package:furniturestore_admin/models/product/product.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_item.g.dart';

@JsonSerializable()
class OrderItemModel {
  int? id;
  String? productName;
  int? quantity;
  double? price;
  int? orderId;
  int? productId;
  ProductModel? product;

  OrderItemModel({
    this.id,
    this.productName,
    this.quantity,
    this.price,
    this.orderId,
    this.productId,
    this.product,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    var orderItem = _$OrderItemModelFromJson(json);

    if (orderItem.product != null) {
      orderItem.productName ??= orderItem.product!.name;
      orderItem.price ??= orderItem.product!.price;
    }

    return orderItem;
  }

  Map<String, dynamic> toJson() => _$OrderItemModelToJson(this);
}
