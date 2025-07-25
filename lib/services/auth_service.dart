// lib/services/auth_service.dart
import 'dart:io'; // Required for File
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
// import 'package:firebase_auth/firebase_auth.dart'; // Temporarily removed as _auth field is unused
import 'package:firebase_storage/firebase_storage.dart'; // Import Firebase Storage
import 'package:flutter/foundation.dart'; // Import for debugPrint
import 'package:news_app/models/user_role.dart'; // Import UserRole
import 'package:news_app/models/user_profile.dart'; // Import the new UserProfile model

class AuthService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // final FirebaseAuth _auth = FirebaseAuth.instance; // Removed: currently unused
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Simulates a user login by fetching comprehensive user data from Firestore.
  /// Returns a UserProfile object if login is successful and user exists, otherwise null.
  Future<UserProfile?> login(String regNo) async {
    try {
      final String formattedRegNo = regNo.toUpperCase();

      // Get the document for the given registration number from the 'users' collection
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(formattedRegNo).get();

      if (userDoc.exists) {
        // User document found, create UserProfile object
        final data = userDoc.data() as Map<String, dynamic>;
        // Add regNo to the data map as it's the document ID but also a field in UserProfile
        data['regNo'] = formattedRegNo;
        return UserProfile.fromFirestore(data);
      } else {
        // User document does not exist
        debugPrint('Login failed: User $formattedRegNo not found in Firestore.');
        return null;
      }
    } catch (e) {
      debugPrint('Error during Firestore login: $e');
      return null;
    }
  }

  /// Registers a new user with their profile details and optional profile picture.
  /// Returns the created UserProfile on success, null on failure.
  Future<UserProfile?> registerUser({
    required String regNo,
    required String email,
    required String department,
    required String programme,
    required String college,
    required UserRole role,
    File? profilePictureFile, // Optional file for upload
  }) async {
    try {
      final String formattedRegNo = regNo.toUpperCase();

      // Check if user already exists
      DocumentSnapshot existingUser = await _firestore.collection('users').doc(formattedRegNo).get();
      if (existingUser.exists) {
        debugPrint('Registration failed: User with Reg No $formattedRegNo already exists.');
        return null; // Or throw an error
      }

      String? profilePictureUrl;
      if (profilePictureFile != null) {
        // Upload profile picture to Firebase Storage
        profilePictureUrl = await _uploadProfilePicture(formattedRegNo, profilePictureFile);
      }

      // Create the UserProfile object
      final newUserProfile = UserProfile(
        regNo: formattedRegNo,
        email: email,
        department: department,
        programme: programme,
        college: college,
        role: role,
        profilePictureUrl: profilePictureUrl,
      );

      // Save user data to Firestore
      await _firestore.collection('users').doc(formattedRegNo).set(newUserProfile.toFirestore());

      debugPrint('User $formattedRegNo registered successfully in Firestore.');
      return newUserProfile;
    } catch (e) {
      debugPrint('Error during user registration: $e');
      return null;
    }
  }

  /// Uploads a profile picture to Firebase Storage and returns its download URL.
  Future<String?> _uploadProfilePicture(String regNo, File imageFile) async {
    try {
      // Create a reference to the location where the image will be stored
      // e.g., 'profile_pictures/CST23HND0050.jpg'
      final ref = _storage.ref().child('profile_pictures').child('$regNo.jpg');

      // Upload the file
      UploadTask uploadTask = ref.putFile(imageFile);

      // Await the completion of the upload
      TaskSnapshot snapshot = await uploadTask;

      // Get the download URL
      final downloadUrl = await snapshot.ref.getDownloadURL();
      debugPrint('Profile picture uploaded for $regNo. URL: $downloadUrl');
      return downloadUrl;
    } catch (e) {
      debugPrint('Error uploading profile picture for $regNo: $e');
      return null;
    }
  }

  // You can add other methods here, like fetching all users, deleting users, etc.
}
