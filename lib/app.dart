import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'data/repositories/hotel_repository.dart';
import 'data/services/api_service.dart';
import 'data/services/google_auth_service.dart';
import 'presentation/auth/bloc/auth_bloc.dart';
import 'presentation/home/bloc/hotel_bloc.dart';
import 'presentation/search/bloc/search_bloc.dart';
import 'routes/app_routes.dart';
import 'core/constants/app_colors.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final apiService = ApiService();
    final hotelRepository = HotelRepository(apiService);
    final googleAuthService = GoogleAuthService();

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(googleAuthService),
        ),
        BlocProvider(
          create: (context) => HotelBloc(hotelRepository),
        ),
        BlocProvider(
          create: (context) => SearchBloc(hotelRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Hotel Search App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          primaryColor: AppColors.primary,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            elevation: 0,
            centerTitle: true,
          ),
        ),
        initialRoute: AppRoutes.signIn,
        onGenerateRoute: AppRoutes.generateRoute,
      ),
    );
  }
}