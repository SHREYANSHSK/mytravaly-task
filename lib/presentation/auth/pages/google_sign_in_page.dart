import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../routes/app_routes.dart';

class GoogleSignInPage extends StatelessWidget {
  const GoogleSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, AppRoutes.home);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.primary,
                  AppColors.primary.withOpacity(0.7),
                ],
              ),
            ),
            child: SafeArea(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.hotel,
                        size: 100,
                        color: Colors.white,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        AppStrings.appName,
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Find your perfect stay',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 60),
                      if (state is AuthLoading)
                        const CircularProgressIndicator(color: Colors.white)
                      else
                        _buildGoogleSignInButton(context),
                      const SizedBox(height: 20),
                      const Text(
                        'Demo Mode: Sign in without Google credentials',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildGoogleSignInButton(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: () {
        context.read<AuthBloc>().add(GoogleSignInRequested());
      },
      icon: Image.network(
        'https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg',
        height: 24,
        errorBuilder: (context, error, stackTrace) => const Icon(Icons.login),
      ),
      label: const Text(
        AppStrings.signInWithGoogle,
        style: TextStyle(fontSize: 16),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.white,
        foregroundColor: AppColors.textPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        elevation: 8,
      ),
    );
  }
}

