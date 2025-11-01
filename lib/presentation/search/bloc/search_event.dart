import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchHotels extends SearchEvent {
  final String query;
  final String? checkIn;
  final String? checkOut;
  final int? rooms;
  final int? adults;
  final int? children;

  const SearchHotels({
    required this.query,
    this.checkIn,
    this.checkOut,
    this.rooms,
    this.adults,
    this.children,
  });

  @override
  List<Object?> get props => [query, checkIn, checkOut, rooms, adults, children];
}

class LoadMoreSearchResults extends SearchEvent {}