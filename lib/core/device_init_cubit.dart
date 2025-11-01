import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/utils/app_logger.dart';
import '../../../data/services/device_service.dart';

enum DeviceInitState { initial, loading, success, failure }

class DeviceInitCubit extends Cubit<DeviceInitState> {
  final DeviceService deviceService;

  DeviceInitCubit(this.deviceService) : super(DeviceInitState.initial);

  Future<void> initializeDevice() async {
    emit(DeviceInitState.loading);
    try {
      await deviceService.initialize();
      emit(DeviceInitState.success);
    } catch (e, stacktrace) {
      Log.error('Device initialization failed', [e, stacktrace]);
      emit(DeviceInitState.failure);
    }
  }
}
