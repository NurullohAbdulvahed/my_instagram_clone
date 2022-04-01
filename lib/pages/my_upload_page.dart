import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:my_instagram_clone/model/post_model.dart';
import 'package:my_instagram_clone/pages/home_page.dart';
import 'package:my_instagram_clone/service/data_service.dart';
import 'package:my_instagram_clone/service/file_service.dart';

class MyUploadPage extends StatefulWidget {
  static String id = "MyUploadPage";

  const MyUploadPage({Key? key}) : super(key: key);

  @override
  _MyUploadPageState createState() => _MyUploadPageState();
}

class _MyUploadPageState extends State<MyUploadPage> {
  bool isLoading = false;
  TextEditingController captionController = TextEditingController();
  File? imageFile;
  ImagePicker picker = ImagePicker();

  Future getMyImage(ImageSource source) async {
    File? file;

    final pickedImage = await picker.pickImage(source: source);
    setState(() {
      if (pickedImage != null) {
        imageFile = File(pickedImage.path);
        file = File(pickedImage.path);
      }
    });
    return file;
  }

  void _uploadPost() {
    String caption = captionController.text.trim().toString();
    if (caption.isEmpty || imageFile == null) return;

    ///Send post to server
    _apiPostImage();
  }

  void _apiPostImage() {
    setState(() {
      isLoading = true;
    });
    FileService.uploadImage(imageFile!, FileService.folderPostImg)
        .then((imageUrl) => {
              _resPostImage(imageUrl),
            });
  }

  void _resPostImage(String imageUrl) {
    String caption = captionController.text.trim().toString();
    Post post = Post(
        uid: "",
        id: "",
        postImage: imageUrl,
        caption: caption,
        createdDate: "",
        isLiked: false,
        isMine: false,
        fullName: "");
    _apiStorePost(post);
  }

  void _apiStorePost(Post post) async {
    ///Post to posts folder
    Post posted = await DataService.storePost(post);

    ///Post to feed
    DataService.storeFeed(posted).then((value) => {
          _moveToFeed(value),
        });
  }

  void _moveToFeed(Post post) {
    setState(() {
      isLoading = false;
    });
    Navigator.pushReplacementNamed(context, HomePage.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: GestureDetector(
            onTap: (){
              Navigator.of(context).pop();
            },
              child: const Icon(
            CupertinoIcons.xmark,
            color: Colors.black,
          )),
          title:const  Text(
            "New Post",
            style: TextStyle(color: Colors.black, fontSize: 18),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  _uploadPost();
                },
                icon: Icon(Icons.arrow_forward_outlined, color: Colors.blue))
          ],
        ),
        body: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        //getMyImage(ImageSource.gallery);
                        showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => itemsModalSheet(context),
                        );
                      },
                      child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.width,
                          color: Colors.grey.withOpacity(0.4),
                          child: imageFile == null
                              ? const Center(
                                  child: Icon(
                                    Icons.add_a_photo,
                                    size: 60,
                                    color: Colors.grey,
                                  ),
                                )
                              : Stack(
                                  children: [
                                    Image.file(
                                      imageFile!,
                                      width: double.infinity,
                                      height: double.infinity,
                                      fit: BoxFit.cover,
                                    ),
                                    Container(
                                      width: double.infinity,
                                      color: Colors.black12,
                                      padding: EdgeInsets.all(10),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  imageFile = null;
                                                });
                                              },
                                              icon:const Icon(
                                                Icons.highlight_remove,
                                                color: Colors.white54,
                                              )),
                                        ],
                                      ),
                                    )
                                  ],
                                )),
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10, top: 10),
                      child: TextField(
                        controller: captionController,
                        keyboardType: TextInputType.multiline,
                        style:const TextStyle(color: Colors.black),
                        decoration: const InputDecoration(
                            hintText: "Caption",
                            hintStyle: TextStyle(
                                fontSize: 17.0, color: Colors.black38)),
                      ),
                    )
                  ],
                ),
              ),
            ),
            isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : const SizedBox.shrink()
          ],
        ));
  }

  Container itemsModalSheet(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.16,
      width: double.infinity,
      color: Colors.white,
      child: Column(
        children: [
          MaterialButton(
            onPressed: () {
              getMyImage(ImageSource.gallery);
              Navigator.of(context).pop();
            },
            child: const ListTile(
              leading: Icon(Icons.image),
              title: Text("Pick Photo"),
            ),
          ),
          MaterialButton(
            onPressed: () {
              getMyImage(ImageSource.camera);
              Navigator.of(context).pop();
            },
            child: const ListTile(
              leading: Icon(Icons.camera_alt),
              title: Text("Take Photo"),
            ),
          ),
        ],
      ),
    );
  }
}
