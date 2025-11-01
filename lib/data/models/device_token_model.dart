import 'package:equatable/equatable.dart';

class DeviceTokenResponse extends Equatable {
  final bool status;
  final String message;
  final String visitorToken;

  const DeviceTokenResponse({
    required this.status,
    required this.message,
    required this.visitorToken,
  });

  factory DeviceTokenResponse.fromJson(Map<String, dynamic> json) {
    return DeviceTokenResponse(
      status: json['status'] ?? false,
      message: json['message']?.toString() ?? '',
      visitorToken: json['visitorToken']?.toString() ??
          json['visitor_token']?.toString() ??
          json['data']?['visitorToken']?.toString() ?? '',
    );
  }

  @override
  List<Object?> get props => [status, message, visitorToken];
}