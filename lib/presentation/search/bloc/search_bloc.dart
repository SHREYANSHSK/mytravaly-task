import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/hotel_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HotelRepository _repository;

  SearchBloc(this._repository) : super(SearchInitial()) {
    on<SearchHotels>(_onSearchHotels);
    on<LoadMoreResults>(_onLoadMoreResults);
  }

  Future<void> _onSearchHotels(
      SearchHotels event,
      Emitter<SearchState> emit,
      ) async {
    emit(SearchLoading());
    try {
      final response = await _repository.searchHotels(
        query: event.query,
        page: event.page,
      );
      emit(SearchLoaded(
        hotels: response.hotels,
        hasMore: response.hasMore,
        currentPage: response.currentPage,
        query: event.query,
      ));
    } catch (e) {
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onLoadMoreResults(
      LoadMoreResults event,
      Emitter<SearchState> emit,
      ) async {
    final currentState = state;
    if (currentState is SearchLoaded && currentState.hasMore) {
      emit(SearchLoadingMore(hotels: currentState.hotels, query: currentState.query));

      try {
        final response = await _repository.searchHotels(
          query: currentState.query,
          page: currentState.currentPage + 1,
        );

        emit(SearchLoaded(
          hotels: [...currentState.hotels, ...response.hotels],
          hasMore: response.hasMore,
          currentPage: response.currentPage,
          query: currentState.query,
        ));
      } catch (e) {
        emit(SearchError(e.toString()));
      }
    }
  }
}
