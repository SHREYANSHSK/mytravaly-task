import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchHotels extends SearchEvent {
  final String query;
  final int page;

  const SearchHotels({required this.query, this.page = 1});

  @override
  List<Object?> get props => [query, page];
}

class LoadMoreResults extends SearchEvent {}
