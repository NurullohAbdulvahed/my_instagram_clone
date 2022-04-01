import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_instagram_clone/model/post_model.dart';
import 'package:my_instagram_clone/service/utils.dart';

import '../model/bottom_sheet_model.dart';
import '../service/auth_service.dart';

class SettingsPage extends StatefulWidget {
  static String id = "SettingsPage";
  const SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  void _actionLogOut()async{
    var result = await Utils.dialogCommon(context, "Instagram Clone", "Do you want to logout?", false);
    if(result != null && result){
      AuthService.signOutUser(context);
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: const Icon(Icons.arrow_back,color: Colors.black,),
        title: const Text("Settings",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 20,right: 10,top: 20,bottom: 20),
        child:Column(
          children: [

            ///Settings
            Container(
              height: MediaQuery.of(context).size.height*0.05,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200),
              child: const TextField(
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Search",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search,color: Colors.grey,)
                ),
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: BottomSheetClass.settingsPageBottomSheetList.length,
              itemBuilder: (context,index){
                return Container(
                  margin:const EdgeInsets.only(top: 25),
                  child: Row(
                    children: [
                      BottomSheetClass.settingsPageBottomSheetList[index].iconData!,
                      const SizedBox(width: 10,),
                      Text(BottomSheetClass.settingsPageBottomSheetList[index].iconName!)
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 35,),
            Row(
              children: const [
                Icon(FontAwesomeIcons.infinity,color: Colors.blue,),
                SizedBox(width: 10,),
                Text("Meta",style: TextStyle(color: Colors.black),)
              ],
            ),
            const SizedBox(height: 10,),
            const Align(
              alignment: Alignment.topLeft,
                child: Text("Accounts Center",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),)),
            const SizedBox(height: 10,),
            const Align(
                alignment: Alignment.topLeft,
                child: Text("Control settings for connetced experiences across Instagram,the Facebook app and Messenger,including story and post sharing and logging in",style: TextStyle(color: Colors.grey,fontWeight: FontWeight.bold),textAlign: TextAlign.start,)),
            const SizedBox(height: 20,),
            const Align(
                alignment: Alignment.topLeft,
                child: Text("Logins",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),)),
            const SizedBox(height: 20,),
            const Align(
                alignment: Alignment.topLeft,
                child: Text("Add account",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),)),
            const SizedBox(height: 20,),
            Align(
                alignment: Alignment.topLeft,
                child: GestureDetector(
                    onTap: () {
                      _actionLogOut();

                    },
                    child: const Text("Log out",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold),)))
          ],
        ),
      ),
    );
  }
}
