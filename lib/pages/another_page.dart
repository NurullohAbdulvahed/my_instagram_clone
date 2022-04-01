import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_instagram_clone/model/bottom_sheet_model.dart';
import 'package:my_instagram_clone/model/users_model.dart';
import 'package:my_instagram_clone/pages/settings_page.dart';
import 'package:my_instagram_clone/service/data_service.dart';
import 'package:my_instagram_clone/service/file_service.dart';

import '../model/post_model.dart';

class AnotherPage extends StatefulWidget {
  static String id = "AnotherPage";
  Users users;

  AnotherPage({Key? key,required this.users}) : super(key: key);

  @override
  _AnotherPageState createState() => _AnotherPageState();
}

class _AnotherPageState extends State<AnotherPage> {
  bool isLoading = false;
  String postImage =
      "https://firebasestorage.googleapis.com/v0/b/koreanguideway.appspot.com/o/develop%2Fpost2.png?alt=media&token=ac0c131a-4e9e-40c0-a75a-88e586b28b72";
  int? countPosts = 0;
  List<Post> postList = [];
  File? _image;

  _imgFromCamera() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.camera, imageQuality: 50);

    setState(() {
      _image = File(image!.path);
    });
    _apiChangePhoto();
  }

  _imgFromGallery() async {
    XFile? image = await ImagePicker()
        .pickImage(source: ImageSource.gallery, imageQuality: 50);
    setState(() {
      _image = File(image!.path);
    });
    _apiChangePhoto();
  }

  void _apiChangePhoto() {
    if (_image == null) return;

    setState(() {
      isLoading = true;
    });
    FileService.uploadImage(_image!, FileService.folderUserImg)
        .then((value) => {_apiUpdateUser(value)});
  }

  void _apiUpdateUser(String imgUrl) async {
    setState(() {
      isLoading = false;
      widget.users.imgUrl = imgUrl;
    });
    await DataService.updateUser(widget.users);
  }

  void _apiLoadUser() async {
    setState(() {
      isLoading = true;
    });
    DataService.loadUser().then((value) => {
      _showUserInfo(value),
    });
  }

  void _showUserInfo(Users user) {
    setState(() {
      widget.users = user;
      isLoading = false;
    });
  }

  void _apiLoadPost() {
    DataService.loadSomeOnePosts(someOneuid: widget.users.uid).then((posts) => {
      _resLoadPost(posts),
    });
  }

  void _resLoadPost(List<Post> post) {
    setState(() {
      postList = post;
      countPosts = postList.length;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _apiLoadPost();
  }

  ///ShowPicker
  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Wrap(
              children: <Widget>[
                ListTile(
                    leading: const Icon(Icons.photo_library),
                    title: const Text('Photo Library'),
                    onTap: () {
                      _imgFromGallery();
                      Navigator.of(context).pop();
                    }),
                ListTile(
                  leading: const Icon(Icons.photo_camera),
                  title: const Text('Camera'),
                  onTap: () {
                    _imgFromCamera();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        initialIndex: 0,
        length: 2,
        child: Stack(
          children: [
            Scaffold(
              backgroundColor: Colors.white,
              appBar: AppBar(
                elevation: 0,
                leading: IconButton(
                  padding: EdgeInsets.zero,
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  icon: Icon(Icons.arrow_back,color: Colors.black,),
                ),
                backgroundColor: Colors.white,
                title: Row(
                  children: [
                    widget.users.fullName == null
                        ? const Text(
                      "Profile",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Billabong",
                          fontSize: 30),
                    )
                        : Text(
                      widget.users.fullName.toLowerCase(),
                      style: const TextStyle(color: Colors.black),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    const Icon(
                      Icons.keyboard_arrow_down_sharp,
                      color: Colors.black,
                    ),
                  ],
                ),
                actions: [
                  const Icon(
                    CupertinoIcons.plus_app,
                    color: Colors.black,
                    size: 30,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  IconButton(
                    onPressed: () {
                      showMaterialModalBottomSheet(
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(25))),
                        context: context,
                        builder: (context) => Container(
                          padding: const EdgeInsets.only(left: 15, top: 10),
                          height: MediaQuery.of(context).size.height * 0.5,
                          child: Column(
                            children: [
                              Container(
                                height: 5,
                                width: 40,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey,
                                ),
                                alignment: Alignment.center,
                              ),
                              ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount:
                                BottomSheetClass.bottomSheetList.length,
                                itemBuilder: (context, index) {
                                  return Container(
                                    margin: const EdgeInsets.only(top: 25),
                                    child: index == 0
                                        ? GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, SettingsPage.id);
                                      },
                                      child: Row(
                                        children: [
                                          BottomSheetClass
                                              .bottomSheetList[index]
                                              .iconData!,
                                          const SizedBox(
                                            width: 10,
                                          ),
                                          Text(BottomSheetClass
                                              .bottomSheetList[index]
                                              .iconName!)
                                        ],
                                      ),
                                    )
                                        : Row(
                                      children: [
                                        BottomSheetClass
                                            .bottomSheetList[index]
                                            .iconData!,
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(BottomSheetClass
                                            .bottomSheetList[index]
                                            .iconName!)
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      FontAwesomeIcons.bars,
                      color: Colors.black,
                    ),
                  ),
                ],
              ),
              body: isLoading
                  ? const Center(
                child: CircularProgressIndicator(),
              )
                  : ScrollConfiguration(
                behavior: const ScrollBehavior(),
                child: GlowingOverscrollIndicator(
                  axisDirection: AxisDirection.down,
                  color: const Color(0xffFAFAFA),
                  child: NestedScrollView(
                    headerSliverBuilder:
                        (BuildContext context, bool innerBoxIsScrolled) {
                      return [
                        SliverList(
                            delegate: SliverChildListDelegate([
                              Column(
                                children: [
                                  ///ProfileImage
                                  Container(
                                    padding: EdgeInsets.all(15),
                                    child: Row(
                                      children: [
                                        ///MyPhoto
                                        Stack(
                                          children: [
                                            Container(
                                              padding:
                                              const EdgeInsets.all(2),
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      70),
                                                  border: Border.all(
                                                      width: 1.5,
                                                      color: const Color.fromRGBO(
                                                          193, 53, 132, 1))),
                                              child: ClipRRect(
                                                  borderRadius:
                                                  BorderRadius.circular(
                                                      35),
                                                  child: widget.users.imgUrl ==
                                                      null ||
                                                      widget.users
                                                          .imgUrl!.isEmpty
                                                      ? const Image(
                                                    image: AssetImage(
                                                        "assets/images/ic_person.png"),
                                                    width: 70,
                                                    height: 70,
                                                    fit: BoxFit.cover,
                                                  )
                                                      : Image.network(
                                                    widget.users.imgUrl!,
                                                    height: 70,
                                                    width: 70,
                                                    fit: BoxFit.cover,
                                                  )),
                                            ),
                                            Container(
                                              height: 80,
                                              width: 80,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.end,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.end,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () {
                                                      _showPicker(context);
                                                    },
                                                    child: const Icon(
                                                      Icons.add_circle,
                                                      color: Colors.purple,
                                                    ),
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                        Expanded(
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                            children: [
                                              Column(
                                                children: [
                                                  Text(
                                                    "$countPosts",
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 17),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text(
                                                    "Posts",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    widget.users == null
                                                        ? "0"
                                                        : widget.users
                                                        .followersCount
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 17),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text(
                                                    "Followers",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                children: [
                                                  Text(
                                                    widget.users == null
                                                        ? "0"
                                                        : widget.users
                                                        .followingCount
                                                        .toString(),
                                                    style: const TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        fontSize: 17),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text(
                                                    "Following",
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),

                                  ///BIO Text
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          widget.users.fullName == null
                                              ? ""
                                              : widget.users.fullName,
                                          style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  ///Edit Profile
                                  Container(
                                    padding:
                                    EdgeInsets.only(left: 10, right: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        ///Follow
                                        Expanded(
                                          child: MaterialButton(
                                            onPressed: () {},
                                            child: const Text(
                                              'Follow',
                                              style: TextStyle(
                                                  color: Colors.white),
                                            ),
                                            color: Colors.blue,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                          ),
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: MaterialButton(
                                              onPressed: () {},
                                              child: const Text(
                                                'Message',
                                                style: TextStyle(
                                                    color: Colors.black87
                                                ),
                                              ),
                                              color: Colors.white,
                                              shape:  RoundedRectangleBorder( borderRadius: BorderRadius.circular(5),side: BorderSide(width: 1, style: BorderStyle.solid, color: Colors.grey.shade400),
                                              ),
                                              elevation: 0,
                                            )),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Container(
                                    height: 120,
                                    child: ListView.builder(
                                        itemCount: 2,
                                        scrollDirection: Axis.horizontal,
                                        itemBuilder: (context, index) {
                                          if (index == 0) {
                                            return Container(
                                              padding: EdgeInsets.all(10),
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    padding:
                                                    EdgeInsets.all(2),
                                                    decoration: BoxDecoration(
                                                        border: Border.all(
                                                            color:
                                                            Colors.black,
                                                            width: 1),
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            100)),
                                                    child: Container(
                                                      child: Icon(Icons.add),
                                                      height: 50,
                                                      width: 50,
                                                      decoration:
                                                      BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                        BorderRadius
                                                            .circular(
                                                            100),
                                                      ),
                                                    ),
                                                  ),
                                                  const SizedBox(
                                                    height: 5,
                                                  ),
                                                  const Text(
                                                    "New",
                                                    style: TextStyle(
                                                        fontSize: 12,
                                                        letterSpacing: 0.01,
                                                        fontWeight:
                                                        FontWeight.w400),
                                                  ),
                                                ],
                                              ),
                                            );
                                          }
                                          return Container(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  padding:
                                                  const EdgeInsets.all(2),
                                                  decoration: BoxDecoration(
                                                      border: Border.all(
                                                          color: const Color
                                                              .fromRGBO(
                                                              199,
                                                              199,
                                                              204,
                                                              1),
                                                          width: 1),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(100)),
                                                  child: Container(
                                                    height: 50,
                                                    width: 50,
                                                    decoration: BoxDecoration(
                                                      image: DecorationImage(
                                                          fit: BoxFit.cover,
                                                          image: NetworkImage(
                                                              postImage)),
                                                      borderRadius:
                                                      BorderRadius
                                                          .circular(100),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                const Text(
                                                  "New",
                                                  style: TextStyle(
                                                      fontSize: 12,
                                                      letterSpacing: 0.01,
                                                      fontWeight:
                                                      FontWeight.w400),
                                                ),
                                              ],
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ]))
                      ];
                    },
                    body: Column(
                      children: [
                        const Divider(
                          height: 0,
                        ),
                        const TabBar(
                          labelColor: Colors.black,
                          unselectedLabelColor: Colors.black54,
                          indicatorColor: Colors.black,
                          indicatorWeight: 0.8,
                          tabs: [
                            Tab(
                              icon: Icon(
                                Icons.grid_on_sharp,
                                size: 25,
                              ),
                            ),
                            Tab(
                              icon: Icon(
                                Icons.perm_contact_cal_rounded,
                                size: 25,
                              ),
                            ),
                          ],
                        ),
                        Expanded(
                          child: TabBarView(
                            children: [
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: GridView.builder(
                                  itemCount: postList.length,
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1,
                                      crossAxisCount: 3),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  postList[index]
                                                      .postImage))),
                                    );
                                  },
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width,
                                child: GridView.builder(
                                  itemCount: postList.length,
                                  gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      mainAxisSpacing: 1,
                                      crossAxisSpacing: 1,
                                      crossAxisCount: 2),
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  postList[index]
                                                      .postImage))),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
