import 'package:equatable/equatable.dart';

class Hotel extends Equatable {
  final String id;
  final String name;
  final String city;
  final String state;
  final String country;
  final String? imageUrl;
  final String? description;
  final double? rating;
  final String? address;
  final double? price;
  final String? currency;

  const Hotel({
    required this.id,
    required this.name,
    required this.city,
    required this.state,
    required this.country,
    this.imageUrl,
    this.description,
    this.rating,
    this.address,
    this.price,
    this.currency,
  });

  factory Hotel.fromJson(Map<String, dynamic> json) {
    return Hotel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Unknown Hotel',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      imageUrl: json['image_url']?.toString() ?? json['image']?.toString(),
      description: json['description']?.toString(),
      rating: json['rating'] != null ? double.tryParse(json['rating'].toString()) : null,
      address: json['address']?.toString(),
      price: json['price'] != null ? double.tryParse(json['price'].toString()) : null,
      currency: json['currency']?.toString() ?? 'USD',
    );
  }

  @override
  List<Object?> get props => [id, name, city, state, country, imageUrl, description, rating, address, price, currency];
}