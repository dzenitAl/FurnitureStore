import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:furniturestore_admin/utils/utils.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import '../models/search_result.dart';

abstract class BaseProvider<T> with ChangeNotifier {
  static String baseUrl = const String.fromEnvironment("baseUrl",
      defaultValue: "http://localhost:7015/api/");

  String _endpoint = "";
  BaseProvider(String endpoint) {
    _endpoint = endpoint;
  }

  Future<SearchResult<T>> get({dynamic filter}) async {
    var url = "$baseUrl$_endpoint";
    if (filter != null) {
      var queryString = getQueryString(filter);
      url = "$url?$queryString";
    }

    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.get(uri, headers: headers);
      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);

        var result = SearchResult<T>();

        result.count = data['count'];

        for (var item in data['result']) {
          result.result.add(fromJson(item));
        }

        return result;
      } else {
        throw Exception("Unknown error");
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception(
            "Network connection error. Please check your internet connection.");
      } else {
        rethrow;
      }
    }
  }

  Future<T> insert(dynamic request) async {
    var url = "$baseUrl$_endpoint";
    print("request  $request");
    print(url);
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var jsonRequest = jsonEncode(request);
      var response = await http.post(uri, headers: headers, body: jsonRequest);

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        return fromJson(data);
      } else {
        throw Exception("Unknown error");
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception(
            "Network connection error. Please check your internet connection.");
      } else {
        rethrow;
      }
    }
  }

  Future<T> update(int id, [dynamic request]) async {
    var url = "$baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var jsonRequest = jsonEncode(request);
      var response = await http.put(uri, headers: headers, body: jsonRequest);

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        return fromJson(data);
      } else {
        throw Exception("Unknown error");
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception(
            "Network connection error. Please check your internet connection.");
      } else {
        rethrow;
      }
    }
  }

  Future<void> delete(int id) async {
    var url = "$baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.delete(uri, headers: headers);

      if (!isValidResponse(response)) {
        throw Exception("Failed to delete item");
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception(
            "Network connection error. Please check your internet connection.");
      } else {
        rethrow;
      }
    }
  }

  Future<T> getById(int id) async {
    var url = "$baseUrl$_endpoint/$id";
    var uri = Uri.parse(url);
    var headers = createHeaders();

    try {
      var response = await http.get(uri, headers: headers);

      if (isValidResponse(response)) {
        var data = jsonDecode(response.body);
        return fromJson(data);
      } else {
        throw Exception("Unknown error");
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception(
            "Network connection error. Please check your internet connection.");
      } else {
        rethrow;
      }
    }
  }

  T fromJson(data) {
    throw Exception("Method not implemented");
  }

  bool isValidResponse(Response response) {
    print("response $response");
    if (response.statusCode < 299) {
      return true;
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized");
    } else if (response.statusCode == 404) {
      throw Exception("Requested resource not found");
    } else if (response.statusCode == 500) {
      throw Exception("Server error occurred. Please try again later");
    } else {
      try {
        var errorData = jsonDecode(response.body);
        if (errorData != null && errorData['message'] != null) {
          throw Exception(errorData['message']);
        }
      } catch (_) {
        // JSON parsing failed, just use status code
      }
      throw Exception("Error ${response.statusCode}: Something went wrong");
    }
  }

  Map<String, String> createHeaders() {
    String token = "Bearer ${Authorization.token}";
    var headers = {"Content-Type": "application/json", "Authorization": token};
    return headers;
  }

  String getQueryString(Map params,
      {String prefix = '&', bool inRecursion = false}) {
    String query = '';
    params.forEach((key, value) {
      if (inRecursion) {
        if (key is int) {
          key = '[$key]';
        } else if (value is List || value is Map) {
          key = '.$key';
        } else {
          key = '.$key';
        }
      }
      if (value is String || value is int || value is double || value is bool) {
        var encoded = value;
        if (value is String) {
          encoded = Uri.encodeComponent(value);
        }
        query += '$prefix$key=$encoded';
      } else if (value is DateTime) {
        query += '$prefix$key=${(value).toIso8601String()}';
      } else if (value is List || value is Map) {
        if (value is List) value = value.asMap();
        value.forEach((k, v) {
          query +=
              getQueryString({k: v}, prefix: '$prefix$key', inRecursion: true);
        });
      }
    });
    return query;
  }

  Map<String, String> createAuthorizationHeaders() {
    String token = "Bearer ${Authorization.token}";
    var headers = {
      "Content-Type": "application/json",
      "accept": " application/json",
      "Authorization": token
    };
    return headers;
  }
}
