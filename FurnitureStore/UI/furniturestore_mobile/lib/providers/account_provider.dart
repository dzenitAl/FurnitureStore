import 'dart:convert';
import 'package:furniturestore_mobile/models/account/account.dart';
import 'package:furniturestore_mobile/models/account/token_info.dart';
import 'package:furniturestore_mobile/models/search_result.dart';
import 'package:furniturestore_mobile/providers/base_provider.dart';
import 'package:furniturestore_mobile/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

class AccountProvider extends BaseProvider<AccountModel> {
  AccountProvider() : super("Account");

  @override
  AccountModel fromJson(data) {
    return AccountModel.fromJson(data);
  }

  Future<dynamic> login(dynamic body) async {
    var url = "${BaseProvider.baseUrl}Account/authenticate";
    print(url);
    var uri = Uri.parse(url);
    var jsonRequest = jsonEncode(body);
    var headers = createHeaders();
    var response = await http.post(
      uri,
      headers: headers,
      body: jsonRequest,
    );
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return data;
    } else {
      throw new Exception("Unknown error");
    }
  }

  TokenInfoModel getCurrentUser() {
    Map<String, dynamic> decodedToken = JwtDecoder.decode(Authorization.token!);
    return TokenInfoModel.fromJson(decodedToken);
  }

  Future<AccountModel> userProfile(String id) async {
    var url = "${BaseProvider.baseUrl}Account/user-profile/$id";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return AccountModel.fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<void> updateProfile(String id, [dynamic request]) async {
    var url = "${BaseProvider.baseUrl}Account/update-profile/$id";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);
    if (!isValidResponse(response)) {
      throw new Exception("Unknown error");
    }
  }

  Future<AccountModel> updateUser(String id, [dynamic request]) async {
    var url = "${BaseProvider.baseUrl}Account/update-user/$id";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();

    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return AccountModel.fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<AccountModel> register(dynamic request) async {
    var url = "${BaseProvider.baseUrl}Account/register";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return AccountModel.fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<SearchResult<AccountModel>> getAll({dynamic filter}) async {
    var url = "${BaseProvider.baseUrl}Account";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    var response = await http.get(uri, headers: headers);
    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);

      var result = SearchResult<AccountModel>();

      result.count = data['count'];

      for (var item in data['result']) {
        result.result.add(fromJson(item));
      }

      return result;
    } else {
      throw new Exception("Unknown error");
    }
  }

  Future<AccountModel> getUserById(String id) async {
    var url = "${BaseProvider.baseUrl}Account/$id";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();

    var response = await http.get(uri, headers: headers);

    if (isValidResponse(response)) {
      var data = jsonDecode(response.body);
      return AccountModel.fromJson(data);
    } else {
      throw new Exception("Unknown error");
    }
  }
}
