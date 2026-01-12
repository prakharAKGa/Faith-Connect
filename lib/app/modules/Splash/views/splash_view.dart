import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Obx(
            () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                /// Animated Logo
                AnimatedScale(
                  scale: controller.showLogo.value ? 1.0 : 0.7,
                  duration: const Duration(milliseconds: 900),
                  curve: Curves.elasticOut,
                  child: AnimatedOpacity(
                    opacity: controller.showLogo.value ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 700),
                    child: Image.asset(
                      'assets/images/logowithoutbg.png',
                      height: 250,
                      width: 250,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),

                const SizedBox(height: 32),

                /// App Name (fade in after logo)
                AnimatedOpacity(
                  opacity: controller.showTagline.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 800),
                  child: Text(
                    "FaithConnect",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// Tagline (fade in last)
                AnimatedOpacity(
                  opacity: controller.showTagline.value ? 1.0 : 0.0,
                  duration: const Duration(milliseconds: 1000),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Text(
                      "Connecting Worshipers with Spiritual Leaders",
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 15,
                        height: 1.5,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}