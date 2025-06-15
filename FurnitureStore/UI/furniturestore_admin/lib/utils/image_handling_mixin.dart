import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';

mixin ImageHandlingMixin {
  String get baseUrl => 'http://localhost:7015';

  Future<void> uploadImage(
      String entityType, int entityId, File imageFile, String token) async {
    // Determine if this is a new image or an update
    final isUpdate = await checkIfImageExists(entityType, entityId, token);

    final endpoint = isUpdate ? 'updateImage' : 'addImage';
    final method = isUpdate ? 'PUT' : 'POST';

    final uri = Uri.parse('$baseUrl/api/$entityType/$endpoint/$entityId');
    var imageRequest = http.MultipartRequest(method, uri);

    imageRequest.headers['Authorization'] = 'Bearer $token';

    print("Uploading image from path: ${imageFile.path}");
    print("Request URL: $uri");
    print("Request method: $method");
    print("Request headers: ${imageRequest.headers}");

    imageRequest.files.add(
      await http.MultipartFile.fromPath('file', imageFile.path),
    );

    var streamedResponse = await imageRequest.send();
    var response = await http.Response.fromStream(streamedResponse);

    print("Upload response status: ${response.statusCode}");
    print("Upload response body: ${response.body}");

    if (response.statusCode != 200) {
      throw Exception(
          "Failed to upload image: ${response.statusCode} - ${response.body}");
    }
  }

  Future<bool> checkIfImageExists(
      String entityType, int entityId, String token) async {
    final uri = Uri.parse('$baseUrl/api/$entityType/$entityId');
    final response = await http.get(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data['imagePath'] != null;
    }
    return false;
  }

  Future<bool> deleteImage(
      String entityType, int entityId, String token) async {
    final uri = Uri.parse('$baseUrl/api/$entityType/deleteImage/$entityId');
    var response = await http.delete(
      uri,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) {
      throw Exception(
          "Failed to delete image: ${response.statusCode} - ${response.body}");
    }

    return true;
  }
}
