import 'dart:convert';

import 'package:http/http.dart';

class Network{

  static bool isTester = true;

  static String SERVER_DEVELOPMENT = "fcm.googleapis.com";
  static String SERVER_PRODUCTION = "fcm.googleapis.com";


  /// Http Apis
  static String API_LIST = "/fcm/send";

  static Map<String, String> getUploadHeaders() {
    Map<String, String> headers = {
    'Content-Type': 'application/json',
    "Authorization" : "key=AAAAqgB5Sxg:APA91bGO2UYwp5JGbsZfersd-X4jpNJ2ew3zcmC7TL4WCyf1jfsiXqrBYtj3HgbGHOBn6TEOr-o2iTjvbZTRDiytn5zUFzFOsfnB02x_8Wpfqpojeiauc2aSnBbAQeS_JoWZRnJWXSSe",

    };
    return headers;
  }

  static String getServer() {
    if (isTester) return SERVER_DEVELOPMENT;
    return SERVER_PRODUCTION;
  }


  static Future<String?> POST(String api, Map<String, dynamic> body) async {
    var uri = Uri.https(getServer(), api); // http or https
    var response =
    await post(uri, headers: getUploadHeaders(), body: jsonEncode(body));

    if (response.statusCode == 200 || response.statusCode == 201) {
      return response.body;
    }
    return null;
  }

  /* Http Body */
  static Map<String, dynamic> bodyUpload(String token,String someoneFullname) {
    Map<String, dynamic> body = {};
    body.addAll({
      "notification": {
        "title":"Instagram Clone",
        "body":"$someoneFullname followed you"
      },
      "registration_ids":[token],
      "click_action":"FLUTTER_NOTIFICATION_CLICK"
    });
    return body;
  }
}