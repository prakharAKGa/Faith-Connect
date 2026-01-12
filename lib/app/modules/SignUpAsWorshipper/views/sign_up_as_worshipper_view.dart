import 'package:faithconnect/app/core/widgets/auth_footer.dart';
import 'package:faithconnect/app/core/widgets/custom_dropdown.dart';
import 'package:faithconnect/app/core/widgets/custom_primary_button.dart';
import 'package:faithconnect/app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/sign_up_as_worshipper_controller.dart';

class SignUpAsWorshipperView
    extends GetView<SignUpAsWorshipperController> {
  const SignUpAsWorshipperView({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Sign up as Worshipper",
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),

            /// PROFILE IMAGE
            Center(
              child: Obx(() {
                return GestureDetector(
                  onTap: controller.pickProfileImage,
                  child: CircleAvatar(
                    radius: 48,
                    backgroundColor:
                        theme.colorScheme.surfaceVariant,
                    backgroundImage:
                        controller.profileImage.value != null
                            ? FileImage(
                                controller.profileImage.value!)
                            : null,
                    child: controller.profileImage.value == null
                        ? Icon(
                            Icons.camera_alt_rounded,
                            size: 28,
                            color: theme.colorScheme.onSurface
                                .withOpacity(0.6),
                          )
                        : null,
                  ),
                );
              }),
            ),

            const SizedBox(height: 24),

            CustomTextField(
              controller: controller.nameCtrl,
              hintText: "Full Name",
              icon: Icons.person,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: controller.emailCtrl,
              hintText: "Email",
              icon: Icons.email,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: controller.passwordCtrl,
              hintText: "Password",
              icon: Icons.lock,
              isPassword: true,
            ),
            const SizedBox(height: 16),

            /// FAITH DROPDOWN
            Obx(
              () => CustomDropdown<String>(
                hint: "Select Faith",
                icon: Icons.account_balance,
                value: controller.selectedFaith.value.isEmpty
                    ? null
                    : controller.selectedFaith.value,
                items: controller.faiths,
                displayStringForItem: (v) => v,
                onChanged: (v) =>
                    controller.selectedFaith.value = v ?? '',
              ),
            ),

            const SizedBox(height: 28),

            Obx(
              () => CustomPrimaryButton(
                label: "Create Account",
                isLoading: controller.isLoading.value,
                onPressed: controller.signUp,
              ),
            ),

            const SizedBox(height: 16),

AuthFooter(
  text: "Already have an account?",
  actionText: "Login",
  onTap: () => Get.offAllNamed('/login'),
),

          ],
        ),
      ),
    );
  }
}
