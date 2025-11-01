import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:mytravaly_task/core/constants/app_endpoints.dart';
import '../../core/utils/app_logger.dart';
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
    String state = 'Jaipur',
    String city = 'Rajasthan',
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
      final body = {
        'action': 'searchAutoComplete',
        'searchAutoComplete': {
          'inputText': query,
          'searchType': [
            'byCity',
            'byState',
            'byCountry',
            'byPropertyName'
          ],
          'limit': 10,
        },
      };

      Log.highlight('Autocomplete API Request: ${json.encode(body)}');

      final response = await _client.post(
        Uri.parse(ApiEndpoints.BASE_URL),
        headers: _headers,
        body: json.encode(body),
      );

      Log.info('Autocomplete Response Status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        Log.highlight('Autocomplete Response: $jsonData');

        final autocompleteResponse = AutocompleteResponse.fromJson(jsonData);

        if (autocompleteResponse.data?.autoCompleteList != null) {
          final suggestions = autocompleteResponse.data!.autoCompleteList!.getAllSuggestions();
          Log.info('Total suggestions: ${suggestions.length}');
          return suggestions;
        }

        return [];
      } else {
        Log.error('Autocomplete failed: ${response.statusCode}');
        return [];
      }
    } catch (e,stacktrace) {
      Log.error('Error fetching autocomplete suggestions',[e,stacktrace]);
      return [];
    }
  }


  // Get Search Results API
  Future<SearchResultResponse> getSearchResults({
    required String searchQuery,
    String searchType = 'hotelIdSearch',
    String checkIn = '2026-07-11',
    String checkOut = '2026-07-12',
    int rooms = 2,
    int adults = 2,
    int children = 0,
    List<String> accommodation = const ['all'],
    List<String> excludedSearchTypes = const ['street'],
    String highPrice = '3000000',
    String lowPrice = '0',
    int limit = 5,
    List<String> preloaderList = const [],
    String currency = 'INR',
    int rid = 0
  }) async {
    try {
      List<String> queryList;

      if (searchQuery.trim().startsWith('[')) {
        queryList = List<String>.from(json.decode(searchQuery));
      } else {
        queryList = [searchQuery];
      }
      final body = {
        "action": "getSearchResultListOfHotels",
        "getSearchResultListOfHotels": {
          "searchCriteria": {
            "checkIn": checkIn,
            "checkOut": checkOut,
            "rooms": rooms,
            "adults": adults,
            "children": children,
            "searchType": searchType,
            "searchQuery": queryList,
            "accommodation": accommodation,
            "arrayOfExcludedSearchType": excludedSearchTypes,
            "highPrice": highPrice,
            "lowPrice": lowPrice,
            "limit": limit,
            "preloaderList": preloaderList,
            "currency": currency,
            "rid": rid
          },
        },
      };

      Log.highlight('Search API Request Body: ${json.encode(body)}');

      final response = await _client.post(
        Uri.parse(ApiEndpoints.BASE_URL),
        headers: _headers,
        body: json.encode(body),
      );

      Log.info('Search API Response Status: ${response.statusCode}');
      Log.highlight('Search API Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return SearchResultResponse.fromJson(jsonData);
      } else {
        final data = SearchResultResponse.fromJson(json.decode(response.body));
        throw Exception(data.message);
      }
    } catch (e,stacktrace) {
      Log.error('Error searching properties',[e,stacktrace]);
      throw Exception(e);
    }
  }

  void dispose() {
    _client.close();
  }
}