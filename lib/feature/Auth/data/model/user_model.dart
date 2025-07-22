import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final String gender;
  final String birth;
  final String imageUrl;
  final String location;

  UserProfileModel({
    required this.location,
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.gender,
    required this.birth,
    required this.imageUrl,
  });

  // Convert model to Firestore map
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'birth': birth,
      'image_url': imageUrl,
      'location':location,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }

  // Convert Firestore map to model
  factory UserProfileModel.fromMap(Map<String, dynamic> map) {
    return UserProfileModel(
      location: map['location'],
      uid: map['uid'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      gender: map['gender'] ?? '',
      birth: map['birth'] ?? '',
      imageUrl: map['image_url'] ?? '',
    );
  }
}
