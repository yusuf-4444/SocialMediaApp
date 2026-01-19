import 'package:flutter/material.dart';
import 'package:social_media_app/core/views/pages/widgets/custom_gradient_background.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(child: const Center(child: Text("Profile Page")));
  }
}
