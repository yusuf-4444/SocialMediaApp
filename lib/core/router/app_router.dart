import 'package:flutter/cupertino.dart';
import 'package:social_media_app/core/router/app_routes.dart';
import 'package:social_media_app/core/views/pages/widgets/custom_nav_bar.dart';
import 'package:social_media_app/features/auth/views/pages/auth_page.dart';
import 'package:social_media_app/features/home/views/pages/create_post_page.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.login:
        return CupertinoPageRoute(builder: (_) => const AuthPage());
      case AppRoutes.home:
        return CupertinoPageRoute(builder: (_) => const CustomNavBar());
      case AppRoutes.post:
        return CupertinoPageRoute(builder: (_) => const CreatePostPage());
      default:
        return CupertinoPageRoute(builder: (_) => const AuthPage());
    }
  }
}
