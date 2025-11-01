import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchHotels extends SearchEvent {
  final String query;

  const SearchHotels({required this.query});

  @override
  List<Object?> get props => [query];
}
