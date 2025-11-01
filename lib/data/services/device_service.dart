import 'dart:io';
import 'dart:convert';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:http/http.dart' as http;
import 'package:mytravaly_task/core/constants/app_constants.dart';
import 'package:mytravaly_task/core/constants/app_endpoints.dart';
import '../models/device_token_model.dart';
import '../../core/utils/shared_prefs_helper.dart';

class DeviceService {
  static final DeviceService _instance = DeviceService._internal();
  factory DeviceService() => _instance;
  DeviceService._internal();

  String? _visitorToken;
  String? _deviceId;

  String? get visitorToken => _visitorToken;
  String? get deviceId => _deviceId;

  Future<void> initialize() async {
    _visitorToken = await SharedPrefsHelper.getVisitorToken();
    _deviceId = await SharedPrefsHelper.getDeviceId();

    if (_visitorToken == null || _visitorToken!.isEmpty) {
      await registerDevice();
    }
  }

  Future<Map<String, dynamic>> _getDeviceDetails() async {
    final deviceInfo = DeviceInfoPlugin();

    try {
      if (Platform.isAndroid) {
        final androidInfo = await deviceInfo.androidInfo;
        return {
          "deviceModel": androidInfo.model ?? "unknown",
          "deviceFingerprint": androidInfo.fingerprint ?? "unknown",
          "deviceBrand": androidInfo.brand ?? "unknown",
          "deviceId": androidInfo.id ?? "unknown",
          "deviceName": androidInfo.device ?? "unknown",
          "deviceManufacturer": androidInfo.manufacturer ?? "unknown",
          "deviceProduct": androidInfo.product ?? "unknown",
          "deviceSerialNumber": "unknown",
        };
      } else if (Platform.isIOS) {
        final iosInfo = await deviceInfo.iosInfo;
        return {
          "deviceModel": iosInfo.utsname.machine ?? "unknown",
          "deviceFingerprint": iosInfo.identifierForVendor ?? "unknown",
          "deviceBrand": "Apple",
          "deviceId": iosInfo.identifierForVendor ?? "unknown_ios",
          "deviceName": iosInfo.name ?? "unknown",
          "deviceManufacturer": "Apple",
          "deviceProduct": iosInfo.model ?? "unknown",
          "deviceSerialNumber": "unknown",
        };
      }
    } catch (e) {
      print('Error getting device details: $e');
    }

    return {
      "deviceModel": "unknown",
      "deviceFingerprint": "unknown",
      "deviceBrand": "unknown",
      "deviceId": "unknown_${DateTime.now().millisecondsSinceEpoch}",
      "deviceName": "unknown",
      "deviceManufacturer": "unknown",
      "deviceProduct": "unknown",
      "deviceSerialNumber": "unknown",
    };
  }

  Future<bool> registerDevice() async {
    try {
      final deviceDetails = await _getDeviceDetails();
      _deviceId = deviceDetails['deviceId'];

      final payload = {
        "action": "deviceRegister",
        "deviceRegister": deviceDetails,
      };

      final response = await http.post(
        Uri.parse(ApiEndpoints.BASE_URL),
        headers: {
          'Content-Type': 'application/json',
          'authtoken': AppConstants.authToken,
        },
        body: json.encode(payload),
      );

      print('Device Register API Response: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = json.decode(response.body);
        final deviceToken = DeviceTokenResponse.fromJson(jsonData);

        _visitorToken = deviceToken.visitorToken;

        await SharedPrefsHelper.saveVisitorToken(_visitorToken!);
        await SharedPrefsHelper.saveDeviceId(_deviceId!);

        print('✅ Device registered successfully. Visitor Token: $_visitorToken');
        return true;
      } else {
        print('❌ Failed to register device: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error registering device: $e');
      return false;
    }
  }

  Map<String, String> getHeaders() {
    return {
      'authtoken': AppConstants.authToken,
      'visitortoken': _visitorToken ?? '',
    };
  }
}
