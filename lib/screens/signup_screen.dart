import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/utils/utils.dart';
import 'package:instagram/widgets/text_field_input.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignScreenState();
}

class _SignScreenState extends State<SignupScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passcontroller = TextEditingController();
  final TextEditingController biocontroller = TextEditingController();
  final TextEditingController usernamecontroller = TextEditingController();
  Uint8List? image;
  bool islaoding = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passcontroller.dispose();
    biocontroller.dispose();
    usernamecontroller.dispose();
  }

  void selectimage() async {
    Uint8List im = await pickimage(ImageSource.gallery);
    setState(() {
      image = im;
    });
  }

  void signUpUser() async {
    setState(() {
      islaoding = true;
    });
    String res = await AuthMethods().signUpUser(
        email: emailcontroller.text,
        password: passcontroller.text,
        username: usernamecontroller.text,
        bio: biocontroller.text,
        file: image!);
    setState(() {
      islaoding = false;
    });
    if (res != "success") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    } else {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => ResponsiveLayoutScreen(
            mobilescreenlayout: MobileScreenLayout(),
            webscreenlayout: WebScreenLayout(),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/ic_instagram.svg',
                  height: 64,
                ),
                SizedBox(
                  height: 64,
                ),
                Stack(
                  children: [
                    image != null
                        ? CircleAvatar(
                            radius: 64, backgroundImage: MemoryImage(image!))
                        : CircleAvatar(
                            radius: 64,
                          ),
                    Positioned(
                      child: IconButton(
                        onPressed: selectimage,
                        icon: Icon(Icons.add_a_photo),
                      ),
                      bottom: -10,
                      left: 80,
                    ),
                  ],
                ),
                TextFieldInput(
                    hintText: 'enter your email',
                    textEditingController: emailcontroller,
                    textInputType: TextInputType.emailAddress),
                SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                    hintText: 'enter your username',
                    textEditingController: usernamecontroller,
                    textInputType: TextInputType.text),
                SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                    hintText: 'enter your bio',
                    textEditingController: biocontroller,
                    textInputType: TextInputType.multiline),
                SizedBox(
                  height: 24,
                ),
                TextFieldInput(
                  hintText: 'enter your email',
                  textEditingController: passcontroller,
                  textInputType: TextInputType.text,
                  ispass: true,
                ),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    child: islaoding
                        ? Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text('signup'),
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: ShapeDecoration(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        color: blueColor),
                  ),
                ),
                SizedBox(
                  height: 12,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        child: Text(
                          'donthave an account',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        child: Text(
                          'sign up ',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 8),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
