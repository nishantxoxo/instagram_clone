import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:instagram/resources/auth_methods.dart';
import 'package:instagram/responsive/mobile_screen_layout.dart';
import 'package:instagram/responsive/responsive_layout_screen.dart';
import 'package:instagram/responsive/web_screen_layout.dart';
import 'package:instagram/screens/signup_screen.dart';
import 'package:instagram/utils/colors.dart';
import 'package:instagram/widgets/text_field_input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailcontroller = TextEditingController();
  final TextEditingController passcontroller = TextEditingController();
  bool islaoding = false;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    emailcontroller.dispose();
    passcontroller.dispose();
  }

  void loginuser() async {
    setState(() {
      islaoding = true;
    });
    String res = await AuthMethods()
        .loginuser(email: emailcontroller.text, password: passcontroller.text);
    setState(() {
      islaoding = false;
    });
    if (res != "success") {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(res)));
    } else {
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => ResponsiveLayoutScreen(
              mobilescreenlayout: const MobileScreenLayout(),
              webscreenlayout: const WebScreenLayout())));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          width: double.infinity,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Flexible(flex: 2, child: Container(),),
              SvgPicture.asset(
                'assets/ic_instagram.svg',
                height: 64,color: primaryColor,
              ),
              const SizedBox(
                height: 64,
              ),
              TextFieldInput(
                  hintText: 'enter your email',
                  textEditingController: emailcontroller,
                  textInputType: TextInputType.emailAddress),
              const SizedBox(
                height: 24,
              ),
              TextFieldInput(
                hintText: 'enter your password',
                textEditingController: passcontroller,
                textInputType: TextInputType.text,
                ispass: true,
              ),
              const SizedBox(
                height: 24,
              ),
              InkWell(
                onTap: loginuser,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: ShapeDecoration(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      color: blueColor),
                  child: islaoding
                      ? const Center(child: CircularProgressIndicator())
                      : const Text('login'),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Flexible(flex: 2, child: Container(),),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'dont have an account ',
                        //style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: ()=> Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => SignupScreen(),)),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text(
                        'sign up ',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
