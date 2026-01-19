import 'package:flutter/material.dart';
import 'package:social_media_app/core/views/pages/widgets/custom_gradient_background.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: const Center(child: Text("Discover New People")),
    );
  }
}
