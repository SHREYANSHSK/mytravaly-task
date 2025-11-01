import 'package:equatable/equatable.dart';
import '../../../data/models/search_suggestion_model.dart';

abstract class AutocompleteState extends Equatable {
  const AutocompleteState();

  @override
  List<Object?> get props => [];
}

class AutocompleteInitial extends AutocompleteState {}

class AutocompleteLoading extends AutocompleteState {}

class AutocompleteLoaded extends AutocompleteState {
  final List<SearchSuggestion> suggestions;

  const AutocompleteLoaded(this.suggestions);

  @override
  List<Object?> get props => [suggestions];
}

class AutocompleteError extends AutocompleteState {
  final String message;

  const AutocompleteError(this.message);

  @override
  List<Object?> get props => [message];
}