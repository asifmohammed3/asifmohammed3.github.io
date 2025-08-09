import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_auth_controller.dart';

class AdminAuthView extends GetView<AdminAuthController> {
  const AdminAuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Obx(() {
          return Card(
            color: const Color(0xFF1E1E1E),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: Padding(
              padding: const EdgeInsets.all(32.0),
              child: SizedBox(
                width: 340,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      controller.isSignUpMode.value ? 'Sign Up' : 'Sign In',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextField(
                      controller: controller.emailCtrl,
                      decoration: const InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(color: Colors.white),
                        hintText: "your@email.com",
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller.passwordCtrl,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(color: Colors.white70),
                        hintText: "********",
                      ),
                    ),
                    const SizedBox(height: 28),
                    if (controller.error.value != null)
                      Text(
                        controller.error.value!,
                        style: const TextStyle(color: Colors.redAccent),
                        textAlign: TextAlign.center,
                      ),
                    if (controller.isLoading.value)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CircularProgressIndicator(),
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : () => controller.isSignUpMode.value
                                    ? controller.signUp()
                                    : controller.signIn(),
                          child: Text(
                            controller.isSignUpMode.value
                                ? 'Sign Up'
                                : 'Sign In',
                          ),
                        ),
                        TextButton(
                          onPressed: () => controller.isSignUpMode.value =
                              !controller.isSignUpMode.value,
                          child: Text(
                            controller.isSignUpMode.value
                                ? "Already have account? Sign In"
                                : "Don't have account? Sign Up",
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
