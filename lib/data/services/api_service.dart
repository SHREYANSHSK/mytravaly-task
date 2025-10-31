import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:mytravaly_task/core/constants/app_constants.dart';
import 'package:mytravaly_task/routes/app_routes_name.dart';
import '../models/search_response_model.dart';

class ApiService {
  final http.Client _client;

  ApiService({http.Client? client}) : _client = client ?? http.Client();

  Map<String, String> get _headers => {
    'Authorization': 'Bearer ${AppConstants.authToken}',
    'Content-Type': 'application/json',
  };

  Future<SearchResponse> searchHotels({
    required String query,
    int page = 1,
    int perPage = 20,
  }) async {
    try {
      final uri = Uri.parse('${dotenv.get("BASE_URL")}${ApiConstants.searchEndpoint}')
          .replace(queryParameters: {
        'query': query,
        'page': page.toString(),
        'per_page': perPage.toString(),
      });

      final response = await _client.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return SearchResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load hotels: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching hotels: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}
