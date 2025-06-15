import 'package:furniturestore_admin/models/decoration_item/decoration_item.dart';
import 'package:furniturestore_admin/providers/base_provider.dart';

class DecorationItemProvider extends BaseProvider<DecorationItemModel> {
  DecorationItemProvider() : super("DecorativeItem");

  @override
  DecorationItemModel fromJson(data) {
    return DecorationItemModel.fromJson(data);
  }
}
