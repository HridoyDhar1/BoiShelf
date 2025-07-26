// import 'package:book/feature/Auth/data/model/user_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
//
//
// import 'edit_profile.dart';
//
// class ProfileScreen extends StatelessWidget {
//   final String uid;
//
//   const ProfileScreen({super.key, required this.uid});
//
//   static const String name = "/profile_screen";
//
//   Future<UserProfileModel> getProfile() async {
//     final doc = await FirebaseFirestore.instance.collection('Profile').doc(uid).get();
//
//     return UserProfileModel.fromMap(doc.data()!);
//   }
//   Future<void> logout(BuildContext context) async {
//     await FirebaseAuth.instance.signOut();
//
//     // Navigate to Login Screen (replace with your route)
//     Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: FutureBuilder<UserProfileModel>(
//           future: getProfile(),
//           builder: (context, snapshot) {
//             if (snapshot.connectionState == ConnectionState.waiting) {
//               return const Center(child: CircularProgressIndicator());
//             }
//             if (!snapshot.hasData || snapshot.hasError) {
//               return const Center(child: Text('Profile not found.'));
//             }
//
//             final profile = snapshot.data!;
//
//             return ListView(
//               padding: const EdgeInsets.symmetric(horizontal: 24),
//               children: [
//                 const SizedBox(height: 20),
//                 const Center(
//                   child: Text("Profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//                 ),
//                 const SizedBox(height: 20),
//                 Center(
//                   child: CircleAvatar(
//                     radius: 40,
//                     backgroundImage: NetworkImage(profile.imageUrl.isNotEmpty
//                         ? profile.imageUrl
//                         : 'https://i.pravatar.cc/300'),
//                   ),
//                 ),
//                 const SizedBox(height: 10),
//                 Center(
//                   child: Text(profile.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
//                 ),
//                 Center(
//                   child: Text("@${profile.email.split('@').first}", style: const TextStyle(color: Colors.grey)),
//                 ),
//                 const SizedBox(height: 10),
//                 Center(
//                   child: ElevatedButton(
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (_) => const EditProfileScreen()),
//                       );
//                     },
//                     child: const Text("Edit Profile", style: TextStyle(color: Colors.white)),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 Container(
//                   height: 100,
//                   width: 200,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     border: Border.all(color: Colors.grey),
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceAround,
//                     children: const [
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Total", style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold)),
//                           Text("240", style: TextStyle(fontSize: 20, color: Colors.black87)),
//                         ],
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Rating", style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold)),
//                           Text("4.9", style: TextStyle(fontSize: 20, color: Colors.black87)),
//                         ],
//                       ),
//                       Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Text("Sell", style: TextStyle(fontSize: 20, color: Colors.black87, fontWeight: FontWeight.bold)),
//                           Text("240", style: TextStyle(fontSize: 20, color: Colors.black87)),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 const Divider(),
//                 ListTile(
//                   leading: const Icon(Icons.phone),
//                   title: Text("Phone: ${profile.phone}"),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.location_on_outlined),
//                   title: Text("Gender: ${profile.gender}"),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.cake_outlined),
//                   title: Text("Birth Date: ${profile.birth}"),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.location_on),
//                   title: Text("Location: ${profile.location}"),
//                 ),
//
//                 const Divider(),
//                 const ListTile(
//                   leading: Icon(Icons.help_outline),
//                   title: Text("Help & Support"),
//                 ),
//                 ListTile(
//                   leading: const Icon(Icons.logout),
//                   title: const Text("Log out"),
//                   onTap: () => logout(context),
//                 ),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
import 'package:book/feature/Auth/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'edit_profile.dart';

class ProfileScreen extends StatelessWidget {
  final String uid;

  const ProfileScreen({super.key, required this.uid});
  static const String name = "/profile_screen";

  Future<UserProfileModel> getProfile() async {
    final doc = await FirebaseFirestore.instance.collection('Profile').doc(uid).get();
    return UserProfileModel.fromMap(doc.data()!);
  }

  Future<void> logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
backgroundColor: Colors.white,
      body: FutureBuilder<UserProfileModel>(
        future: getProfile(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snapshot.hasData || snapshot.hasError) {
            return const Center(child: Text('Profile not found.'));
          }

          final profile = snapshot.data!;

          return Column(
            children: [
              // Top dark section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 100),
                decoration: const BoxDecoration(
                  color: Colors.black87, // Dark green
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: 50,
                          backgroundImage: NetworkImage(profile.imageUrl.isNotEmpty
                              ? profile.imageUrl
                              : 'https://i.pravatar.cc/300'),
                        ),

                      ],
                    ),
                    const SizedBox(height: 10),
                    Text(profile.name, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(profile.phone, style: const TextStyle(color: Colors.white70)),
                  ],
                ),
              ),

              // Options List
              Expanded(
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                    boxShadow: const [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, 4)),
                    ],
                  ),
                  child: ListView(
                    children: [
                      const Text("Account Overview", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 20),

                      _buildTile(Icons.person_outline, "My Profile",(){
                        Navigator.pushNamed(context, '/edit_profile');
                      }),
                    
                      _buildTile(Icons.lock_outline, "Change Password",(){}),
                      _buildTile(Icons.language_outlined, "Change Language",(){}),
                      const SizedBox(height: 10),

                      ListTile(
                        leading: const Icon(Icons.logout),
                        title: const Text("Log out"),
                        onTap: () => logout(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTile(IconData icon, String title, VoidCallback onTap) {
    return Column(
      children: [
        ListTile(
          leading: Icon(icon),
          title: Text(title),
          trailing: const Icon(Icons.chevron_right),
          onTap: onTap, // now clickable
        ),
        const Divider(),
      ],
    );
  }

}
