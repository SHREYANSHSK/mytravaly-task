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