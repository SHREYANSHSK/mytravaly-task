import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mytravaly_task/core/constants/app_endpoints.dart';
import '../models/search_response_model.dart';
import '../models/search_suggestion_model.dart';
import 'device_service.dart';

class ApiService {
  final DeviceService _deviceService;
  final http.Client _client;

  ApiService(this._deviceService, {http.Client? client})
      : _client = client ?? http.Client();

  Map<String, String> get _headers => _deviceService.getHeaders();

  // Popular Stay API (replaces property list)
  Future<SearchResponse> getPopularStays({
    int limit = 10,
    String entityType = 'Any',
    String searchType = 'byCity',
    String country = 'India',
    String state = 'Jharkhand',
    String city = 'Jamshedpur',
    String currency = 'INR',
  }) async {
    try {
      final body = {
        'action': 'popularStay',
        'popularStay': {
          'limit': limit,
          'entityType': entityType,
          'filter': {
            'searchType': searchType,
            'searchTypeInfo': {
              'country': country,
              'state': state,
              'city': city,
            },
          },
          'currency': currency,
        },
      };

      final response = await _client.post(
        Uri.parse(ApiEndpoints.BASE_URL),
        headers: _headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return SearchResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to load popular stays: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching popular stays: $e');
    }
  }

  // Search Autocomplete API
  Future<List<SearchSuggestion>> getSearchSuggestions(String query) async {
    if (query.trim().isEmpty) return [];

    try {
      final uri = Uri.parse(ApiEndpoints.BASE_URL)
          .replace(queryParameters: {
        'query': query,
        'limit': '10',
      });

      final response = await _client.post(uri, headers: _headers);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final suggestions = jsonData['data'] ?? jsonData['suggestions'] ?? [];

        return (suggestions as List)
            .map((item) => SearchSuggestion.fromJson(item))
            .toList();
      } else {
        print('Autocomplete failed: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      print('Error fetching suggestions: $e');
      return [];
    }
  }

  // Get Search Results API
  Future<SearchResponse> getSearchResults({
    required String query,
    String? checkIn,
    String? checkOut,
    int? guests,
    String currency = 'INR',
  }) async {
    try {
      final body = {
        'action': 'search',
        'search': {
          'query': query,
          'checkIn': checkIn,
          'checkOut': checkOut,
          'guests': guests,
          'currency': currency,
        },
      };

      final response = await _client.post(
        Uri.parse(ApiEndpoints.BASE_URL),
        headers: _headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return SearchResponse.fromJson(jsonData);
      } else {
        throw Exception('Failed to search: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching: $e');
    }
  }

  void dispose() {
    _client.close();
  }
}