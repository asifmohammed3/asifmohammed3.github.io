import 'package:flutter/foundation.dart'; // for kIsWeb
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'app/routes/app_pages.dart';
import 'app/widgets/loader.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  String supabaseUrl;
  String supabaseAnonKey;

  // if (kIsWeb) {
  //   // Web: use --dart-define
  //   supabaseUrl = const String.fromEnvironment('SUPABASE_URL');
  //   supabaseAnonKey = const String.fromEnvironment('SUPABASE_ANON_KEY');
  // } else {
  //   // Mobile/Desktop: use .env file
  //   await dotenv.load(fileName: ".env");
  //   supabaseUrl = dotenv.env['SUPABASE_URL'] ?? '';
  //   supabaseAnonKey = dotenv.env['SUPABASE_ANON_KEY'] ?? '';
  // }
  supabaseUrl = "https://lwmevpwgybffsflvfokt.supabase.co";
  supabaseAnonKey = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Imx3bWV2cHdneWJmZnNmbHZmb2t0Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTQ1Njc0MjksImV4cCI6MjA3MDE0MzQyOX0.1cjpWQ55A2OdeZs_g6berT1SjK05v_Jz-WgLoie83bI";

  if (supabaseUrl.isEmpty || supabaseAnonKey.isEmpty) {
    throw Exception(
      "Missing Supabase credentials.\n"
          "For Web: pass via --dart-define,\n"
          "For Mobile: store in .env",
    );
  }

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Portfolio',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData.dark().copyWith(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.black,
        inputDecorationTheme: InputDecorationTheme(
          labelStyle: const TextStyle(color: Colors.white70),
          hintStyle: const TextStyle(color: Colors.white38),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white54),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.dark,
      builder: (context, child) {
        return Stack(
          children: [
            child!,
            const OverlayLoader(),
          ],
        );
      },
    );
  }
}
