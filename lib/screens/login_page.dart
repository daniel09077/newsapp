import 'package:flutter/material.dart';
import 'package:news_app/services/auth_service.dart'; // Import the authentication service
import 'package:news_app/screens/news_home_page.dart'; // Import NewsHomePage for navigation
//import 'package:news_app/models/user_role.dart'; // Import UserRole
import 'package:news_app/models/user_profile.dart'; // Import UserProfile

class LoginPage extends StatefulWidget {
  // Updated callback to pass UserProfile instead of Map
  final ValueChanged<UserProfile> onLoginSuccess;

  const LoginPage({super.key, required this.onLoginSuccess});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Key for form validation
  final TextEditingController _regNoController = TextEditingController();
  String? _loginErrorMessage; // Renamed from _errorMessage to be more specific

  void _login() async {
    if (_formKey.currentState!.validate()) {
      // Clear any previous error messages before attempting login
      setState(() {
        _loginErrorMessage = null;
      });

      // Convert input to uppercase before processing for case-insensitivity
      final String regNo = _regNoController.text.trim().toUpperCase();
      final AuthService authService = AuthService();

      // Now login returns a UserProfile object
      final UserProfile? userProfile = await authService.login(regNo);

      // Check if the widget is still mounted before using context
      if (!mounted) return;

      if (userProfile != null) {
        widget.onLoginSuccess(userProfile); // Pass the full UserProfile
        // Clear any previous error messages
        setState(() {
          _loginErrorMessage = null;
        });
        // Navigate to NewsHomePage after successful login
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => NewsHomePage(userProfile: userProfile), // Pass the full UserProfile
          ),
        );
      } else {
        // This error occurs if the format is correct but the reg number
        // is not in Firestore or doesn't match.
        setState(() {
          _loginErrorMessage = 'Invalid Registration Number. Please check your entry and try again.';
        });
      }
    } else {
      // If form validation fails (e.g., incorrect format, empty),
      // the TextFormField's validator will display the error.
      setState(() {
        _loginErrorMessage = null; // Clear general login error if format is wrong
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Login'), // No explicit style, uses theme
        // backgroundColor, elevation, centerTitle are now inherited from ThemeData
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form( // Wrap with Form widget for validation
            key: _formKey, // Assign the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Image.asset(
                  'assets/images/kpt_logo.png',
                  height: 90, // Slightly reduced height
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.school, size: 90, color: Colors.blueGrey);
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Kaduna Polytechnic News Hub',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith( // Use headlineSmall from theme
                    color: Theme.of(context).primaryColor, // Use primary color (green)
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 30), // Reduced spacing
                TextFormField(
                  controller: _regNoController,
                  decoration: InputDecoration(
                    labelText: 'Registration Number',
                    hintText: 'e.g., CST23HND0050 or ADMIN0123456',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0), // Slightly less rounded
                    ),
                    prefixIcon: const Icon(Icons.person, color: Colors.grey), // Icon color
                    filled: true,
                    fillColor: Colors.grey[50], // Lighter fill
                  ),
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Registration Number cannot be empty.';
                    }
                    final String upperCaseValue = value.toUpperCase(); // Validate uppercase input
                    if (upperCaseValue.length != 12) {
                      return 'Registration Number must be 12 characters long.';
                    }
                    final RegExp studentRegExp = RegExp(r'^[A-Z]{3}\d{2}[A-Z]{3}\d{4}$');
                    final RegExp adminRegExp = RegExp(r'^ADMIN\d{7}$');

                    if (!studentRegExp.hasMatch(upperCaseValue) && !adminRegExp.hasMatch(upperCaseValue)) {
                      return 'Invalid format. e.g., CST23HND0050 or ADMIN0123456';
                    }
                    return null;
                  },
                ),
                if (_loginErrorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0), // Reduced padding
                    child: Text(
                      _loginErrorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 13), // Slightly smaller font
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(height: 25), // Reduced spacing
                ElevatedButton(
                  onPressed: _login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor, // Use primary color (green)
                    padding: const EdgeInsets.symmetric(vertical: 14.0), // Slightly reduced padding
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0), // Slightly less rounded
                    ),
                    elevation: 3, // Reduced elevation
                  ),
                  child: const Text(
                    'Login',
                    style: TextStyle(fontSize: 17, color: Colors.white), // Slightly smaller font
                  ),
                ),
                const SizedBox(height: 15), // Reduced spacing
                TextButton(
                  onPressed: () {
                    _showMessageBox(context, 'Forgot Registration Number?', 'Please contact the administration office for assistance.');
                  },
                  child: Text(
                    'Forgot Registration Number?',
                    style: TextStyle(color: Theme.of(context).primaryColor), // Use primary color
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showMessageBox(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Slightly less rounded
          title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Text(message, style: const TextStyle(fontSize: 15)),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Theme.of(context).primaryColor)), // Use primary color
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
