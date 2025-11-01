import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'core/constants/app_sizes.dart';
import 'core/device_init_cubit.dart';
import 'core/theme/theme.dart';
import 'data/repositories/hotel_repository.dart';
import 'data/services/api_service.dart';
import 'data/services/device_service.dart';
import 'data/services/google_auth_service.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/autocomplete/bloc/autocomplete_boc.dart';
import 'presentation/home/bloc/home_bloc.dart';
import 'presentation/search/bloc/search_bloc.dart';
import 'routes/app_routes.dart';
import 'routes/app_routes_name.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final deviceService = DeviceService();

    return BlocProvider(
      create: (_) => DeviceInitCubit(deviceService)..initializeDevice(),
      child: BlocBuilder<DeviceInitCubit, DeviceInitState>(
        builder: (context, state) {
          if (state == DeviceInitState.loading ||
              state == DeviceInitState.initial) {
            return ScreenUtilInit(
              designSize: AppSizes.designSize,
              useInheritedMediaQuery: true,
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (_, __) => const MaterialApp(
                home: Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                ),
              ),
            );
          }

          if (state == DeviceInitState.failure) {
            return const MaterialApp(
              home: Scaffold(
                body: Center(
                  child: Text(
                    "Device initialization failed. Please restart the app.",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            );
          }

          final apiService = ApiService(deviceService);
          final hotelRepository = HotelRepository(apiService);
          final googleAuthService = GoogleAuthService();

          return MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => AuthBloc(googleAuthService)),
              BlocProvider(create: (_) => HomeBloc(hotelRepository)),
              BlocProvider(create: (_) => SearchBloc(hotelRepository)),
              BlocProvider(create: (_) => AutocompleteBloc(hotelRepository)),
            ],
            child: ScreenUtilInit(
              designSize: AppSizes.designSize,
              useInheritedMediaQuery: true,
              minTextAdapt: true,
              splitScreenMode: true,
              builder: (_, __) => MaterialApp(
                title: 'Hotel Search App',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                initialRoute: AppRoutesName.signIn,
                onGenerateRoute: AppRoutes.generateRoute,
              ),
            ),
          );
        },
      ),
    );
  }
}
