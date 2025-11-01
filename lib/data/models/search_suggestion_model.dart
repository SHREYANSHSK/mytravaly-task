import 'package:equatable/equatable.dart';

class AutocompleteResponse extends Equatable {
  final bool status;
  final String message;
  final int responseCode;
  final AutocompleteData? data;

  const AutocompleteResponse({
    required this.status,
    required this.message,
    required this.responseCode,
    this.data,
  });

  factory AutocompleteResponse.fromJson(Map<String, dynamic> json) {
    return AutocompleteResponse(
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      responseCode: json['responseCode'] ?? 0,
      data: json['data'] != null
          ? AutocompleteData.fromJson(json['data'])
          : null,
    );
  }

  @override
  List<Object?> get props => [status, message, responseCode, data];
}

class AutocompleteData extends Equatable {
  final bool present;
  final int totalNumberOfResult;
  final AutocompleteList? autoCompleteList;

  const AutocompleteData({
    required this.present,
    required this.totalNumberOfResult,
    this.autoCompleteList,
  });

  factory AutocompleteData.fromJson(Map<String, dynamic> json) {
    return AutocompleteData(
      present: json['present'] ?? false,
      totalNumberOfResult: json['totalNumberOfResult'] ?? 0,
      autoCompleteList: json['autoCompleteList'] != null
          ? AutocompleteList.fromJson(json['autoCompleteList'])
          : null,
    );
  }

  @override
  List<Object?> get props => [present, totalNumberOfResult, autoCompleteList];
}

class AutocompleteList extends Equatable {
  final AutocompleteCategory? byPropertyName;
  final AutocompleteCategory? byStreet;
  final AutocompleteCategory? byCity;
  final AutocompleteCategory? byState;
  final AutocompleteCategory? byCountry;

  const AutocompleteList({
    this.byPropertyName,
    this.byStreet,
    this.byCity,
    this.byState,
    this.byCountry,
  });

  factory AutocompleteList.fromJson(Map<String, dynamic> json) {
    return AutocompleteList(
      byPropertyName: json['byPropertyName'] != null
          ? AutocompleteCategory.fromJson(json['byPropertyName'])
          : null,
      byStreet: json['byStreet'] != null
          ? AutocompleteCategory.fromJson(json['byStreet'])
          : null,
      byCity: json['byCity'] != null
          ? AutocompleteCategory.fromJson(json['byCity'])
          : null,
      byState: json['byState'] != null
          ? AutocompleteCategory.fromJson(json['byState'])
          : null,
      byCountry: json['byCountry'] != null
          ? AutocompleteCategory.fromJson(json['byCountry'])
          : null,
    );
  }

  List<SearchSuggestion> getAllSuggestions() {
    final suggestions = <SearchSuggestion>[];

    if (byPropertyName?.present == true) {
      suggestions.addAll(byPropertyName!.listOfResult);
    }
    if (byCity?.present == true) {
      suggestions.addAll(byCity!.listOfResult);
    }
    if (byState?.present == true) {
      suggestions.addAll(byState!.listOfResult);
    }
    if (byCountry?.present == true) {
      suggestions.addAll(byCountry!.listOfResult);
    }
    if (byStreet?.present == true) {
      suggestions.addAll(byStreet!.listOfResult);
    }

    return suggestions;
  }

  @override
  List<Object?> get props => [byPropertyName, byStreet, byCity, byState, byCountry];
}

class AutocompleteCategory extends Equatable {
  final bool present;
  final List<SearchSuggestion> listOfResult;
  final int numberOfResult;

  const AutocompleteCategory({
    required this.present,
    required this.listOfResult,
    required this.numberOfResult,
  });

  factory AutocompleteCategory.fromJson(Map<String, dynamic> json) {
    final List<dynamic> results = json['listOfResult'] ?? [];

    return AutocompleteCategory(
      present: json['present'] ?? false,
      listOfResult: results
          .map((item) => SearchSuggestion.fromJson(item))
          .toList(),
      numberOfResult: json['numberOfResult'] ?? 0,
    );
  }

  @override
  List<Object?> get props => [present, listOfResult, numberOfResult];
}

class SearchSuggestion extends Equatable {
  final String valueToDisplay;
  final String? propertyName;
  final SuggestionAddress address;
  final SearchArray searchArray;

  const SearchSuggestion({
    required this.valueToDisplay,
    this.propertyName,
    required this.address,
    required this.searchArray,
  });

  factory SearchSuggestion.fromJson(Map<String, dynamic> json) {
    return SearchSuggestion(
      valueToDisplay: json['valueToDisplay']?.toString() ?? '',
      propertyName: json['propertyName']?.toString(),
      address: SuggestionAddress.fromJson(json['address'] ?? {}),
      searchArray: SearchArray.fromJson(json['searchArray'] ?? {}),
    );
  }

  String get subtitle {
    if (propertyName != null) {
      return '${address.city}, ${address.state}';
    }
    if (address.street != null && address.street!.isNotEmpty) {
      return '${address.city}, ${address.state}';
    }
    if (address.city != null && address.city!.isNotEmpty) {
      return '${address.state}, ${address.country}';
    }
    if (address.state != null && address.state!.isNotEmpty) {
      return address.country ?? '';
    }
    return address.country ?? '';
  }

  String get displayIcon {
    switch (searchArray.type) {
      case 'hotelIdSearch':
        return 'hotel';
      case 'citySearch':
        return 'city';
      case 'stateSearch':
        return 'state';
      case 'countrySearch':
        return 'country';
      case 'streetSearch':
        return 'street';
      default:
        return 'search';
    }
  }

  @override
  List<Object?> get props => [valueToDisplay, propertyName, address, searchArray];
}

class SuggestionAddress extends Equatable {
  final String? street;
  final String? city;
  final String? state;
  final String? country;

  const SuggestionAddress({
    this.street,
    this.city,
    this.state,
    this.country,
  });

  factory SuggestionAddress.fromJson(Map<String, dynamic> json) {
    return SuggestionAddress(
      street: json['street']?.toString(),
      city: json['city']?.toString(),
      state: json['state']?.toString(),
      country: json['country']?.toString(),
    );
  }

  @override
  List<Object?> get props => [street, city, state, country];
}

class SearchArray extends Equatable {
  final String type;
  final List<String> query;

  const SearchArray({
    required this.type,
    required this.query,
  });

  factory SearchArray.fromJson(Map<String, dynamic> json) {
    final List<dynamic> queryList = json['query'] ?? [];

    return SearchArray(
      type: json['type']?.toString() ?? 'hotelIdSearch',
      query: queryList.map((e) => e.toString()).toList(),
    );
  }

  @override
  List<Object?> get props => [type, query];
}