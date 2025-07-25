import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart'; // Import Firebase Core
import 'package:news_app/firebase_options.dart'; // Import the generated Firebase options
import 'package:news_app/screens/login_page.dart';
import 'package:news_app/screens/news_home_page.dart';
import 'package:news_app/models/user_profile.dart'; // Import UserProfile

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure Flutter binding is initialized
  await Firebase.initializeApp( // Initialize Firebase
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const NewsApp());
}

class NewsApp extends StatefulWidget {
  const NewsApp({super.key});

  @override
  State<NewsApp> createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  bool _isLoggedIn = false;
  UserProfile? _loggedInUserProfile; // Now stores the full UserProfile

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  void _checkLoginStatus() async {
    // In a real Firebase Auth app, you would check FirebaseAuth.instance.currentUser here.
    // For now, we'll keep the initial state as logged out until a successful login.
    setState(() {
      _isLoggedIn = false;
      _loggedInUserProfile = null;
    });
  }

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
      title: 'Kaduna Polytechnic News',
      theme: ThemeData(
        primarySwatch: kptGreen, // Use the custom green as primary color
        scaffoldBackgroundColor: Colors.white, // Set scaffold background to white
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // AppBar background white
          foregroundColor: Colors.black, // AppBar text/icon color black
          elevation: 0,
        ),
        fontFamily: 'Roboto Serif', // Set the new font family
        textTheme: const TextTheme( // Adjust default text sizes
          displayLarge: TextStyle(fontSize: 57.0),
          displayMedium: TextStyle(fontSize: 45.0),
          displaySmall: TextStyle(fontSize: 36.0),
          headlineLarge: TextStyle(fontSize: 32.0),
          headlineMedium: TextStyle(fontSize: 28.0),
          headlineSmall: TextStyle(fontSize: 24.0),
          titleLarge: TextStyle(fontSize: 20.0), // Slightly smaller
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
      home: _isLoggedIn && _loggedInUserProfile != null
          ? NewsHomePage(
              userProfile: _loggedInUserProfile!,
            )
          : LoginPage(
              onLoginSuccess: (userProfile) {
                setState(() {
                  _isLoggedIn = true;
                  _loggedInUserProfile = userProfile;
                });
              },
            ),
    );
  }
}
