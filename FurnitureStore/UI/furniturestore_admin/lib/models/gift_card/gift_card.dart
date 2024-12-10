import 'package:json_annotation/json_annotation.dart';

part 'gift_card.g.dart';

@JsonSerializable()
class GiftCardModel {
  int? id;
  String? name;
  String? cardNumber;
  int? amount;
  DateTime? expiryDate;
  bool? isActivated;

  GiftCardModel({
    this.id,
    this.name,
    this.cardNumber,
    this.amount,
    this.expiryDate,
    this.isActivated,
  });

  void updateActivationStatus() {
    if (expiryDate != null && expiryDate!.isBefore(DateTime.now())) {
      isActivated = false;
    }
  }

  factory GiftCardModel.fromJson(Map<String, dynamic> json) =>
      _$GiftCardModelFromJson(json);

  Map<String, dynamic> toJson() => _$GiftCardModelToJson(this);
}
