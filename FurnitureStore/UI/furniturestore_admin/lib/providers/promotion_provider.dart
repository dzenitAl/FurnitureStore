import 'package:furniturestore_admin/models/promotion/promotion.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';

class PromotionProvider extends BaseProvider<PromotionModel> {
  PromotionProvider() : super("Promotion");

  @override
  PromotionModel fromJson(data) {
    return PromotionModel.fromJson(data);
  }
}
