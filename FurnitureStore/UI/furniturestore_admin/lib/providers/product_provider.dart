import 'dart:convert' as convert;
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class ProductProvider with ChangeNotifier {
  static String? _baseUrl;
  String _endpoint = "Products";

  ProductProvider() {
    _baseUrl = const String.fromEnvironment("baseUrl",
        defaultValue: "https://localhost:7015/api/");
  }

  Future<dynamic> get() async {
    var url = "$_baseUrl$_endpoint";
    var uri = Uri.parse(url);

    var headers = createHeaders();
    var response = await http.get(uri, headers: headers);
    var data = jsonDecode(response.body);
    return data;
  }

  Map<String, String> createHeaders() {
    String username = "admin";
    String password = "test123";

    String basicAuth =
        "Basic ${base64Encode(utf8.encode('$username:$password'))}";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    return headers;
  }
}
