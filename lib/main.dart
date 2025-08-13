import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:news_app/firebase_options.dart'; // Ensure this file exists and is correctly generated
import 'package:news_app/screens/login_page.dart';
import 'package:news_app/screens/news_home_page.dart'; // Import NewsHomePage
import 'package:news_app/models/user_profile.dart'; // Import UserProfile
import 'package:device_preview/device_preview.dart'; // Import device_preview

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    DevicePreview( // Wrap your app with DevicePreview
      enabled: !const bool.fromEnvironment('dart.vm.product'), // Only enable in debug builds
      builder: (context) => const MyApp(), // Your app widget
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  UserProfile? _loggedInUserProfile; // State to hold the logged-in user's profile

  @override
  Widget build(BuildContext context) {
    // Define your custom green color
    const MaterialColor kptGreen = MaterialColor(
      0xFF4CAF50, // Primary green color (e.g., Green 500)
      <int, Color>{
        50: Color(0xFFE8F5E9),
        100: Color(0xFFC8E6C9),
        200: Color(0xFFA5D6A7),
        300: Color(0xFF81C784),
        400: Color(0xFF66BB6A),
        500: Color(0xFF4CAF50),
        600: Color(0xFF43A047),
        700: Color(0xFF388E3C),
        800: Color(0xFF2E7D32),
        900: Color(0xFF1B5E20),
      },
    );

    return MaterialApp(
      // Add these properties for DevicePreview
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      // End DevicePreview properties

      title: 'Kaduna Polytechnic News App', // Changed title to be more specific
      theme: ThemeData(
        primarySwatch: kptGreen, // Use the custom green as primary color
        scaffoldBackgroundColor: Colors.white, // Set scaffold background to white
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // AppBar background white
          foregroundColor: Colors.black, // AppBar text/icon color black
          elevation: 0,
        ),
        fontFamily: 'Roboto Serif', // Set the new font family
        textTheme: const TextTheme( // Adjust default text sizes for consistency
          displayLarge: TextStyle(fontSize: 57.0),
          displayMedium: TextStyle(fontSize: 45.0),
          displaySmall: TextStyle(fontSize: 36.0),
          headlineLarge: TextStyle(fontSize: 32.0),
          headlineMedium: TextStyle(fontSize: 28.0),
          headlineSmall: TextStyle(fontSize: 24.0),
          titleLarge: TextStyle(fontSize: 22.0), // Standard for app bar titles
          titleMedium: TextStyle(fontSize: 16.0),
          titleSmall: TextStyle(fontSize: 14.0),
          bodyLarge: TextStyle(fontSize: 16.0),
          bodyMedium: TextStyle(fontSize: 14.0), // Standard body text
          bodySmall: TextStyle(fontSize: 12.0),
          labelLarge: TextStyle(fontSize: 14.0),
          labelMedium: TextStyle(fontSize: 12.0),
          labelSmall: TextStyle(fontSize: 11.0),
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: _loggedInUserProfile == null
          ? LoginPage(
              onLoginSuccess: (userProfile) {
                setState(() {
                  _loggedInUserProfile = userProfile;
                });
              },
            )
          : NewsHomePage(userProfile: _loggedInUserProfile!),
      debugShowCheckedModeBanner: false, // Remove debug banner
    );
  }
}
