import 'package:equatable/equatable.dart';

abstract class AutocompleteEvent extends Equatable {
  const AutocompleteEvent();

  @override
  List<Object?> get props => [];
}

class SearchQueryChanged extends AutocompleteEvent {
  final String query;

  const SearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearSuggestions extends AutocompleteEvent {}