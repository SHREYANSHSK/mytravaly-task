import 'package:equatable/equatable.dart';
import '../../../data/models/hotel_model.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<Hotel> hotels;
  final bool hasMore;
  final int currentPage;
  final String query;

  const SearchLoaded({
    required this.hotels,
    required this.hasMore,
    required this.currentPage,
    required this.query,
  });

  @override
  List<Object?> get props => [hotels, hasMore, currentPage, query];
}

class SearchLoadingMore extends SearchState {
  final List<Hotel> hotels;
  final String query;

  const SearchLoadingMore({required this.hotels, required this.query});

  @override
  List<Object?> get props => [hotels, query];
}

class SearchError extends SearchState {
  final String message;

  const SearchError(this.message);

  @override
  List<Object?> get props => [message];
}
