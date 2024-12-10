import 'package:furniturestore_mobile/models/gift_card/gift_card.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';

class GiftCardProvider extends BaseProvider<GiftCardModel> {
  GiftCardProvider() : super("GiftCard");

  @override
  GiftCardModel fromJson(data) {
    return GiftCardModel.fromJson(data);
  }
}
