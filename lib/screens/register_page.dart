import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart'; // For picking images
import 'dart:io'; // For File
import 'package:news_app/models/user_role.dart';
import 'package:news_app/services/auth_service.dart';
import 'package:news_app/screens/login_page.dart'; // To navigate back to login

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _regNoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  // Removed: TextEditingController _departmentController = TextEditingController();
  // Removed: TextEditingController _programmeController = TextEditingController();
  // Removed: TextEditingController _collegeController = TextEditingController();

  File? _profileImage; // To store the picked image file
  bool _isLoading = false; // To show loading indicator during registration
  String? _errorMessage; // For displaying registration errors

  final ImagePicker _picker = ImagePicker(); // Image picker instance

  // List of predefined departments, programmes, and colleges for dropdowns (optional but good UX)
  final List<String> _departments = [
    'Computer Science',
    'Electrical Engineering',
    'Civil Engineering',
    'Business Administration',
    'Accountancy',
    'Mass Communication',
    'Architecture',
    'Urban and Regional Planning', // Corrected typo here
    // Add more departments as needed
  ];

  final List<String> _programmes = [
    'National Diploma (ND)',
    'Higher National Diploma (HND)',
    'Pre-ND',
    'Certificate Course',
    // Add more programmes as needed
  ];

  final List<String> _colleges = [
    'College of Science and Technology',
    'College of Environmental Studies',
    'College of Engineering',
    'College of Business and Management Studies',
    'College of Administrative Studies',
    // Add more colleges as needed
  ];

  // Selected values for dropdowns
  String? _selectedDepartment;
  String? _selectedProgramme;
  String? _selectedCollege;

  // Function to pick an image from gallery
  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  // Function to handle user registration
  void _register() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
        _errorMessage = null; // Clear previous errors
      });

      final AuthService authService = AuthService();

      try {
        final userProfile = await authService.registerUser(
          regNo: _regNoController.text.trim(),
          email: _emailController.text.trim(),
          department: _selectedDepartment!, // Use selected value
          programme: _selectedProgramme!, // Use selected value
          college: _selectedCollege!, // Use selected value
          role: UserRole.student, // New registrations are typically students
          profilePictureFile: _profileImage,
        );

        if (!mounted) return; // Check if widget is still mounted after async operation

        if (userProfile != null) {
          // Registration successful
          // Await the showMessageBox to ensure it's dismissed before navigating
          await _showMessageBox(
            context,
            'Registration Successful!',
            'Your account has been created. You can now log in.',
          );

          if (!mounted) return; // Check again after dialog is dismissed

          // Navigate back to login page after user dismisses message
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(
              builder: (context) => LoginPage(onLoginSuccess: (profile) {
                // This callback will be triggered if the user logs in again
                // You might want to refresh the main app state here if needed
              }),
            ),
          );
        } else {
          // Registration failed (e.g., user already exists)
          setState(() {
            _errorMessage = 'Registration failed. User might already exist or an error occurred.';
          });
        }
      } catch (e) {
        setState(() {
          _errorMessage = 'An unexpected error occurred: $e';
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _regNoController.dispose(); // Corrected: Dispose regNo controller
    _emailController.dispose(); // Corrected: Dispose email controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Profile Picture Section
                GestureDetector(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage: _profileImage != null ? FileImage(_profileImage!) : null,
                    child: _profileImage == null
                        ? Icon(
                            Icons.camera_alt,
                            size: 40,
                            color: Colors.grey[600],
                          )
                        : null,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  _profileImage == null ? 'Tap to add profile picture' : 'Profile picture selected',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 30),

                // Registration Number
                TextFormField(
                  controller: _regNoController,
                  decoration: InputDecoration(
                    labelText: 'Registration Number',
                    hintText: 'e.g., CST23HND0050',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.badge),
                  ),
                  keyboardType: TextInputType.text,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Registration Number cannot be empty.';
                    }
                    final String upperCaseValue = value.toUpperCase();
                    if (upperCaseValue.length != 12) {
                      return 'Registration Number must be 12 characters long.';
                    }
                    final RegExp studentRegExp = RegExp(r'^[A-Z]{3}\d{2}[A-Z]{3}\d{4}$');
                    if (!studentRegExp.hasMatch(upperCaseValue)) {
                      return 'Invalid format. e.g., CST23HND0050';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Email
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    hintText: 'e.g., your.email@example.com',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.email),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Email cannot be empty.';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Enter a valid email address.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Department Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedDepartment,
                  decoration: InputDecoration(
                    labelText: 'Department',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.apartment),
                  ),
                  items: _departments.map((String department) {
                    return DropdownMenuItem<String>(
                      value: department,
                      child: Text(department),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDepartment = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your department.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // Programme Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedProgramme,
                  decoration: InputDecoration(
                    labelText: 'Programme',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.book),
                  ),
                  items: _programmes.map((String programme) {
                    return DropdownMenuItem<String>(
                      value: programme,
                      child: Text(programme),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedProgramme = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your programme.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15),

                // College Dropdown
                DropdownButtonFormField<String>(
                  value: _selectedCollege,
                  decoration: InputDecoration(
                    labelText: 'College',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
                    prefixIcon: const Icon(Icons.school),
                  ),
                  items: _colleges.map((String college) {
                    return DropdownMenuItem<String>(
                      value: college,
                      child: Text(college),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCollege = newValue;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please select your college.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),

                // Error Message Display
                if (_errorMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 15.0),
                    child: Text(
                      _errorMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                  ),

                // Register Button
                ElevatedButton(
                  onPressed: _isLoading ? null : _register, // Disable button while loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    elevation: 3,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          'Register',
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
                const SizedBox(height: 15),

                // Back to Login Button
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Go back to the previous screen (LoginPage)
                  },
                  child: Text(
                    'Already have an account? Login',
                    style: TextStyle(color: Theme.of(context).primaryColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper function for showing message boxes (reused from LoginPage)
  // Changed return type to Future<void>
  Future<void> _showMessageBox(BuildContext context, String title, String message) async {
    return showDialog<void>( // Explicitly specify Future<void>
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          content: Text(message, style: const TextStyle(fontSize: 15)),
          actions: <Widget>[
            TextButton(
              child: Text('OK', style: TextStyle(color: Theme.of(context).primaryColor)),
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
