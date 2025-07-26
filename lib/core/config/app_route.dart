import 'package:book/core/config/controller_binding.dart';
import 'package:book/feature/Auth/presentation/screen/create_profile.dart';
import 'package:book/feature/Auth/presentation/screen/forget.dart';
import 'package:book/feature/Auth/presentation/screen/login_screen.dart';
import 'package:book/feature/Auth/presentation/screen/reset.dart';
import 'package:book/feature/Auth/presentation/screen/signup_screen.dart';
import 'package:book/feature/Auth/presentation/screen/verification.dart';
import 'package:book/feature/Chat/presentation/chat_list.dart';
import 'package:book/feature/Chat/presentation/chat_screen.dart';
import 'package:book/feature/Saved/presentaion/screen/save_screen.dart';

import 'package:book/feature/explore/presentation/screen/explore_screen.dart';
import 'package:book/feature/home/presentation/screen/home_screen.dart';
import 'package:book/feature/profile/presentation/screen/edit_profile.dart';
import 'package:book/feature/profile/presentation/screen/profile_screen.dart';
import 'package:book/feature/sell/presentation/screen/sell_book.dart';
import 'package:book/navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';



class BookBuyApp extends StatelessWidget {
  const BookBuyApp({super.key});

  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      initialBinding: ControllerBinding(),
      initialRoute: '/login',
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: '/login', page:()=> LoginScreen()),
        GetPage(name: '/signup', page:()=> SignupScreen()),
        GetPage(name: '/forgetpassword', page:()=> ForgetPasswordScreen()),
        GetPage(name: "/verification", page:()=> VerificationCodeScreen()),
        GetPage(name: "/resetpass", page:()=> ResetPasswordScreen()),
        GetPage(name: '/home_screen', page: () => HomeScreen()),
        GetPage(name: '/navigation', page: () => CustomNavigationScreen()),
        GetPage(name: "/explore_screen", page: () => ExploreScreen()),
        GetPage(name: "/sell_book", page: () => SellBookScreen()),
        GetPage(name: "/chat_list", page: ()=>ChatListScreen()),
        GetPage(name: "/chat_screen", page: (){
          return   ChatScreen(

            receiverId: Get.arguments['receiverId'],
            receiverName: Get.arguments['receiverName'],
            receiverImage: Get.arguments['receiverImage'],
            postData: Get.arguments['postData']??{},);
        }
        ),
        GetPage(name: "/create_profile", page: ()=>CreateProfileScreen()),
        GetPage(name: "/profile_screen", page: ()=>ProfileScreen(uid: FirebaseAuth.instance.currentUser!.uid)),
        GetPage(name: "/save", page: ()=>SaveScreen()),
        GetPage(name: "/edit_profile", page: ()=>EditProfileScreen())
      ],
    );
  }
}
