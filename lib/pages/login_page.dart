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
      body: Stack(
        children: [
          Container(
            height: SizeConfig.screenHeight! * 0.45,
            decoration: const BoxDecoration(
              color: kMainColor,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
          ),
          SafeArea(
            child: Form(
              key: formKey,
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: SizeConfig.screenHeight! * 0.04),
                    const Image(
                      image: AssetImage("assets/images/logo.png"),
                      height: 140,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'لجنة الحج العليا السورية',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: SizeConfig.screenHeight! * 0.04),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 24),
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'تسجيل الدخول',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 20),
                          CustomSignTextField(
                            obscureText: false,
                            lableText: 'Email',
                            prefixIcon: const Icon(Icons.email_outlined),
                            maxLines: 1,
                            onChange: (data) => email = data,
                          ),
                          const SizedBox(height: 14),
                          CustomSignTextField(
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => isPassword = !isPassword),
                              icon: Icon(isPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                            obscureText: isPassword,
                            lableText: 'Password',
                            prefixIcon: const Icon(Icons.lock_outline),
                            maxLines: 1,
                            onChange: (data) => password = data,
                          ),
                          const SizedBox(height: 24),
                          CustomButton(
                            text: 'دخول',
                            color: kSecondaryColor,
                            onTap: () async {
                              if (formKey.currentState!.validate()) {
                                isLoading = true;
                                setState(() {});
                                try {
                                  await loginUser();
                                  Get.offAll(HomePage());
                                } on FirebaseAuthException catch (ex) {
                                  if (ex.code == 'user-not-found') {
                                    showSnackBar(context, 'No user found for that email.');
                                  } else if (ex.code == 'wrong-password') {
                                    showSnackBar(context, 'Wrong password provided for that user.');
                                  }
                                } catch (ex) {
                                  showSnackBar(context, 'there was an error');
                                }
                                isLoading = false;
                                setState(() {});
                              }
                            },
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              TextButton(
                                child: const Text(
                                  'انشاء حساب جديد',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: 'Cairo',
                                    color: kSecondaryColor,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                                onPressed: () => Navigator.pushNamed(context, RegisterPage.id),
                              ),
                              const Text(
                                'لا يوجد لديك حساب؟',
                                style: TextStyle(fontSize: 13, color: Colors.black54, fontFamily: 'Cairo'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> loginUser() async {
    UserCredential user =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
