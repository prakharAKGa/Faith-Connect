import 'dart:io';

import 'package:faithconnect/app/core/widgets/auth_footer.dart';
import 'package:faithconnect/app/core/widgets/custom_dropdown.dart';
import 'package:faithconnect/app/core/widgets/custom_primary_button.dart';
import 'package:faithconnect/app/core/widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../controllers/sign_up_controller.dart';

class SignUpView extends GetView<SignUpController> {
  const SignUpView({super.key});

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final XFile? picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );

    if (picked != null) {
      controller.setProfileImage(File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Sign Up as Leader"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "Create Leader Account",
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              "Connect with your worshipers and share guidance",
              style: theme.textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 28),

            /// Profile Image
            Center(
              child: Obx(() {
                return GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 52,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                    backgroundImage: controller.profileImage.value != null
                        ? FileImage(controller.profileImage.value!)
                        : null,
                    child: controller.profileImage.value == null
                        ? Icon(
                            Icons.camera_alt_rounded,
                            size: 30,
                            color: theme.colorScheme.onSurface,
                          )
                        : null,
                  ),
                );
              }),
            ),

            const SizedBox(height: 28),

            CustomTextField(
              controller: controller.nameCtrl,
              hintText: "Full Name",
              icon: Icons.person,
            ),
            const SizedBox(height: 16),

            CustomTextField(
              controller: controller.emailCtrl,
              hintText: "Email Address",
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

            /// Fixed Faith Dropdown
           Obx(
  () => CustomDropdown<Faith>(
    hint: "Select Faith",
    icon: Icons.self_improvement,
    value: controller.selectedFaith.value,
    items: controller.faithOptions,
    displayStringForItem: (faith) => faith.label,
    onChanged: (Faith? newFaith) {
      controller.selectedFaith.value = newFaith;
    },
  ),
),

            const SizedBox(height: 16),

            CustomTextField(
              controller: controller.bioCtrl,
              hintText: "Short Bio / About You",
              icon: Icons.info_outline,
              maxLines: 3,
            ),

            const SizedBox(height: 32),

            Obx(
              () => CustomPrimaryButton(
                label: "Create Leader Account",
                isLoading: controller.isLoading.value,
                onPressed: controller.signUpLeader,
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