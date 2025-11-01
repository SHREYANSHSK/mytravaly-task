import 'package:equatable/equatable.dart';
import 'property_model.dart';

class SearchResponse extends Equatable {
  final List<Property> properties;
  final int totalCount;
  final bool status;

  const SearchResponse({
    required this.properties,
    required this.totalCount,
    required this.status,
  });

  factory SearchResponse.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] ?? [];

    return SearchResponse(
      properties: dataList.map((item) => Property.fromJson(item)).toList(),
      totalCount: dataList.length,
      status: json['status'] ?? false,
    );
  }

  @override
  List<Object?> get props => [properties, totalCount, status];
}

class SearchResultResponse extends Equatable {
  final List<SearchProperty> properties;
  final List<String> excludedHotels;
  final List<String> excludedSearchTypes;
  final bool status;
  final String message;
  final bool hasMore;

  const SearchResultResponse({
    required this.properties,
    required this.excludedHotels,
    required this.excludedSearchTypes,
    required this.status,
    required this.message,
    required this.hasMore,
  });

  factory SearchResultResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] ?? {};
    final List<dynamic> hotelList = data['arrayOfHotelList'] ?? [];
    final List<dynamic> excluded = data['arrayOfExcludedHotels'] ?? [];
    final List<dynamic> excludedTypes = data['arrayOfExcludedSearchType'] ?? [];

    return SearchResultResponse(
      properties: hotelList.map((item) => SearchProperty.fromJson(item)).toList(),
      excludedHotels: excluded.map((e) => e.toString()).toList(),
      excludedSearchTypes: excludedTypes.map((e) => e.toString()).toList(),
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      hasMore: hotelList.length >= 5, // If we got 5 results, there might be more
    );
  }

  @override
  List<Object?> get props => [
    properties, excludedHotels, excludedSearchTypes, status, message, hasMore
  ];
}
