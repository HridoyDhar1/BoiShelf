//
// import 'package:book/core/widget/custom_passwordfield.dart';
// import 'package:book/feature/Auth/presentation/screen/forget.dart';
// import 'package:book/feature/sell/presentation/widget/text_field.dart';
// import 'package:connectivity_plus/connectivity_plus.dart';
// import 'package:flutter/gestures.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import '../../../../core/constant/app_color.dart';
// import '../../../../core/widget/custom_button.dart';
// import '../../../../navigation.dart';
//
//
//
//
// class LoginScreen extends StatefulWidget {
//   static const String name = '/login';
//
//   const LoginScreen({super.key});
//
//   @override
//   State<LoginScreen> createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();
//   final TextEditingController newPasswordController = TextEditingController();
//   bool showNewPasswordField = false;
//   bool isConnected = true;
//   @override
//   void initState() {
//     super.initState();
//     _checkInternetConnection();
//   }
//   //check internet connection
//     _checkInternetConnection() async {
//     var connectivityResult = await (Connectivity().checkConnectivity());
//     if (connectivityResult == ConnectivityResult.none) {
//       setState(() {
//         isConnected = false;
//       });
//     } else {
//       setState(() {
//         isConnected = true;
//       });
//     }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SingleChildScrollView(
//         child: SafeArea(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 24),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 // Image.asset(AssetImages.appLogo,height: 300,width: 200,),
//                 //
//                 const SizedBox(height: 40),
// CustomTextField(controller: emailController, label: "Email",prefixIcon: Icon(Icons.email),),
//                 const SizedBox(height: 20),
//                 CustomPasswordField(valid: "", controller: passwordController,         icons: Icons.lock,
//                   surfixIcons: Icons.visibility,
//                   hintText: "Password",
//                   keyboard: TextInputType.text),
//                 const SizedBox(height: 20),
//
//                 // Show new password field only after reset
//                 if (showNewPasswordField)
//                   CustomPasswordField(
//                     hintText: 'New Password',
//                     valid: "Enter new password",
//                     controller: newPasswordController,
//                     icons: Icons.lock_outline,
//                     keyboard: TextInputType.text,
//                   ),
//
//                 const SizedBox(height: 40),
//
//                 const SizedBox(height: 20),
//                 CustomElevatedButton(buttonName: 'Login', onPressed: () { Get.toNamed(CustomNavigationScreen.name); },),
//                 const SizedBox(height: 10),
//                 Align(
//                   alignment: Alignment.centerLeft,
//                   child: TextButton(
//                     onPressed: () {
//                       Get.toNamed(ForgetPasswordScreen.name);
//                     },
//                     child: const Text(
//                       "Forgot Password",
//                       style: TextStyle(color: Colors.red),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(height: 20),
//                 RichText(
//                   text: TextSpan(
//                     text: "Don’t have an account? ",
//                     style: const TextStyle(color: Colors.black87),
//                     children: [
//                       TextSpan(
//                         text: "Sign Up",
//                         style: const TextStyle(
//                           color: AppColors.accentColor,
//                           fontWeight: FontWeight.bold,
//                         ),
//                         recognizer: TapGestureRecognizer()
//                           ..onTap = () {
//                             Get.toNamed("signup");
//                           },
//                       ),
//                     ],
//                   ),
//                 ),
//
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
