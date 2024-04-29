import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:glass_login/components/crud.dart';
import 'package:glass_login/components/valid.dart';
import 'package:glass_login/constant/linkapi.dart';

import 'package:glass_login/main.dart';

import '../../utils/app_colors.dart';
import '../../utils/styles/text_field_style.dart';
import '../../utils/utils.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({
    super.key,
    required this.controller,
  });
  final PageController controller;
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with Crud {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  //Crud _crud = Crud();

  login() async {
    if (formstate.currentState!.validate()) {
      if (formstate.currentState!.validate()) {
        //  isLoading = true;
        // setState(() {});
        var response = await postRequest(linkLogin, {
          "email": _emailController.text,
          "password": _passController.text,
        });
        // isLoading = false;
        //  setState(() {});
        if (response != null && response['status'] == "success") {
          // Navigator.of(context) .pushNamedAndRemoveUntil("success", (route) => false);
          sharedPref.setString("id", response['data']['id'].toString());
          sharedPref.setString("username", response['data']['username']);
          sharedPref.setString("email", response['data']['email']);
          loadingDialog(context);
          FocusManager.instance.primaryFocus?.unfocus();
          Future.delayed(const Duration(seconds: 2)).then((value) =>
              Navigator.of(context)
                  .pushNamedAndRemoveUntil("home", (route) => false));
        } else {
          FocusManager.instance.primaryFocus?.unfocus();

       AwesomeDialog(
          context: context,
              title: "تنبيه",
              body: Text(
                  "البريد الالكتروني او كلمة المرور خطأ او الحساب غير موجود"))
            ..show();
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SizedBox.fromSize(
        size: MediaQuery.sizeOf(context),
        child: Stack(
          children: [
            // Positioned(
            //   right: 40,
            //   top: 140,
            //   child: Transform.rotate(
            //     angle: pi * .1,
            //     child: Image.asset(
            //       'assets/pngs/medical.png',
            //       width: 60,
            //     ),
            //   ),
            // ),
            Positioned(
              left: 80,
              top: 300,
              child: Transform.rotate(
                angle: -pi * 0.05,
                child: Image.asset(
                  'assets/pngs/health-care.png',
                  width: 50,
                ),
              ),
            ),
            // Positioned(
            //   right: 10,
            //   bottom: 20,
            //   child: Transform.rotate(
            //     angle: -pi * 0.14,
            //     child: Image.asset(
            //       'assets/pngs/antibiotic.png',
            //       width: 120,
            //     ),
            //   ),
            // ),
            Positioned(
              left: -50,
              top: 10,
              child: SvgPicture.asset(
                'assets/svgs/pills.svg',
                width: 300,
              ),
            ),
            Positioned(
              // padding: const EdgeInsets.all(30),
              bottom: 30,
              left: 30,
              right: 30,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.whiteColor.withOpacity(.8),
                ),
                child: Form(
                  key: formstate,
                  child: Column(
                    // padding: const EdgeInsets.symmetric(horizontal: 50),
                    children: [
                      Text(
                        'Log In',
                        style: TextStyle(
                          color: AppColors.primaryHighContrast,
                          fontSize: 27,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        validator: (val) {
                          return validInput(val!, 3, 20);
                        },
                        controller: _emailController,
                        style: textFieldTextStyle(),
                        decoration: textFieldDecoration('Email'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        obscureText: true,
                        validator: (val) {
                          return validInput(val!, 3, 20);
                        },
                        focusNode: FocusNode(
                          canRequestFocus: true,
                        ),
                        controller: _passController,
                        style: textFieldTextStyle(),
                        decoration: textFieldDecoration('Password'),
                      ),
                      const SizedBox(
                        height: 25,
                      ),
                      FractionallySizedBox(
                        widthFactor: 1,
                        child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: AppColors.primaryColor,
                              foregroundColor: AppColors.whiteColor,
                            ),
                            onPressed: () async {
                              login();
                            },
                            child: const Text("Sign In")),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            'Don’t have an account?',
                            style: TextStyle(
                              color: AppColors.primaryDark,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(
                            width: 2.5,
                          ),
                          InkWell(
                            onTap: () {
                              FocusManager.instance.primaryFocus?.unfocus();
                              widget.controller.animateToPage(1,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            },
                            child: Text(
                              'Sign Up',
                              style: TextStyle(
                                color: AppColors.primaryHighContrast,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Text(
                        'Forget Password?',
                        style: TextStyle(
                          color: AppColors.primaryHighContrast,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
