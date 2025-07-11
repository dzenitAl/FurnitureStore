import 'dart:convert';
import 'package:furniturestore_mobile/models/account/account.dart';
import 'package:furniturestore_mobile/models/account/token_info.dart';
import 'package:furniturestore_mobile/models/city/city.dart';
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
      throw Exception("Unknown error");
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
      throw Exception("Unknown error");
    }
  }

  Future<void> updateProfile(String id, [dynamic request]) async {
    var url = "${BaseProvider.baseUrl}Account/update-profile/$id";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    var jsonRequest = jsonEncode(request);
    var response = await http.put(uri, headers: headers, body: jsonRequest);
    if (!isValidResponse(response)) {
      throw Exception("Unknown error");
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
      throw Exception("Unknown error");
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
      throw Exception("Unknown error");
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
      throw Exception("Unknown error");
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
      throw Exception("Unknown error");
    }
  }

  Future<List<CityModel>> fetchCities() async {
    try {
      final response = await http.get(
        Uri.parse('${BaseProvider.baseUrl}City'),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);

        if (jsonResponse.containsKey('result')) {
          final List<dynamic> cityList = jsonResponse['result'];
          return cityList.map((city) => CityModel.fromJson(city)).toList();
        } else {
          throw Exception('Unexpected response format: "result" key not found');
        }
      } else {
        throw Exception('Failed to load cities');
      }
    } catch (e) {
      throw Exception('Failed to load cities');
    }
  }

  Future<bool> changePassword(String currentPassword, String newPassword, String confirmNewPassword) async {
    var url = "${BaseProvider.baseUrl}Account/change-password";
    var uri = Uri.parse(url);
    var headers = createAuthorizationHeaders();
    
    var request = {
      'currentPassword': currentPassword,
      'newPassword': newPassword,
      'confirmNewPassword': confirmNewPassword
    };
    
    var jsonRequest = jsonEncode(request);
    var response = await http.post(uri, headers: headers, body: jsonRequest);
    
    if (isValidResponse(response)) {
      return true;
    } else {
      throw Exception("Failed to change password");
    }
  }
}
