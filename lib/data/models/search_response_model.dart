import 'package:equatable/equatable.dart';
import 'hotel_model.dart';

class SearchResponse extends Equatable {
  final List<Hotel> hotels;
  final int totalCount;
  final int currentPage;
  final int totalPages;
  final bool hasMore;

  const SearchResponse({
    required this.hotels,
    required this.totalCount,
    required this.currentPage,
    required this.totalPages,
    required this.hasMore,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? json;
    final List<dynamic> hotelsJson = data['hotels'] ?? data['results'] ?? [];

    return SearchResponse(
      hotels: hotelsJson.map((hotel) => Hotel.fromJson(hotel)).toList(),
      totalCount: data['total_count'] ?? data['total'] ?? hotelsJson.length,
      currentPage: data['current_page'] ?? data['page'] ?? 1,
      totalPages: data['total_pages'] ?? data['pages'] ?? 1,
      hasMore: data['has_more'] ?? false,
    );
  }

  @override
  List<Object?> get props => [hotels, totalCount, currentPage, totalPages, hasMore];
}
