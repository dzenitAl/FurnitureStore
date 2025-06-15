import 'package:furniturestore_mobile/models/decoration_item/decoration_item.dart';
import 'package:furniturestore_mobile/models/search_result.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DecorationItemProvider extends BaseProvider<DecorationItemModel> {
  DecorationItemProvider() : super("DecorativeItem");

  @override
  Future<SearchResult<DecorationItemModel>> get(String s,
      {dynamic filter}) async {
    var url = "${BaseProvider.baseUrl}DecorativeItem";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    print('Fetching decoration items from: $url');

    var response = await http.get(uri, headers: headers);
    print('API Response status: ${response.statusCode}');
    print('API Response body: ${response.body}');

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      var result = SearchResult<DecorationItemModel>();
      result.count = data['count'];
      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }
      return result;
    } else {
      throw Exception("Unknown error");
    }
  }

  @override
  DecorationItemModel fromJson(data) {
    print('Parsing decoration item: $data');
    return DecorationItemModel.fromJson(data);
  }

  Future<List<DecorationItemModel>> getItemsWithPictures(List<int> ids) async {
    var url = "${BaseProvider.baseUrl}DecorativeItem/with-pictures";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();

    var body = jsonEncode({"ids": ids});
    var response = await http.post(uri, headers: headers, body: body);

    if (isValidResponse(response)) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((json) => DecorationItemModel.fromJson(json)).toList();
    } else {
      throw Exception("Failed to fetch decoration items with pictures");
    }
  }
}
