import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:syrian_hajj_project/core/constants.dart';
import 'package:syrian_hajj_project/core/size_config.dart';
import 'package:syrian_hajj_project/pages/airport_page.dart';
import 'package:syrian_hajj_project/pages/home_page.dart';
import 'package:syrian_hajj_project/pages/register.dart';
import 'package:syrian_hajj_project/pages/widgets/custom_button.dart';
import 'package:syrian_hajj_project/pages/widgets/custom_text_field.dart';

import '../helper/show_snack_bar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String id = 'LoginPage';

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  String? email;
  bool isPassword = true;

  String? password;
  GlobalKey<FormState> formKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              kSecondaryColor.withOpacity(0.10),
              Colors.white,
              Colors.white,
              kSecondaryColor.withOpacity(0.05),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: const [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Center(
          child: Form(
            key: formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight! * 0.06),

                  // Logo with subtle shadow
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: kMainColor.withOpacity(0.25),
                          blurRadius: 40,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Image(
                      image: AssetImage("assets/images/logo.png"),
                      height: 180,
                    ),
                  ),

                  SizedBox(height: SizeConfig.screenHeight! * 0.05),

                  // Title
                  Text(
                    'تسجيل الدخول',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: kSecondaryColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'مرحباً بعودتك',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 14,
                      color: Colors.grey[500],
                    ),
                  ),

                  SizedBox(height: SizeConfig.screenHeight! * 0.04),

                  // Email field
                  CustomSignTextField(
                    obscureText: false,
                    lableText: 'البريد الإلكتروني',
                    prefixIcon: Icon(Icons.email_outlined, color: kSecondaryColor),
                    maxLines: 1,
                    onChange: (data) {
                      email = data;
                    },
                  ),
                  const SizedBox(height: 14),

                  // Password field
                  CustomSignTextField(
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPassword = !isPassword;
                        });
                      },
                      icon: Icon(
                        isPassword
                            ? Icons.visibility_outlined
                            : Icons.visibility_off_outlined,
                        color: Colors.grey[600],
                      ),
                    ),
                    obscureText: isPassword,
                    lableText: 'كلمة المرور',
                    prefixIcon: Icon(Icons.lock_outline_rounded, color: kSecondaryColor),
                    maxLines: 1,
                    onChange: (data) {
                      password = data;
                    },
                  ),

                  const SizedBox(height: 8),

                  // Register link
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: Text(
                          'انشاء حساب جديد',
                          style: TextStyle(
                            fontSize: 14,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                            color: kSecondaryColor,
                            decoration: TextDecoration.underline,
                            decorationColor: kSecondaryColor,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, RegisterPage.id);
                        },
                      ),
                      Text(
                        ' لايوجد لديك حساب؟',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: SizeConfig.screenHeight! * 0.08),

                  // Login button
                  CustomButton(
                    text: 'دخول',
                    color: kSecondaryColor,
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        setState(() => isLoading = true);
                        try {
                          await loginUser();

                          String uid = FirebaseAuth.instance.currentUser!.uid;
                          String role = await getUserRole(uid);

                          if (role == 'admin') {
                            Get.offAll(HomePage()); // Navigate to admin-specific homepage
                          } else {
                            Get.offAll(HomePage()); // Regular user homepage
                          }

                        } on FirebaseAuthException catch (ex) {
                          if (ex.code == 'user-not-found') {
                            showSnackBar(context, 'No user found for that email.');
                          } else if (ex.code == 'wrong-password') {
                            showSnackBar(context, 'Wrong password provided.');
                          } else {
                            showSnackBar(context, 'Authentication error.');
                          }
                        } catch (ex) {
                          showSnackBar(context, 'Unexpected error.');
                        } finally {
                          setState(() => isLoading = false);
                        }
                      }
                    },
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential userCredential =
    await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );

    User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      await handleUserProfile(firebaseUser);
    }
  }

  Future<void> handleUserProfile(User firebaseUser) async {
    final userDocRef =
    FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid);

    final docSnapshot = await userDocRef.get();

    if (!docSnapshot.exists) {
      // First-time login, create a new user profile
      await userDocRef.set({
        'email': firebaseUser.email,
        'role': 'user', // default role, adjust manually in Firestore for admins
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    // User profile exists or has been created, proceed normally
  }

  Future<String> getUserRole(String uid) async {
    final docSnapshot =
    await FirebaseFirestore.instance.collection('users').doc(uid).get();
    return docSnapshot.data()?['role'] ?? 'user';
  }


}
