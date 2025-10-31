import '../models/search_response_model.dart';
import '../services/api_service.dart';

class HotelRepository {
  final ApiService _apiService;

  HotelRepository(this._apiService);

  Future<SearchResponse> searchHotels({
    required String query,
    int page = 1,
    int perPage = 20,
  }) async {
    return await _apiService.searchHotels(
      query: query,
      page: page,
      perPage: perPage,
    );
  }
}
