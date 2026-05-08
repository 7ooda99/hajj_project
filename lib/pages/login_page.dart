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
      backgroundColor: kMainColor,
      body: Center(
        child: Form(
          key: formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.001,
                ),
                const Image(
                  image: AssetImage(
                    "assets/images/logo.png",
                  ),
                  height: 200,
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.09,
                ),
                const Text(
                  'تسجيل الدخول',
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.03,
                ),
                CustomSignTextField(
                  obscureText: false,
                  lableText: 'Email',
                  prefixIcon: const Icon(Icons.email),
                  maxLines: 1,
                  onChange: (data) {
                    email = data;
                  },
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.02,
                ),
                CustomSignTextField(
                  suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isPassword = !isPassword;
                         
                        });
                      },
                      icon: Icon(
                        isPassword ? Icons.visibility : Icons.visibility_off,
                      ),),
                  obscureText: isPassword,
                  lableText: 'Password',
                  prefixIcon: const Icon(Icons.lock),
                  maxLines: 1,
                  onChange: (data) {
                    password = data;
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      child: const Text(
                        'انشاء حساب جديد',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'Cairo',
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterPage.id);
                      },
                    ),
                    const Text(
                      ' لايوجد لديك حساب؟',
                      style: TextStyle(fontSize: 14, color: Colors.black,fontFamily: 'Cairo'),
                    ),
                  ],
                ),
                SizedBox(
                  height: SizeConfig.screenHeight! * 0.14,
                ),
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

              ],
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
