import 'package:news_app/models/user_role.dart';

class UserProfile {
  final String regNo;
  final String email;
  final String department;
  final String programme;
  final String college;
  final UserRole role;
  final String? profilePictureUrl; // Nullable as it might not always be present

  UserProfile({
    required this.regNo,
    required this.email,
    required this.department,
    required this.programme,
    required this.college,
    required this.role,
    this.profilePictureUrl,
  });

  // Factory constructor to create a UserProfile from a Firestore document
  factory UserProfile.fromFirestore(Map<String, dynamic> data) {
    return UserProfile(
      regNo: data['regNo'] ?? '', // Ensure regNo is always present
      email: data['email'] ?? '',
      department: data['department'] ?? '',
      programme: data['programme'] ?? '',
      college: data['college'] ?? '',
      role: (data['role'] == 'admin') ? UserRole.admin : UserRole.student,
      profilePictureUrl: data['profilePictureUrl'],
    );
  }

  // Method to convert UserProfile to a map for Firestore
  Map<String, dynamic> toFirestore() {
    return {
      'regNo': regNo,
      'email': email,
      'department': department,
      'programme': programme,
      'college': college,
      'role': role.toString().split('.').last, // Convert enum to string
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
