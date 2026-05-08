import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../core/constants.dart';
import '../core/size_config.dart';
import '../helper/show_snack_bar.dart';
import 'home_page.dart';
import 'widgets/custom_button.dart';
import 'widgets/custom_text_field.dart';

// ignore: must_be_immutable
class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static String id = 'RegisterPage';

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  GlobalKey<FormState> formKey = GlobalKey();

  String? email;
  String? password;
  String? name;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
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
                    SizedBox(height: SizeConfig.screenHeight! * 0.05),

                    // Logo
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
                        height: 160,
                      ),
                    ),

                    SizedBox(height: SizeConfig.screenHeight! * 0.04),

                    // Title
                    Text(
                      'تسجيل حساب جديد',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: kSecondaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'أنشئ حسابك للبدء',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 14,
                        color: Colors.grey[500],
                      ),
                    ),

                    SizedBox(height: SizeConfig.screenHeight! * 0.04),

                    // Name field
                    CustomSignTextField(
                      obscureText: false,
                      lableText: 'الاسم الكامل بالعربي',
                      prefixIcon: Icon(Icons.person_outline_rounded, color: kSecondaryColor),
                      maxLines: 1,
                      onChange: (data) {
                        name = data;
                      },
                    ),
                    const SizedBox(height: 14),

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
                      obscureText: false,
                      lableText: 'كلمة المرور',
                      prefixIcon: Icon(Icons.lock_outline_rounded, color: kSecondaryColor),
                      maxLines: 1,
                      onChange: (data) {
                        password = data;
                      },
                    ),

                    const SizedBox(height: 8),

                    // Login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          child: Text(
                            'سجل الدخول',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: kSecondaryColor,
                              decoration: TextDecoration.underline,
                              decorationColor: kSecondaryColor,
                            ),
                          ),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'يوجد لديك حساب ؟',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[600],
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: SizeConfig.screenHeight! * 0.08),

                    // Register button
                    CustomButton(
                      text: 'تسجيل',
                      color: kSecondaryColor,
                      onTap: () async {
                        if (formKey.currentState!.validate()) {
                          isLoading = true;
                          setState(() {});
                          try {
                            await registerUser();
                            Get.offAll(HomePage());
                            showSnackBar(context, 'success');
                          } on FirebaseAuthException catch (ex) {
                            if (ex.code == 'weak-password') {
                              showSnackBar(context, 'weak password');
                            } else if (ex.code == 'email-already-in-use') {
                              showSnackBar(context, 'email alredy exists');
                            }
                          } catch (ex) {
                            showSnackBar(context, 'there was an error');
                          }

                          isLoading = false;
                          setState(() {});
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
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );

    User? firebaseUser = userCredential.user;

    if (firebaseUser != null) {
      await FirebaseFirestore.instance.collection('users').doc(firebaseUser.uid).set({
        'email': email,
        'name': name,
        'role': 'user', // default role
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
  }

}
