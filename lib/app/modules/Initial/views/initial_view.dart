import 'package:faithconnect/app/core/widgets/auth_footer.dart';
import 'package:faithconnect/app/core/widgets/custom_primary_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/initial_controller.dart';

class InitialView extends GetView<InitialController> {
  const InitialView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            children: [
              const Spacer(flex: 2),

              /// Logo + App Name (static, no animation)
              Column(
                children: [
                  Image.asset(
                    'assets/images/logowithoutbg.png',
                    height: 250,
                    width: 250,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "FaithConnect",
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.0,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 60,
                    height: 4,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              /// Tagline
              Text(
                "A platform where Worshipers connect with their Religious Leaders.",
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontSize: 15.5,
                  height: 1.5,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),

              const Spacer(flex: 3),

              /// Buttons
              CustomPrimaryButton(
                label: "Continue as Worshiper",
                icon: Icons.person_outline,
                onPressed: controller.continueAsWorshiper,
              ),

              const SizedBox(height: 16),

              CustomPrimaryButton(
                label: "Continue as Religious Leader",
                icon: Icons.volunteer_activism_outlined,
                onPressed: controller.continueAsLeader,
              ),

              const Spacer(flex: 2),
               AuthFooter(
              text: "Already have an account?",
              actionText: "Login",
              onTap: () => Get.offAllNamed('/login'),
            ),
            ],
          ),
        ),
      ),
    );
  }
}