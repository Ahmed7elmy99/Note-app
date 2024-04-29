import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';

import 'package:flutter_svg/svg.dart';
import 'package:glass_login/components/crud.dart';
import 'package:glass_login/components/valid.dart';
import 'package:glass_login/constant/linkapi.dart';
import 'package:glass_login/utils/utils.dart';

import '../../utils/app_colors.dart';
import '../../utils/styles/text_field_style.dart';

class SingUpScreen extends StatefulWidget {
  const SingUpScreen({super.key, required this.controller});
  final PageController controller;
  @override
  State<SingUpScreen> createState() => _SingUpScreenState();
}

class _SingUpScreenState extends State<SingUpScreen> with Crud {
  //Crud _crud = Crud();

  bool isLoading = false;
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _phoneController = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey();
  signUp() async {
    if (formstate.currentState!.validate()) {
      // loadingDialog(context);
      //  isLoading = true;
      // setState(() {});
      var response = await postRequest(linkSignUp, {
        "username": _nameController.text,
        "email": _emailController.text,
        "password": _passController.text,
        "phone": _phoneController.text
      });
      // Navigator.of(context).pop();
      // isLoading = false;
      //  setState(() {});
      if (response != null && response['status'] == "success") {
        loadingDialog(context);
        Future.delayed(const Duration(seconds: 2)).then((value) =>
            Navigator.of(context)
                .pushNamedAndRemoveUntil("success", (route) => false));
        // Navigator.of(context) .pushNamedAndRemoveUntil("success", (route) => false);
        FocusManager.instance.primaryFocus?.unfocus();
        // widget.controller.animateToPage(0,
        //   duration: const Duration(milliseconds: 100),
        //  curve: Curves.ease);
      } else {
        //  loadingDialog(context);
        FocusManager.instance.primaryFocus?.unfocus();

        AwesomeDialog(
            context: context,
            title: "تنبيه",
            body: Text("Email Or Phone Already Exist"))
          ..show();
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
            Positioned(
              right: (MediaQuery.sizeOf(context).width / 2) - 150,
              top: 60,
              child: Transform.rotate(
                angle: -pi * 0,
                child: SvgPicture.asset(
                  'assets/svgs/medition_with_box.svg',
                  width: 300,
                ),
              ),
            ),
            // Positioned(
            //   right: 10,
            //   top: 300,
            //   child: Transform.rotate(
            //     angle: -pi * 0.1,
            //     child: Image.asset(
            //       'assets/pngs/drugs.png',
            //       width: 80,
            //     ),
            //   ),
            // ),
            Positioned(
              right: 100,
              bottom: 30,
              child: Transform.rotate(
                angle: -pi * 0.04,
                child: Image.asset(
                  'assets/pngs/cardiogram.png',
                  width: 200,
                ),
              ),
            ),
            Positioned(
              left: 30,
              right: 30,
              bottom: 30,
              // padding: const EdgeInsets.all(30),
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: AppColors.whiteColor.withOpacity(.8),
                ),
                child: Form(
                  key: formstate,
                  child: Column(
                    textDirection: TextDirection.ltr,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sign up',
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
                        controller: _emailController,
                        validator: (val) {
                          return validInput(val!, 3, 20);
                        },
                        style: textFieldTextStyle(),
                        decoration: textFieldDecoration('Email'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        controller: _nameController,
                        validator: (val) {
                          return validInput(val!, 3, 20);
                        },
                        style: textFieldTextStyle(),
                        decoration: textFieldDecoration('Full Name'),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: TextFormField(
                                obscureText: true,
                                controller: _passController,
                                validator: (val) {
                                  return validInput(val!, 3, 20);
                                },
                                style: textFieldTextStyle(),
                                decoration: textFieldDecoration('Password')),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextFormField(
                              validator: (val) {
                                return validInput(val!, 11, 30);
                              },
                              controller: _phoneController,
                              obscureText: false,
                              style: textFieldTextStyle(),
                              decoration: textFieldDecoration('phone'),
                            ),
                          ),
                        ],
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
                            //   await  isLoading==true? loadingDialog(context):null;

                            await signUp();
                          },
                          child: const Text("Create account"),
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Row(
                        children: [
                          Text(
                            ' have an account?',
                            textAlign: TextAlign.center,
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
                              widget.controller.animateToPage(0,
                                  duration: const Duration(milliseconds: 500),
                                  curve: Curves.ease);
                            },
                            child: Text(
                              'Log In ',
                              style: TextStyle(
                                color: AppColors.primaryHighContrast,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
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
