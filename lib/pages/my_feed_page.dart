import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:http/http.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_instagram_clone/model/users_model.dart';
import 'package:my_instagram_clone/service/data_service.dart';
import 'package:my_instagram_clone/service/utils.dart';
import 'package:my_instagram_clone/viewes/app_bar.dart';
import 'package:my_instagram_clone/viewes/showmodal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../model/bottom_sheet_model.dart';
import '../model/post_model.dart';
import '../model/story_model.dart';

class MyFeedPage extends StatefulWidget {
  static String id = "MyFeedPage";

  const MyFeedPage({Key? key}) : super(key: key);

  @override
  _MyFeedPageState createState() => _MyFeedPageState();
}

class _MyFeedPageState extends State<MyFeedPage> {
  bool isLoading = false;
  Users? users;
  List<Users> story = [];
  List items = [];


  @override
  void initState() {
    super.initState();
    _apiLoadUser();
    _apiLoadFeeds();
  }

  void _apiLoadUser() async {
    setState(() {
      isLoading = true;
    });
    await DataService.loadUser().then((value) => {
          _showUserInfo(value),
        });
    _loadFollowings();
  }

  void _loadFollowings() async {
    await DataService.loadFollowings(uid: users!.uid).then((value) => {
          _showFollowings(value),
        });
  }

  void _showFollowings(List<Users> followingUsers) {
    if(mounted) {
      setState(() {
        story = followingUsers;
      });
    }
  }

  void _showUserInfo(Users user) {
    if (mounted) {
      setState(() {
        users = user;
        isLoading = false;
      });
    }
  }

  void _apiLoadFeeds() async {
    setState(() {
      isLoading = true;
    });
    await DataService.loadFeeds().then((posts) => {_resLoadFeeds(posts)});
  }

  void _resLoadFeeds(List<Post> posts) {
    if(mounted){
      setState(() {
        isLoading = false;
        items = posts;
      });
    }
  }

  void _apiPostLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, true);
    setState(() {
      isLoading = false;
      post.isLiked = true;
    });
  }

  void _apiPostUnLike(Post post) async {
    setState(() {
      isLoading = true;
    });
    await DataService.likePost(post, false);
    setState(() {
      isLoading = false;
      post.isLiked = false;
    });
  }

  ///Remove your post
  void _actionRemovePost(Post post) async {
    var result = await Utils.dialogCommon(
        context, "Instagram Clone", "Do you want to remove this post?", false);
    if (result) {
      DataService.removePost(post).then((value) => {
            _apiLoadFeeds(),
          });
    }
  }
  void likedByMethod(String uid,Post post,String usersUid)async {
    await DataService.likedBy(uid,post,usersUid).then((value) => {});
  }
  void unLikedByMethod(String uid,Post post,String usersUid) async {
    await DataService.unLikedBy(uid,post,usersUid).then((value) => {
      print("Nimadir keldimi o`zi $value"),
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      ///AppBar
      appBar: appBar(
          title: "Instagram",
          icon: const Icon(
            FontAwesomeIcons.facebookMessenger,
            color: Colors.black,
          ),
          isCenter: false),

      ///body
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 10),
            child: Column(
              children: [
                ///storyProfiles
                SizedBox(
                  height: 100,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (ctx, index) {
                      if (index == 0) {
                        return buildMyStory();
                      }
                      return buildStory(index);
                      },
                    itemCount: story.length,
                  ),
                ),
                Container(
                  height: 1,
                  width: double.infinity,
                  color: Colors.grey.shade300,
                ),

                ///post
                ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (ctx, index) {
                    return buildPost(items[index]);
                  },
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                ),
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

  Container buildMyStory() {
    return Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            ///images
                            Container(
                              height: 60,
                              width: 60,
                              child: Stack(
                                children: [
                                  Container(
                                    margin: EdgeInsets.all(2),
                                    height: 60,
                                    width: 60,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.red,
                                        image: DecorationImage(
                                          image: users?.imgUrl == null
                                              ? (const AssetImage(
                                              "assets/images/ic_person.png"))
                                          as ImageProvider
                                              : NetworkImage(users!.imgUrl!),
                                        )),
                                  ),
                                ],
                              ),
                              decoration: BoxDecoration(
                                  border:
                                  Border.all(color: Colors.purple, width: 3),
                                  borderRadius: BorderRadius.circular(30)),
                            ),
                            const SizedBox(
                              height: 10,
                            ),

                            ///text
                            const Text(
                              "Your Story",
                              style: TextStyle(color: Colors.grey),
                            )
                          ],
                        ),
                      );
  }

  Column buildPost(Post post) {
    return Column(
      children: [
        ListTile(
          horizontalTitleGap: 10,
          leading: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.red,
                image: DecorationImage(
                  image: users?.imgUrl == null
                      ? (const AssetImage("assets/images/ic_person.png"))
                          as ImageProvider
                      : NetworkImage(users!.imgUrl!),
                )),
          ),
          subtitle: const Text("Tashkent, Uzbekistan"),
          title: Text(post.fullName),
          trailing: GestureDetector(
                  onTap: () {
                    //_actionRemovePost(post);
                    ShowModal.bottomSheeet(textModal: post.isMine ? BottomSheetClass.textModal : BottomSheetClass.textModal2, context: context,heightSize: post.isMine ? 0.6 : 0.4);
                  },
                  child: const Icon(Icons.more_vert),
                )

        ),
        CachedNetworkImage(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.width,
          imageUrl: post.postImage,
          placeholder: (context, url) =>
              const Center(child: CircularProgressIndicator()),
          errorWidget: (ctx, url, error) => Icon(Icons.error),
          fit: BoxFit.cover,
        ),

        ///ICons
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      if (!post.isLiked) {
                        _apiPostLike(post);
                        likedByMethod(post.uid,post,users!.uid);
                      } else {
                        _apiPostUnLike(post);
                        unLikedByMethod(post.uid,post,users!.uid);
                      }
                    },
                    icon: post.isLiked
                        ? const Icon(
                            FontAwesomeIcons.solidHeart,
                            color: Colors.red,
                          )
                        : const Icon(FontAwesomeIcons.heart)),
                IconButton(
                    onPressed: () {},
                    icon: const Icon(FontAwesomeIcons.comment)),
                IconButton(
                    onPressed: () {
                      fillShare(post);
                    },
                    icon: const Icon(FontAwesomeIcons.telegramPlane)),
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {}, icon: const Icon(FontAwesomeIcons.bookmark)),
              ],
            ),
          ],
        ),


        ///lIKED
        Container(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            children: [
              const Text(
                "Liked by",
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                width: 5,
              ),
              Text(
                post.fullName.toLowerCase().toString(),
                style: const TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Row(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              padding: const EdgeInsets.only(left: 10),
              child: RichText(
                softWrap: true,
                overflow: TextOverflow.visible,
                text: TextSpan(children: [

                  TextSpan(
                      text: "${post.fullName.toLowerCase()} ",
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold)),
                  TextSpan(
                      text: post.caption,
                      style: const TextStyle(color: Colors.black)),
                ]),
              ),
            )
          ],
        ),
        SizedBox(height: 5,),
        Padding(
          padding: const EdgeInsets.only(left: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(Utils.getMonthDayYear(post.createdDate),style: TextStyle(color: Colors.grey,fontSize: 12),),
            ],
          ),
        ),
      ],
    );
  }

  Container buildStory(int index) {
    return Container(
      height: 500,
      margin: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: [
          ///images
          Container(
            height: 60,
            width: 60,
            child: Container(
              margin: EdgeInsets.all(3),
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: story[index].imgUrl == null
                      ? (const AssetImage("assets/images/ic_person.png"))
                          as ImageProvider
                      : NetworkImage(story[index].imgUrl!),
                ),
                color: Colors.green,
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.purple, width: 2),
                borderRadius: BorderRadius.circular(30)),
          ),
          const SizedBox(
            height: 10,
          ),

          ///text
          Text(
            story[index].fullName,
            style: const TextStyle(color: Colors.grey),
          )
        ],
      ),
    );
  }
    fillShare(Post post) async {
    setState(() {
      isLoading = true;
    });
    final box = context.findRenderObject() as RenderBox?;
    if (Platform.isAndroid || Platform.isIOS) {
      Response response = await get(Uri.parse(post.postImage));
      final documentDirectory = (await getExternalStorageDirectory())?.path;
      File imgFile = File('$documentDirectory/flutter.png');
      imgFile.writeAsBytesSync(response.bodyBytes);
      Share.shareFiles([File('$documentDirectory/flutter.png').path],
          subject: 'Instagram',
          text: post.caption,
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    } else {
      Share.share('Hello, check your share files!',
          subject: 'URL File Share',
          sharePositionOrigin: box!.localToGlobal(Offset.zero) & box.size);
    }
    setState(() {
      isLoading = false;
    });
  }
}
