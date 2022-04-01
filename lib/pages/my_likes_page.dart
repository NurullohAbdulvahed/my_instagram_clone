import 'package:flutter/material.dart';
import 'package:my_instagram_clone/model/users_model.dart';

import '../model/post_model.dart';
import '../service/data_service.dart';


class MyLikesPage extends StatefulWidget {
  static String id = "MyLikesPage";
  const MyLikesPage({Key? key}) : super(key: key);

  @override
  _MyLikesPageState createState() => _MyLikesPageState();
}

class _MyLikesPageState extends State<MyLikesPage> {
bool isLoading =false;
List<Users> items = [];


void _apiLoadLikers() async {
    setState(() {
      isLoading = true;
    });
    await DataService.loadLikers().then((users) => {
      print(users.toString()),
      _resLoadLikers(users)
    });
  }

  void _resLoadLikers(List<Users> users) {
    if(mounted){
      setState(() {
        isLoading = false;
        items = users;
      });
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadLikers();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text("Activity",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 20),),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(left: 15,right: 15,top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children:  [
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: const [
                    Text("New",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                  ],
                ),
                const SizedBox(height: 10,),

                ///NEW liked you
                ListView.builder(
                    shrinkWrap: true,
                    physics: const ScrollPhysics(),
                    itemCount: items.length,
                    itemBuilder: (context,index){
                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        child: ListTile(
                          horizontalTitleGap: 10,
                          leading:  CircleAvatar(
                            backgroundImage: items[index].imgUrl == null
                                ? (const AssetImage(
                                "assets/images/ic_person.png"))
                            as ImageProvider
                                : NetworkImage(items[index].imgUrl!),
                          ),
                          trailing:  items[index].likedImage == null ? Image.asset("assets/images/ali.jpg",width: 50,height: 60,) : Image.network(items[index].likedImage!),
                          subtitle: RichText(
                            softWrap: true,
                            overflow: TextOverflow.visible,
                            text:  TextSpan(
                                children: [
                                  TextSpan(text: items[index].fullName,style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold)),
                                  const TextSpan(text: " liked your photo",style: TextStyle(color: Colors.black)),
                                  TextSpan(text: "  ${DateTime.now().minute}m",style: TextStyle(color: Colors.grey)),
                                ]
                            ),
                          ),

                        ),
                      );
                    }
                ),
                SizedBox(height: 10,),

                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: const [
                //     Text("Suggestions for you",style: TextStyle(color: Colors.black,fontSize: 20,fontWeight: FontWeight.bold),),
                //   ],
                // ),
                // ListView.builder(
                //     shrinkWrap: true,
                //     physics: ScrollPhysics(),
                //     itemCount: 10,
                //     itemBuilder: (context,index){
                //       return Container(
                //         margin: EdgeInsets.symmetric(vertical: 10),
                //         child: ListTile(
                //           leading: CircleAvatar(
                //             backgroundImage: AssetImage("assets/images/ali.jpg"),
                //           ),
                //           trailing: MaterialButton(
                //             shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7)),
                //             child: Text("Follow",style: TextStyle(color: Colors.white),),
                //             color: Colors.blue,
                //             onPressed: (){},
                //
                //           ),
                //           title: Text("maxfiydasturchi",style: TextStyle(color: Colors.black,),),
                //           subtitle: Column(
                //             crossAxisAlignment: CrossAxisAlignment.start,
                //             children: [
                //               Text("Maxfiy Dasturchi",style: TextStyle(color: Colors.grey,overflow: TextOverflow.ellipsis),),
                //               Text("Suggested for you",style: TextStyle(color: Colors.grey),maxLines: 2,),
                //             ],
                //           ),
                //
                //         ),
                //       );
                //     }
                // ),
              ],
            ),
          ),

          isLoading ? const Center(
            child: CircularProgressIndicator(),
          ) : const SizedBox.shrink()
        ],
      ),
    );
  }
}