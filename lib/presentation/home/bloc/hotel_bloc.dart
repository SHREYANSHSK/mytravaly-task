import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/hotel_repository.dart';
import '../../../data/models/hotel_model.dart';
import 'hotel_event.dart';
import 'hotel_state.dart';

class HotelBloc extends Bloc<HotelEvent, HotelState> {
  final HotelRepository _repository;

  HotelBloc(this._repository) : super(HotelInitial()) {
    on<LoadSampleHotels>(_onLoadSampleHotels);
  }

  Future<void> _onLoadSampleHotels(
      LoadSampleHotels event,
      Emitter<HotelState> emit,
      ) async {
    emit(HotelLoading());

    // Sample hotels for display
    final sampleHotels = [
      const Hotel(
        id: '1',
        name: 'Grand Plaza Hotel',
        city: 'Mumbai',
        state: 'Maharashtra',
        country: 'India',
        rating: 4.5,
        imageUrl: 'https://images.unsplash.com/photo-1566073771259-6a8506099945?w=800',
      ),
      const Hotel(
        id: '2',
        name: 'Taj Palace',
        city: 'Delhi',
        state: 'Delhi',
        country: 'India',
        rating: 4.8,
        imageUrl: 'https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?w=800',
      ),
      const Hotel(
        id: '3',
        name: 'Beach Resort',
        city: 'Goa',
        state: 'Goa',
        country: 'India',
        rating: 4.3,
        imageUrl: 'https://images.unsplash.com/photo-1571896349842-33c89424de2d?w=800',
      ),
    ];

    emit(HotelLoaded(sampleHotels));
  }
}
