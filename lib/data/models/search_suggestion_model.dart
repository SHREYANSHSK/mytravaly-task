import 'package:equatable/equatable.dart';

class SearchSuggestion extends Equatable {
  final String id;
  final String text;
  final String type;
  final String? subtitle;

  const SearchSuggestion({
    required this.id,
    required this.text,
    required this.type,
    this.subtitle,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      id: json['id']?.toString() ?? '',
      text: json['text']?.toString() ?? json['name']?.toString() ?? '',
      type: json['type']?.toString() ?? 'hotel',
      subtitle: json['subtitle']?.toString() ?? json['location']?.toString(),
    );
  }

  @override
  List<Object?> get props => [id, text, type, subtitle];
}