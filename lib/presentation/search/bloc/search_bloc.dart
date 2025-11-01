import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_logger.dart';
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
    Log.debug('=== Searching Hotels ===*/===');
    Log.info('Query: ${event.query}');
    Log.info('Search Type: ${event.searchType}');

    emit(SearchLoading());

    try {
      final response = await _repository.searchHotels(
        query: event.query,
        searchType: event.searchType,
        checkIn: event.checkIn ?? '2026-07-11',
        checkOut: event.checkOut ?? '2026-07-12',
        rooms: event.rooms ?? 1,
        adults: event.adults ?? 2,
        children: event.children ?? 0,
        limit: 5,
      );

      Log.info('Search response: ${response.properties.length} properties');
      Log.info('Has more: ${response.hasMore}');
      Log.info('Excluded hotels: ${response.excludedHotels}');

      emit(SearchLoaded(
        properties: response.properties,
        query: event.query,
        searchType: event.searchType,
        hasMore: response.hasMore,
        excludedHotels: response.excludedHotels,
      ));
    } catch (e,stacktrace) {
      Log.error('Search error',[e,stacktrace]);
      emit(SearchError(e.toString()));
    }
  }

  Future<void> _onLoadMoreSearchResults(
      LoadMoreSearchResults event,
      Emitter<SearchState> emit,
      ) async {
    final currentState = state;

    if (currentState is! SearchLoaded || !currentState.hasMore) {
      Log.debug('Cannot load more: hasMore = ${currentState is SearchLoaded ? currentState.hasMore : false}');
      return;
    }

    Log.debug('=== Loading More Results ===');
    Log.info('Current properties: ${currentState.properties.length}');
    Log.info('Excluded hotels: ${currentState.excludedHotels}');
    Log.info('Search type: ${currentState.searchType}');

    emit(SearchLoadingMore(
      properties: currentState.properties,
      query: currentState.query,
    ));

    try {
      final response = await _repository.searchHotels(
        query: currentState.query,
        searchType: currentState.searchType,
        limit: 5,
        excludedHotels: currentState.excludedHotels,
      );

      Log.info('Loaded ${response.properties.length} more properties');

      final allProperties = [
        ...currentState.properties,
        ...response.properties,
      ];

      final allExcluded = <String>{
        ...currentState.excludedHotels,
        ...response.excludedHotels,
      }.toList();

      Log.info('Total properties now: ${allProperties.length}');
      Log.info('Total excluded: ${allExcluded.length}');

      emit(SearchLoaded(
        properties: allProperties,
        query: currentState.query,
        searchType: currentState.searchType,
        hasMore: response.hasMore,
        excludedHotels: allExcluded,
      ));
    } catch (e, stackTrace) {
      Log.error('Load more error',[e,stackTrace]);
      emit(SearchError(e.toString()));
    }
  }
}