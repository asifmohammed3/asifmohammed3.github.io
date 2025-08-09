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

  // For state: signUp or signIn mode
  final isSignUpMode = false.obs;

  @override
  void onClose() {
    emailCtrl.dispose();
    passwordCtrl.dispose();
    super.onClose();
  }

  Future<void> signIn() async {
    error.value = null;
    isLoading.value = true;
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );
      if (response.session != null) {
        log("Signed in Succesfully");
        Get.offAllNamed(Routes.ADMIN_MAIN); // Navigate to protected area
      } else {
        error.value = "Sign-In failed. Please check credentials.";
      }
    } catch (e) {
      error.value = e.toString();
    }
    isLoading.value = false;
  }

  Future<void> signUp() async {
    error.value = null;
    isLoading.value = true;
    try {
      final response = await supabaseClient.auth.signUp(
        email: emailCtrl.text.trim(),
        password: passwordCtrl.text.trim(),
      );
      if (response.user != null) {
        error.value =
            "Sign-Up successful. Please verify your email and sign in.";
        isSignUpMode.value = false;
      } else {
        error.value = "Sign-Up failed.";
      }
    } catch (e) {
      error.value = e.toString();
    }
    isLoading.value = false;
  }

  void logout() async {
    await supabaseClient.auth.signOut();
    Get.offAllNamed(Routes.HOME);
  }
}
