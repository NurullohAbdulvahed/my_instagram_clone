import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_instagram_clone/model/users_model.dart';
import 'package:my_instagram_clone/pages/likes_page.dart';
import '../service/data_service.dart';
import '../service/utils.dart';
import 'my_feed_page.dart';
import 'my_likes_page.dart';
import 'my_profile_page.dart';
import 'my_search_page.dart';
import 'my_upload_page.dart';



class HomePage extends StatefulWidget {
  static String id = "HomePage";
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PageController? _pageController;
  int _currentTap = 0;
  Users? users;

  _initNotification(){
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if(mounted) {
        Utils.showLocalNotification(message, context);
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if(mounted) {
        Utils.showLocalNotification(message, context);
      }
    });
  }

  void _apiLoadUser() async {
    await DataService.loadUser().then((value) => {
      _showUserInfo(value),
    });

  }

  void _showUserInfo(Users user){
   if(mounted){
     setState(() {
       users = user;
     });
   }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initNotification();
    _apiLoadUser();
    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const[
          MyFeedPage(),
          MySearchPage(),
          MyUploadPage(),
          MyLikesPage(),
          MyProfilePage(),
        ],
        onPageChanged: (int index){
          setState(() {
            _currentTap = index;
          });
        },
      ),
      bottomNavigationBar: CupertinoTabBar(
        backgroundColor: Colors.white,
        onTap: (int index){
          setState(() {
            _currentTap = index;
            _pageController?.animateToPage(index, duration: const Duration(microseconds: 200), curve: Curves.easeIn);

          });
        },
        currentIndex: _currentTap,
        activeColor: Colors.black,
        items: [
          const BottomNavigationBarItem(
              icon: Icon(Icons.home,size: 30,),
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.search,size: 30),
          ),
          // BottomNavigationBarItem(
          //   icon: Icon(Icons.add_box_outlined,size: 35,color: Colors.black,),
          // ),
          const BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.plus_app,size: 30,)
          ),
           const BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.heart,size: 25,),
          ),
          BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundImage: users?.imgUrl == null ? (const AssetImage("assets/images/ic_person.png")) as ImageProvider : NetworkImage(users!.imgUrl!),
              radius: 15,
            )
          ),
        ],
      ),
    );
  }
}
