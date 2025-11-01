import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/hotel_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HotelRepository _repository;

  SearchBloc(this._repository) : super(SearchInitial()) {
    on<SearchHotels>(_onSearchHotels);
  }

  Future<void> _onSearchHotels(
      SearchHotels event,
      Emitter<SearchState> emit,
      ) async {
    emit(SearchLoading());
    try {
      final response = await _repository.searchHotels(query: event.query);
      emit(SearchLoaded(
        properties: response.properties,
        query: event.query,
      ));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }
}
