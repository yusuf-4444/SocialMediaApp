// main.dart
import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:social_media_app/core/router/app_router.dart';
import 'package:social_media_app/core/router/app_routes.dart';
import 'package:social_media_app/core/utils/app_constants.dart';
import 'package:social_media_app/core/utils/app_themes.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState;

import 'features/auth/auth_cubit/auth_cubit.dart';

void main() async {
  await Supabase.initialize(
    url: AppConstants.supaBaseUrl,
    anonKey: AppConstants.supabaseKey,
  );
  runApp(
    DevicePreview(
      enabled: !kReleaseMode,
      builder: (context) => SocialMeidaApp(),
    ),
  );
}

class SocialMeidaApp extends StatelessWidget {
  const SocialMeidaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      child: Builder(
        builder: (context) {
          return BlocProvider(
            create: (context) => AuthCubit()..getUserData(),
            child: BlocBuilder<AuthCubit, AuthState>(
              buildWhen: (previous, current) => current is AuthSuccess,
              builder: (context, state) {
                return MaterialApp(
                  debugShowCheckedModeBanner: false,
                  title: 'Social Media App',
                  theme: AppThemes.lightTheme,
                  onGenerateRoute: AppRouter.onGenerateRoute,
                  initialRoute: state is AuthSuccess
                      ? AppRoutes.home
                      : AppRoutes.login,
                  locale: DevicePreview.locale(context),
                  builder: DevicePreview.appBuilder,
                  darkTheme: ThemeData.dark(),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
