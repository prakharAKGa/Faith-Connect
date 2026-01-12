import 'package:faithconnect/app/core/widgets/custom_primary_button.dart';
import 'package:faithconnect/app/core/widgets/custom_textfield.dart';
import 'package:faithconnect/app/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Form(
            key: controller.formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 40),

                /// Logo at top
                Image.asset(
                  'assets/images/logowithoutbg.png',
                  height: 250,
                  width: 250,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 24),

                Text(
                  "Welcome Back",
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onBackground,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  "Login to continue your spiritual journey",
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 48),

                CustomTextField(
                  controller: controller.emailController,
                  hintText: "Email",
                  icon: Iconsax.sms,
                  keyboardType: TextInputType.emailAddress,
                  validator: (v) => v!.isEmpty ? "Email is required" : null,
                ),

                const SizedBox(height: 20),

                CustomTextField(
                  controller: controller.passwordController,
                  hintText: "Password",
                  icon: Iconsax.lock,
                  isPassword: true,
                  validator: (v) => v!.length < 6 ? "Min 6 characters" : null,
                ),

                const SizedBox(height: 40),

                Obx(
                  () => CustomPrimaryButton(
                    label: "Login",
                    isLoading: controller.isLoading.value,
                    onPressed: controller.login,
                  ),
                ),

                const SizedBox(height: 24),

                TextButton(
                  onPressed: () {
                    // TODO: Implement Forgot Password
                    Get.snackbar("Coming Soon", "Forgot password feature is under development");
                  },
                  child: Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: scheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // "Don't have an account? Sign Up" section
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(
                        color: scheme.onSurfaceVariant,
                        fontSize: 15,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Get.toNamed(Routes.INITIAL); // Adjust route name as per your app_pages.dart
                      },
                      child: Text(
                        "Sign Up",
                        style: TextStyle(
                          color: scheme.primary,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}