import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:donut/screen/auth_screen.dart';
import 'package:donut/screen/main_screen.dart';
import 'package:donut/server/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String url = "http://220.90.237.33:7788";
Dio dio = Dio();
late SharedPreferences sharedPreferences;

class AuthServerApi {

  AuthServerApi(SharedPreferences s) {
    sharedPreferences = s;
  }

  void auth(int kakaoId, String nickName, String profileUrl, BuildContext context) async {
    try {
      final response = await dio.post(
        url + "/auth",
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json"
          }
        ),
        data: jsonEncode(
          <String, dynamic> {
            "kakaoId" : kakaoId,
            "nickName" : nickName,
            "profileUrl" : profileUrl
          }
        )
      );

      print("login : ${response.statusCode} - ${response.data.toString()}");

      TokenResponse tokenResponse = TokenResponse.fromJson(response.data);

      sharedPreferences.setString("accessToken", tokenResponse.accessToken);
      sharedPreferences.setString("refreshToken", tokenResponse.refreshToken);
      sharedPreferences.setBool("isLogin", true);

      Navigator.of(context).pushAndRemoveUntil(
        PageTransition(
            child: MainPage(),
            type: PageTransitionType.fade
        ),
          (route) => false
      );
    }on DioError catch(e) {
      print("login error : ${e.response!.statusCode} - ${e.response!.data}");

      print("user not found");
      UserServerApi().signUp(kakaoId, nickName, profileUrl, context);
    }
  }

  void refreshToken(String refreshToken) async {
    try {
      final response = await dio.put(
        url + "/auth",
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            "X-Refresh-Token" : refreshToken
          }
        )
      );
      print("refreshToken : ${response.statusCode} - ${response.data.toString()}");

      TokenResponse tokenResponse = TokenResponse.fromJson(response.data);

      sharedPreferences.setString("accessToken", tokenResponse.accessToken);
      sharedPreferences.setString("refreshToken", tokenResponse.refreshToken);
      sharedPreferences.setBool("isLogin", true);
    }on DioError catch(e) {
      print("refreshToken error : ${e.response!.statusCode} - ${e.response!.data}");

      if(e.response!.statusCode == 403) {
      }
    }
  }
}

class UserServerApi {

  Future<UserResponse> getMyInfo() async {
    var s = await SharedPreferences.getInstance();
    try {
      final response = await dio.get(
        url + "/user",
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json",
            HttpHeaders.authorizationHeader: s.getString("accessToken") ?? ""
          }
        )
      );

      print("getMyInfo : ${response.statusCode} - ${response.data.toString()}");

      return UserResponse.fromJson(response.data);
    }on DioError catch(e) {
      print("getMyInfo error : ${e.response!.statusCode} - ${e.response!.data}");

      var s = await SharedPreferences.getInstance();
      AuthServerApi(s).refreshToken(s.getString("accessToken") ?? "");
      return await retryGetInfo();
    }
  }

  Future<dynamic> retryGetInfo() async {
    var s = await SharedPreferences.getInstance();
    try {
      final response = await dio.get(
          url + "/user",
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: s.getString("accessToken") ?? ""
              }
          )
      );

      print("getMyInfo : ${response.statusCode} - ${response.data.toString()}");

      return UserResponse.fromJson(response.data);
    }on DioError catch(e) {
      print("getMyInfo error : ${e.response!.statusCode} - ${e.response!.data}");
    }
  }

  void signUp(int kakaoId, String nickName, String profileUrl, BuildContext context) async {
    try {
      final response = await dio.post(
        url + '/user',
        options: Options(
          headers: {
            HttpHeaders.contentTypeHeader: "application/json"
          }
        ),
        data: jsonEncode(
          <String, dynamic> {
            "kakaoId" : kakaoId,
            "nickName" : nickName,
            "profileUrl" : profileUrl
          }
        )
      );

      print("signUp : ${response.statusCode} - ${response.data.toString()}");
      var s = await SharedPreferences.getInstance();
      AuthServerApi(s).auth(kakaoId, nickName, profileUrl, context);
    }on DioError catch(e) {
      print("singUp error : $e");
    }
  }

  deleteUser() async {
    var s = await SharedPreferences.getInstance();
    try {
      final response = await dio.delete(
          url + '/user',
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: s.getString("accessToken") ?? ""
              }
          ),
      );

      print("user : ${response.statusCode} - ${response.data.toString()}");
    }on DioError catch(e) {
      print("user error : $e");
    }
  }
}

class DoneServerApi {

  Future<List<DoneResponse>> getMyDonesByWriteAt(String writeAt) async {
    var s = await SharedPreferences.getInstance();
    try {
      final response = await dio.get(
        url + '/done/search',
        options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: s.getString("accessToken") ?? ""
            }
        ),
        queryParameters: {
          "writeAt" : writeAt
        }
      );

      return (response.data as List).map((e) => DoneResponse.fromJson(e)).toList();
    }on DioError catch(e) {
      print("error : ${e.response!.statusCode} - ${e.response!.statusMessage}");

      var s = await SharedPreferences.getInstance();
      AuthServerApi(s).refreshToken(s.getString("refreshToken") ?? "");
      return await retry(writeAt);
    }
  }

  Future<dynamic> retry(String writeAt) async {
    var s = await SharedPreferences.getInstance();
    AuthServerApi(s).refreshToken(s.getString("refresh") ?? "");
    try {
      final response = await dio.get(
          url + '/done/search',
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: s.getString("accessToken") ?? ""
              }
          ),
          queryParameters: {
            "writeAt" : writeAt
          }
      );

      return (response.data as List).map((e) => DoneResponse.fromJson(e)).toList();
    }on DioError catch(e) {
      print("error : ${e.response!.statusCode} - ${e.response!.statusMessage}");

      return [];
    }
  }

  writeDone(String title, String content, bool isPublic, BuildContext context) async {
    var s = await SharedPreferences.getInstance();
    try {
      final response = await dio.post(
          url + '/done',
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: s.getString("accessToken") ?? ""
              }
          ),
          data: <String, dynamic> {
            'title' : title,
            'content' : content,
            'isPublic' : isPublic
          }
      );

      print(response.data);

      Navigator.pop(context);
    }on DioError catch(e) {
      print("error : ${e.response!.statusCode} - ${e.response!.statusMessage}");
      if(e.response!.statusCode == 403) {
        AuthServerApi(s).refreshToken(s.getString("refreshToken") ?? "");
        retryWriteDone(title, content, isPublic);
      }
    }
  }

  retryWriteDone(String title, String content, bool isPublic) async {
    var s = await SharedPreferences.getInstance();
    AuthServerApi(s).refreshToken(s.getString("refresh") ?? "");
    try {
      final response = await dio.post(
          url + '/done',
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: s.getString("accessToken") ?? ""
              }
          ),
          data: <String, dynamic> {
            'title' : title,
            'content' : content,
            'isPublic' : isPublic
          }
      );

      print(response.data);
    }on DioError catch(e) {
      print("error : ${e.response!.statusCode} - ${e.response!.statusMessage}");
    }
  }

  updateDone(int doneId, String title, String content, BuildContext context) async {
    var s = await SharedPreferences.getInstance();
    try {
      final response = await dio.put(
        url + '/done/$doneId',
        options: Options(
            headers: {
              HttpHeaders.contentTypeHeader: "application/json",
              HttpHeaders.authorizationHeader: s.getString("accessToken") ?? ""
            }
        ),
          data: <String, dynamic> {
            'title' : title,
            'content' : content
          }
      );

      Navigator.of(context).pop();
      print(response.data);
    }on DioError catch(e) {
      print("error : ${e.response!.statusCode} - ${e.response!.statusMessage}");
    }
  }

  updatePublic(int doneId, bool isPublic) async {
    var s = await SharedPreferences.getInstance();
    try {
      final response = await dio.put(
          url + '/done/public/$doneId',
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: s.getString("accessToken") ?? ""
              }
          ),
          queryParameters: {
            "isPublic" : isPublic
          }
      );

      print(response.data);
    }on DioError catch(e) {
      print("error : ${e.response!.statusCode} - ${e.response!.statusMessage}");
    }
  }

  deleteDone(int doneId) async {
    var s = await SharedPreferences.getInstance();
    try {
      final response = await dio.delete(
          url + '/done/$doneId',
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: s.getString("accessToken") ?? ""
              }
          ),
      );

      print(response.data);
    }on DioError catch(e) {
      print("error : ${e.response!.statusCode} - ${e.response!.statusMessage}");
    }
  }
}

class FriendServerApi {

  makeFriend(int kakaoId) async {
    var s = await SharedPreferences.getInstance();
    try {
      final response = await dio.put(
          url + '/friend/$kakaoId',
          options: Options(
              headers: {
                HttpHeaders.contentTypeHeader: "application/json",
                HttpHeaders.authorizationHeader: s.getString("accessToken") ?? ""
              }
          ),
      );

      Fluttertoast.showToast(msg: "친구추가가 완료되었습니다");
      print(response.data);
    }on DioError catch(e) {
      Fluttertoast.showToast(msg: "친구추가실패");
      print("error : ${e.response!.statusCode} - ${e.response!.statusMessage}");
    }
  }
}