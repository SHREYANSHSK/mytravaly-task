import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/hotel_repository.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final HotelRepository _repository;

  SearchBloc(this._repository) : super(SearchInitial()) {
    on<SearchHotels>(_onSearchHotels);
    on<LoadMoreSearchResults>(_onLoadMoreSearchResults);
  }

  Future<void> _onSearchHotels(
      SearchHotels event,
      Emitter<SearchState> emit,
      ) async {
    print('=== Searching Hotels ===');
    print('Query: ${event.query}');

    emit(SearchLoading());

    try {
      final response = await _repository.searchHotels(
        query: event.query,
        checkIn: event.checkIn ?? '2026-07-11',
        checkOut: event.checkOut ?? '2026-07-12',
        rooms: event.rooms ?? 1,
        adults: event.adults ?? 2,
        children: event.children ?? 0,
        limit: 5,
      );

      print('Search response: ${response.properties.length} properties');
      print('Has more: ${response.hasMore}');
      print('Excluded hotels: ${response.excludedHotels}');

      emit(SearchLoaded(
        properties: response.properties,
        query: event.query,
        hasMore: response.hasMore,
        excludedHotels: response.excludedHotels,
      ));
    } catch (e) {
      print('Search error: $e');
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onLoadMoreSearchResults(
      LoadMoreSearchResults event,
      Emitter<SearchState> emit,
      ) async {
    final currentState = state;

    if (currentState is! SearchLoaded || !currentState.hasMore) {
      return;
    }

    print('=== Loading More Results ===');
    print('Current properties: ${currentState.properties.length}');
    print('Excluded hotels: ${currentState.excludedHotels}');

    emit(SearchLoadingMore(
      properties: currentState.properties,
      query: currentState.query,
    ));

    try {
      final response = await _repository.searchHotels(
        query: currentState.query,
        limit: 5,
        excludedHotels: currentState.excludedHotels,
      );

      print('Loaded ${response.properties.length} more properties');

      // Combine old and new properties
      final allProperties = [
        ...currentState.properties,
        ...response.properties,
      ];

      // Combine excluded hotels
      final allExcluded = <String>{
        ...currentState.excludedHotels,
        ...response.excludedHotels,
      }.toList(); // Remove duplicates

      emit(SearchLoaded(
        properties: allProperties,
        query: currentState.query,
        hasMore: response.hasMore,
        excludedHotels: allExcluded,
      ));
    } catch (e) {
      print('Load more error: $e');
      emit(SearchError(e.toString()));
    }
  }
}