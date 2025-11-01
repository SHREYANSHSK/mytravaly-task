import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mytravaly_task/routes/app_routes_name.dart';
import 'core/constants/app_sizes.dart';
import 'core/theme/theme.dart';
import 'core/utils/app_logger.dart';
import 'data/repositories/hotel_repository.dart';
import 'data/services/api_service.dart';
import 'data/services/device_service.dart';
import 'data/services/google_auth_service.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/autocomplete/bloc/autocomplete_boc.dart';
import 'presentation/home/bloc/home_bloc.dart';
import 'presentation/search/bloc/search_bloc.dart';
import 'routes/app_routes.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DeviceService _deviceService = DeviceService();
  bool _isDeviceReady = false;

  @override
  void initState() {
    super.initState();
    _initializeDevice();
  }

  Future<void> _initializeDevice() async {
    try {
      await _deviceService.initialize();
      setState(() => _isDeviceReady = true);
    } catch (e,stacktrace) {
      Log.error('Device initialization failed',[e,stacktrace]);
      setState(() => _isDeviceReady = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isDeviceReady) {
      return ScreenUtilInit(
        designSize: AppSizes.designSize,
        useInheritedMediaQuery: true,
        minTextAdapt: true,
        splitScreenMode: true,
        builder:(context,child){
          return  MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
      );
    }

    final apiService = ApiService(_deviceService);
    final hotelRepository = HotelRepository(apiService);
    final googleAuthService = GoogleAuthService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => AuthBloc(googleAuthService)),
        BlocProvider(create: (_) => HomeBloc(hotelRepository)),
        BlocProvider(create: (_) => SearchBloc(hotelRepository)),
        BlocProvider(create: (_) => AutocompleteBloc(hotelRepository)),
      ],
      child: MaterialApp(
        title: 'Hotel Search App',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: AppRoutesName.signIn,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}
