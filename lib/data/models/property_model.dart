import 'package:equatable/equatable.dart';

class Property extends Equatable {
  final String propertyName;
  final int propertyStar;
  final String propertyImage;
  final String propertyCode;
  final String propertyType;
  final PropertyPolicies? policies;
  final PriceInfo markedPrice;
  final PriceInfo staticPrice;
  final GoogleReview? googleReview;
  final String propertyUrl;
  final PropertyAddress address;

  const Property({
    required this.propertyName,
    required this.propertyStar,
    required this.propertyImage,
    required this.propertyCode,
    required this.propertyType,
    this.policies,
    required this.markedPrice,
    required this.staticPrice,
    this.googleReview,
    required this.propertyUrl,
    required this.address,
  });

  factory Property.fromJson(Map<String, dynamic> json) {
    return Property(
      propertyName: json['propertyName']?.toString() ?? 'Unknown Property',
      propertyStar: json['propertyStar'] ?? 0,
      propertyImage: json['propertyImage']?.toString() ?? '',
      propertyCode: json['propertyCode']?.toString() ?? '',
      propertyType: json['propertyType']?.toString() ?? 'hotel',
      policies: json['propertyPoliciesAndAmmenities'] != null
          ? PropertyPolicies.fromJson(json['propertyPoliciesAndAmmenities'])
          : null,
      markedPrice: PriceInfo.fromJson(json['markedPrice'] ?? {}),
      staticPrice: PriceInfo.fromJson(json['staticPrice'] ?? {}),
      googleReview: json['googleReview'] != null
          ? GoogleReview.fromJson(json['googleReview'])
          : null,
      propertyUrl: json['propertyUrl']?.toString() ?? '',
      address: PropertyAddress.fromJson(json['propertyAddress'] ?? {}),
    );
  }

  @override
  List<Object?> get props => [
    propertyName, propertyStar, propertyImage, propertyCode, propertyType,
    policies, markedPrice, staticPrice, googleReview, propertyUrl, address
  ];
}

class PropertyPolicies extends Equatable {
  final bool present;
  final PolicyData? data;

  const PropertyPolicies({
    required this.present,
    this.data,
  });

  factory PropertyPolicies.fromJson(Map<String, dynamic> json) {
    return PropertyPolicies(
      present: json['present'] ?? false,
      data: json['data'] != null ? PolicyData.fromJson(json['data']) : null,
    );
  }

  @override
  List<Object?> get props => [present, data];
}

class PolicyData extends Equatable {
  final bool petsAllowed;
  final bool coupleFriendly;
  final bool suitableForChildren;
  final bool bachularsAllowed;
  final bool freeWifi;
  final bool freeCancellation;
  final bool payAtHotel;
  final bool payNow;

  const PolicyData({
    required this.petsAllowed,
    required this.coupleFriendly,
    required this.suitableForChildren,
    required this.bachularsAllowed,
    required this.freeWifi,
    required this.freeCancellation,
    required this.payAtHotel,
    required this.payNow,
  });

  factory PolicyData.fromJson(Map<String, dynamic> json) {
    return PolicyData(
      petsAllowed: json['petsAllowed'] ?? false,
      coupleFriendly: json['coupleFriendly'] ?? false,
      suitableForChildren: json['suitableForChildren'] ?? false,
      bachularsAllowed: json['bachularsAllowed'] ?? false,
      freeWifi: json['freeWifi'] ?? false,
      freeCancellation: json['freeCancellation'] ?? false,
      payAtHotel: json['payAtHotel'] ?? false,
      payNow: json['payNow'] ?? false,
    );
  }

  @override
  List<Object?> get props => [
    petsAllowed, coupleFriendly, suitableForChildren, bachularsAllowed,
    freeWifi, freeCancellation, payAtHotel, payNow
  ];
}

class PriceInfo extends Equatable {
  final double amount;
  final String displayAmount;
  final String currencySymbol;

  const PriceInfo({
    required this.amount,
    required this.displayAmount,
    required this.currencySymbol,
  });

  factory PriceInfo.fromJson(Map<String, dynamic> json) {
    return PriceInfo(
      amount: json['amount'] != null
          ? double.tryParse(json['amount'].toString()) ?? 0.0
          : 0.0,
      displayAmount: json['displayAmount']?.toString() ?? '',
      currencySymbol: json['currencySymbol']?.toString() ?? '₹',
    );
  }

  @override
  List<Object?> get props => [amount, displayAmount, currencySymbol];
}

class GoogleReview extends Equatable {
  final bool reviewPresent;
  final ReviewData? data;

  const GoogleReview({
    required this.reviewPresent,
    this.data,
  });

  factory GoogleReview.fromJson(Map<String, dynamic> json) {
    return GoogleReview(
      reviewPresent: json['reviewPresent'] ?? false,
      data: json['data'] != null ? ReviewData.fromJson(json['data']) : null,
    );
  }

  @override
  List<Object?> get props => [reviewPresent, data];
}

class ReviewData extends Equatable {
  final double overallRating;
  final int totalUserRating;

  const ReviewData({
    required this.overallRating,
    required this.totalUserRating,
  });

  factory ReviewData.fromJson(Map<String, dynamic> json) {
    return ReviewData(
      overallRating: json['overallRating'] != null
          ? double.tryParse(json['overallRating'].toString()) ?? 0.0
          : 0.0,
      totalUserRating: json['totalUserRating'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [overallRating, totalUserRating];
}

class PropertyAddress extends Equatable {
  final String street;
  final String city;
  final String state;
  final String country;
  final String zipcode;
  final double? latitude;
  final double? longitude;

  const PropertyAddress({
    required this.street,
    required this.city,
    required this.state,
    required this.country,
    required this.zipcode,
    this.latitude,
    this.longitude,
  });

  factory PropertyAddress.fromJson(Map<String, dynamic> json) {
    return PropertyAddress(
      street: json['street']?.toString() ?? '',
      city: json['city']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      country: json['country']?.toString() ?? '',
      zipcode: json['zipcode']?.toString() ?? '',
      latitude: json['latitude'] != null
          ? double.tryParse(json['latitude'].toString())
          : null,
      longitude: json['longitude'] != null
          ? double.tryParse(json['longitude'].toString())
          : null,
    );
  }

  @override
  List<Object?> get props => [street, city, state, country, zipcode, latitude, longitude];
}

class SearchProperty extends Equatable {
  final String propertyCode;
  final String propertyName;
  final PropertyImage propertyImage;
  final String propertytype;
  final int propertyStar;
  final PropertyPolicies? policies;
  final PropertyAddress address;
  final String propertyUrl;
  final String roomName;
  final int numberOfAdults;
  final PriceInfo markedPrice;
  final PriceInfo propertyMaxPrice;
  final PriceInfo propertyMinPrice;
  final GoogleReview? googleReview;
  final bool isFavorite;
  final SimplPriceList? simplPriceList;

  const SearchProperty({
    required this.propertyCode,
    required this.propertyName,
    required this.propertyImage,
    required this.propertytype,
    required this.propertyStar,
    this.policies,
    required this.address,
    required this.propertyUrl,
    required this.roomName,
    required this.numberOfAdults,
    required this.markedPrice,
    required this.propertyMaxPrice,
    required this.propertyMinPrice,
    this.googleReview,
    required this.isFavorite,
    this.simplPriceList,
  });

  factory SearchProperty.fromJson(Map<String, dynamic> json) {
    return SearchProperty(
      propertyCode: json['propertyCode']?.toString() ?? '',
      propertyName: json['propertyName']?.toString() ?? 'Unknown Property',
      propertyImage: PropertyImage.fromJson(json['propertyImage'] ?? {}),
      propertytype: json['propertytype']?.toString() ?? 'Hotel',
      propertyStar: json['propertyStar'] ?? 0,
      policies: json['propertyPoliciesAndAmmenities'] != null
          ? PropertyPolicies.fromJson(json['propertyPoliciesAndAmmenities'])
          : null,
      address: PropertyAddress.fromJson(json['propertyAddress'] ?? {}),
      propertyUrl: json['propertyUrl']?.toString() ?? '',
      roomName: json['roomName']?.toString() ?? '',
      numberOfAdults: json['numberOfAdults'] ?? 2,
      markedPrice: PriceInfo.fromJson(json['markedPrice'] ?? {}),
      propertyMaxPrice: PriceInfo.fromJson(json['propertyMaxPrice'] ?? {}),
      propertyMinPrice: PriceInfo.fromJson(json['propertyMinPrice'] ?? {}),
      googleReview: json['googleReview'] != null
          ? GoogleReview.fromJson(json['googleReview'])
          : null,
      isFavorite: json['isFavorite'] ?? false,
      simplPriceList: json['simplPriceList'] != null
          ? SimplPriceList.fromJson(json['simplPriceList'])
          : null,
    );
  }

  @override
  List<Object?> get props => [
    propertyCode, propertyName, propertyImage, propertytype, propertyStar,
    policies, address, propertyUrl, roomName, numberOfAdults, markedPrice,
    propertyMaxPrice, propertyMinPrice, googleReview, isFavorite, simplPriceList
  ];
}

class PropertyImage extends Equatable {
  final String fullUrl;
  final String location;
  final String imageName;

  const PropertyImage({
    required this.fullUrl,
    required this.location,
    required this.imageName,
  });

  factory PropertyImage.fromJson(Map<String, dynamic> json) {
    return PropertyImage(
      fullUrl: json['fullUrl']?.toString() ?? '',
      location: json['location']?.toString() ?? '',
      imageName: json['imageName']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [fullUrl, location, imageName];
}

class SimplPriceList extends Equatable {
  final PriceInfo simplPrice;
  final double originalPrice;

  const SimplPriceList({
    required this.simplPrice,
    required this.originalPrice,
  });

  factory SimplPriceList.fromJson(Map<String, dynamic> json) {
    return SimplPriceList(
      simplPrice: PriceInfo.fromJson(json['simplPrice'] ?? {}),
      originalPrice: json['originalPrice'] != null
          ? double.tryParse(json['originalPrice'].toString()) ?? 0.0
          : 0.0,
    );
  }

  @override
  List<Object?> get props => [simplPrice, originalPrice];
}