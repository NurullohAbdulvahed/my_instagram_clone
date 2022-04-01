import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:my_instagram_clone/model/users_model.dart';
import 'package:my_instagram_clone/service/auth_service.dart';
import 'package:my_instagram_clone/service/data_service.dart';
import 'package:my_instagram_clone/service/prefs_service.dart';
import 'package:my_instagram_clone/service/utils.dart';
import 'package:my_instagram_clone/viewes/textfield.dart';

import '../viewes/materialButton.dart';
import 'home_page.dart';
import 'signin_page.dart';

class SignUpPage extends StatefulWidget {
  static String id = "SignUpPage";
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController fullNameController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  void _callSignInPage(){
    Navigator.pushReplacementNamed(context, SignInPage.id);
  }

  void doSignUp(){
    String email = emailController.text.toString().trim();
    String name = fullNameController.text.toString().trim();
    String password = passwordController.text.toString().trim();
    String confirmPassword = confirmPasswordController.text.toString().trim();

    if(email.isEmpty || name.isEmpty ||password.isEmpty ||confirmPassword.isEmpty) return;
    Utils().isEmail(email);
    Utils().isPassword(password);
    if(confirmPassword != password) {
      Utils.fireToast("Password and confirm does not match");
      return;
    }


    setState(() {
      isLoading = true;
    });
    Users users = Users(fullName: name, email: email, password: password);
    AuthService.signUpUser(context, name, email, password,).then((value) => {
      _getFirebaseUser(users,value),
    });

  }
  void _getFirebaseUser(Users users,Map<String,User?> map)async{
    setState(() {
      isLoading = false;
    });
    User? firebaseUser;

    if(!(map.containsKey("SUCCESS"))){
      if(map.containsKey("ERROR_EMAIL_ALREADY_IN_USE")) {
        Utils.fireToast("Email already in use");
      }
      if(map.containsKey("ERROR")) {
        Utils.fireToast("Try again later");
      }
      return;
    }
    firebaseUser = map["SUCCESS"];
    if(firebaseUser == null) return;

    await Prefs.saveUserId(firebaseUser.uid);
    DataService.storeUser(users).then((value) => {
      Navigator.pushReplacementNamed(context, HomePage.id),
    });


  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Instagram",style: TextStyle(color: Colors.black,fontSize: 45,fontFamily: 'Billabong'),),
                          const SizedBox(height: 20,),
                          ///FullName
                          textField(hintText: "Fullname", controller: fullNameController,isHidden: false),
                          const SizedBox(height: 10,),
                          ///EMAIL
                          textField(hintText: "Email", controller: emailController,isHidden: false),
                          const SizedBox(height: 10,),
                          ///Password
                          textField(hintText: "Password",controller: passwordController,isHidden: true),
                          const SizedBox(height: 10,),
                          ///ConfirmPassword
                          textField(hintText: "Confirm Password", controller: confirmPasswordController,isHidden: true),
                          const SizedBox(height: 10,),

                          ///SIGNUp
                          materialButton(onPressed: () {
                            doSignUp();
                          }, title: 'Sign Up')
                        ],
                      )
                  ),
                  const Divider(
                    thickness: 1,
                    endIndent: 0,
                    indent: 0,
                  ),
                  const SizedBox(height: 10,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text("Already have an account?",style: TextStyle(color: Colors.grey,fontSize: 12),),
                      const SizedBox(width: 5,),
                      GestureDetector(
                        onTap: (){
                          _callSignInPage();
                        },
                        child: Text("Log in",style: TextStyle(color: Colors.blue.shade900,fontSize: 12,fontWeight: FontWeight.bold),),
                      )
                    ],
                  ),
                  const SizedBox(height: 20,),
                ],
              ),
            ),
          ),

          isLoading ? const Center(
            child: CircularProgressIndicator() ,
          ) : const SizedBox.shrink()
        ],
      )
    );
  }
}
