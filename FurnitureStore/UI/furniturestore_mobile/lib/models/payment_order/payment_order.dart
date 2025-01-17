import 'package:json_annotation/json_annotation.dart';

part 'payment_order.g.dart';

@JsonSerializable()
class PaymentOrderModel {
  String? cardNumber;
  String? month;
  String? year;
  String? cvc;
  int? totalPrice;
  PaymentOrderModel(
      this.cardNumber, this.month, this.year, this.cvc, this.totalPrice);

  /// A necessary factory constructor for creating a new User instance
  /// from a map. Pass the map to the generated `_$UserFromJson()` constructor.
  /// The constructor is named after the source class, in this case, User.
  factory PaymentOrderModel.fromJson(Map<String, dynamic> json) =>
      _$PaymentOrderModelFromJson(json);

  // /// `toJson` is the convention for a class to declare support for serialization
  // /// to JSON. The implementation simply calls the private, generated
  // /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PaymentOrderModelToJson(this);
}
