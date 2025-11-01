import 'package:equatable/equatable.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();

  @override
  List<Object?> get props => [];
}

class LoadPopularStays extends HomeEvent {
  final String city;
  final String state;
  final String country;

  const LoadPopularStays({
    this.city = 'jaipur',
    this.state = 'rajasthan',
    this.country = 'India',
  });

  @override
  List<Object?> get props => [city, state, country];
}

class RefreshPopularStays extends HomeEvent {}