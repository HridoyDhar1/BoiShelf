import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});
  static const String name = "/edit_profile";

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  final _nameController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();

  String imageUrl = "";

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  Future<void> loadProfileData() async {
    final doc = await FirebaseFirestore.instance.collection('Profile').doc(uid).get();
    final data = doc.data();
    if (data != null) {
      _nameController.text = data['name'] ?? "";
      _genderController.text = data['gender'] ?? "";
      _birthController.text = data['birth'] ?? "";
      _phoneController.text = data['phone'] ?? "";
      _emailController.text = data['email'] ?? "";
      _usernameController.text = "@${data['email']?.toString().split('@').first ?? ''}";
      imageUrl = data['image_url'] ?? "";
    }
    setState(() => isLoading = false);
  }

  Future<void> saveProfile() async {
    await FirebaseFirestore.instance.collection('Profile').doc(uid).update({
      'name': _nameController.text.trim(),
      'gender': _genderController.text.trim(),
      'birth': _birthController.text.trim(),
      'phone': _phoneController.text.trim(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Profile updated successfully')),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) return const Center(child: CircularProgressIndicator());

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () => Navigator.pop(context),
                ),
                const Spacer(),
                const Text("Edit Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                const Spacer(),
                const SizedBox(width: 40),
              ],
            ),
            const SizedBox(height: 20),
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundImage: NetworkImage(
                      imageUrl.isNotEmpty ? imageUrl : 'https://i.pravatar.cc/300',
                    ),
                  ),
                  const CircleAvatar(
                    radius: 12,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.camera_alt, size: 14, color: Colors.white),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildTextField("Full name", _nameController),
            Row(
              children: [
                Expanded(child: _buildTextField("Gender", _genderController)),
                const SizedBox(width: 16),
                Expanded(child: _buildTextField("Birthday", _birthController)),
              ],
            ),
            _buildTextField("Phone number", _phoneController),
            _buildTextField("Email", _emailController, enabled: false),
            _buildTextField("User name", _usernameController, enabled: false),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
              onPressed: saveProfile,
              child: const Text("Save", style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 5),
          TextFormField(
            controller: controller,
            enabled: enabled,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.grey.shade100,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            ),
          ),
        ],
      ),
    );
  }
}
