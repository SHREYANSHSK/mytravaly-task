import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/hotel_repository.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final HotelRepository _repository;

  HomeBloc(this._repository) : super(HomeInitial()) {
    on<LoadPopularStays>(_onLoadPopularStays);
    on<RefreshPopularStays>(_onRefreshPopularStays);
  }

  Future<void> _onLoadPopularStays(
      LoadPopularStays event,
      Emitter<HomeState> emit,
      ) async {
    emit(HomeLoading());

    try {
      final response = await _repository.getPopularStays(
        city: event.city,
        state: event.state,
        country: event.country,
      );

      emit(HomeLoaded(response.properties));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }

  Future<void> _onRefreshPopularStays(
      RefreshPopularStays event,
      Emitter<HomeState> emit,
      ) async {
    final currentState = state;

    try {
      final response = await _repository.getPopularStays();
      emit(HomeLoaded(response.properties));
    } catch (e) {
      if (currentState is HomeLoaded) {
        emit(currentState);
      } else {
        emit(HomeError(e.toString()));
      }
    }
  }
}
