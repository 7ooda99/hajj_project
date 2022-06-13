import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../core/constants.dart';
import '../core/size_config.dart';
import '../helper/show_snack_bar.dart';
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
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
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
                    'تسجيل حساب جديد',
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
                      obscureText: false,
                      lableText: 'Password',
                      prefixIcon: const Icon(Icons.lock),
                      maxLines: 1,
                      onChange: (data) {
                        password = data;
                      }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(
                        child: const Text(
                          'سجل الدخول',
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 16,
                            color: Colors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      const Text(
                        'يوجد لديك حساب ؟',
                        style: TextStyle(fontSize: 14, color: Colors.black,fontFamily: 'Cairo'),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight! * 0.14,
                  ),
                  CustomButton(
                    text: 'تسجيل',
                    color: kSecondaryColor,
                    onTap: () async {
                      if (formKey.currentState!.validate()) {
                        isLoading = true;
                        setState(() {});
                        try {
                          await registerUser();
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> registerUser() async {
    UserCredential user =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}
