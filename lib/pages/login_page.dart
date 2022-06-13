import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:syrian_hajj_project/core/constants.dart';
import 'package:syrian_hajj_project/core/size_config.dart';
import 'package:syrian_hajj_project/pages/airport_page.dart';
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
                      isLoading = true;
                      setState(() {});
                      try {
                        await loginUser();
                        Navigator.pushNamed(context, AirportPage.id);
                      } on FirebaseAuthException catch (ex) {
                        if (ex.code == 'user-not-found') {
                          showSnackBar(
                              context, 'No user found for that email.');
                        } else if (ex.code == 'wrong-password') {
                          showSnackBar(context,
                              'Wrong password provided for that user.');
                        }
                      } catch (ex) {
                        showSnackBar(context, 'there was an error');
                      }
                      isLoading = false;

                      setState(() {});
                    } else {}
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
    UserCredential user =
        await FirebaseAuth.instance.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
