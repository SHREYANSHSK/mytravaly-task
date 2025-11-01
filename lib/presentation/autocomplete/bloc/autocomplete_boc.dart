import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/hotel_repository.dart';
import 'autocomplete_event.dart';
import 'autocomplete_state.dart';

class AutocompleteBloc extends Bloc<AutocompleteEvent, AutocompleteState> {
  final HotelRepository _repository;

  AutocompleteBloc(this._repository) : super(AutocompleteInitial()) {
    on<SearchQueryChanged>(_onSearchQueryChanged);
    on<ClearSuggestions>(_onClearSuggestions);
  }

  Future<void> _onSearchQueryChanged(
      SearchQueryChanged event,
      Emitter<AutocompleteState> emit,
      ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(AutocompleteInitial());
      return;
    }

    if (query.length < 2) {
      return;
    }

    emit(AutocompleteLoading());

    try {
      final suggestions = await _repository.getSearchSuggestions(query);
      emit(AutocompleteLoaded(suggestions));
    } catch (e) {
      emit(AutocompleteError(e.toString()));
    }
  }

  void _onClearSuggestions(
      ClearSuggestions event,
      Emitter<AutocompleteState> emit,
      ) {
    emit(AutocompleteInitial());
  }
}
