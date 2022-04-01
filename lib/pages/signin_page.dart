import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_instagram_clone/service/auth_service.dart';
import 'package:my_instagram_clone/service/prefs_service.dart';
import 'package:my_instagram_clone/service/utils.dart';
import 'package:my_instagram_clone/viewes/materialButton.dart';
import 'package:my_instagram_clone/viewes/textfield.dart';
import 'home_page.dart';
import 'signup_page.dart';

class SignInPage extends StatefulWidget {
  static String id = "SignInPage";

  const SignInPage({Key? key}) : super(key: key);

  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  var emailController = TextEditingController();
  bool isLoading = false;
  var passwordController = TextEditingController();

  void _callSignUpPage() {
    Navigator.pushReplacementNamed(context, SignUpPage.id);
  }

  void doLogin() {
    String email = emailController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    if (email.isEmpty || password.isEmpty) return;
   Utils().isEmail(email);
    Utils().isPassword(password);
    setState(() {
      isLoading = true;
    });
    AuthService.signInUser(context, email, password).then((value) => {
          _getFirebaseUser(value),
        });
  }

  void _getFirebaseUser(Map<String, User?> map) async {
   if(mounted){
     setState(() {
       isLoading = false;
     });
   }
    User? user;
    if (!(map.containsKey("SUCCESS"))) {
      if (map.containsKey("ERROR")) {
        Utils.fireToast("Check your email or password");
        return;
      }
    }
    user = map["SUCCESS"];
    if (user == null) return;
    await Prefs.saveUserId(user.uid);
    if(mounted){
      Navigator.pushReplacementNamed(context, HomePage.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
      children: [
        SingleChildScrollView(
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                    child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Instagram",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 45,
                            fontFamily: 'Billabong'),
                      ),
                      const SizedBox(
                        height: 20,
                      ),

                      ///EMAIL
                      textField(
                          hintText: "Email",
                          isHidden: false,
                          controller: emailController),
                      const SizedBox(
                        height: 10,
                      ),

                      ///Password
                      textField(
                          hintText: "Password",
                          isHidden: true,
                          controller: passwordController),
                      const SizedBox(
                        height: 10,
                      ),

                      ///SIGNIn
                      materialButton(title: "Log in", onPressed: doLogin),
                      const SizedBox(
                        height: 20,
                      ),

                      ///Forgot
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            'Forgot your login details?',
                            style: TextStyle(color: Colors.grey, fontSize: 12),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Get help loggin in.",
                            style: TextStyle(
                                color: Colors.blue.shade900,
                                fontWeight: FontWeight.bold,
                                fontSize: 12),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),

                      ///OR
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width * 0.35,
                            color: Color(0xffA2A2A2),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const Text(
                            "OR",
                            style: TextStyle(),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          Container(
                            height: 1,
                            width: MediaQuery.of(context).size.width * 0.35,
                            color: Color(0xffA2A2A2),
                          ),
                        ],
                      ),

                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: const [
                          CircleAvatar(
                            backgroundColor: Colors.blue,
                            radius: 20,
                            child: Icon(
                              FontAwesomeIcons.facebookF,
                              color: Colors.white,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            "Log in with Facebook",
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      )
                    ],
                  ),
                )),
                const Divider(
                  thickness: 1,
                  endIndent: 0,
                  indent: 0,
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        "Don`t have an account?",
                        style: TextStyle(color: Colors.grey, fontSize: 12),
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      GestureDetector(
                        onTap: _callSignUpPage,
                        child: Text(
                          "Sign Up",
                          style: TextStyle(
                              color: Colors.blue.shade900,
                              fontSize: 12,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
              ],
            ),
          ),
        ),
        isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : SizedBox.shrink()
      ],
    ));
  }
}
