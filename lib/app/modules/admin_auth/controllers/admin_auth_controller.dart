import 'dart:developer';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

import '../../../routes/app_pages.dart';

class AdminAuthController extends GetxController {
  final supabaseClient = Supabase.instance.client;
  final isLoading = false.obs;
  final error = RxnString();

  final emailCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  /// Admin sign-in only (sign-up removed)
  Future<void> signIn() async {
    error.value = null;
    isLoading.value = true;
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );
      if (response.session != null) {
        log("Signed in Successfully");
        Get.offAllNamed(Routes.ADMIN_MAIN); // Navigate to protected admin area
      } else {
        error.value = "Sign-In failed. Please check credentials.";
      }
    } catch (e) {
      if (e is AuthApiException) {
        error.value = e.message; // Just the message from Supabase Auth
      } else if (e is PostgrestException) {
        error.value = e.message; // For DB-related errors
      } else {
        error.value = 'An unexpected error occurred.'; // Fallback
      }
    }

    isLoading.value = false;
  }

  /// Admin logout
  Future<void> logout() async {
    await supabaseClient.auth.signOut();
    Get.offAllNamed(Routes.HOME);
  }
}
