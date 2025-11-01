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
    String state = 'Rajasthan',
    String city = 'Jaipur',
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

  Future<SearchResultResponse> searchHotels({
    required String query,
    String searchType = 'hotelIdSearch',
    String checkIn = '2026-07-11',
    String checkOut = '2026-07-12',
    int rooms = 2,
    int adults = 2,
    int children = 0,
    int limit = 5,
    List<String> excludedHotels = const [],
  }) async {
    return await _apiService.getSearchResults(
      searchQuery: query,
      searchType: searchType,
      checkIn: checkIn,
      checkOut: checkOut,
      rooms: rooms,
      adults: adults,
      children: children,
      limit: limit,
      preloaderList: excludedHotels,
    );
  }
}