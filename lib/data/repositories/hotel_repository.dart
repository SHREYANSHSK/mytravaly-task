import '../models/search_response_model.dart';
import '../models/search_suggestion_model.dart';
import '../services/api_service.dart';

class HotelRepository {
  final ApiService _apiService;

  HotelRepository(this._apiService);

  Future<List<SearchSuggestion>> getSearchSuggestions(String query) async {
    return await _apiService.getSearchSuggestions(query);
  }

  Future<SearchResponse> getPopularStays({
    int limit = 10,
    String entityType = 'Any',
    String searchType = 'byCity',
    String country = 'India',
    String state = 'Jharkhand',
    String city = 'Jamshedpur',
  }) async {
    return await _apiService.getPopularStays(
      limit: limit,
      entityType: entityType,
      searchType: searchType,
      country: country,
      state: state,
      city: city,
    );
  }

  Future<SearchResponse> searchHotels({
    required String query,
    String? checkIn,
    String? checkOut,
    int? guests,
  }) async {
    return await _apiService.getSearchResults(
      query: query,
      checkIn: checkIn,
      checkOut: checkOut,
      guests: guests,
    );
  }
}