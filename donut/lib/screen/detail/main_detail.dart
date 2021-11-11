import 'package:donut/server/apis.dart';
import 'package:donut/server/response.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainDetailPage extends StatefulWidget {
  @override
  _MainDetailState createState() => _MainDetailState();
}

class _MainDetailState extends State<MainDetailPage> {
  late SharedPreferences sharedPreferences;
  late UserResponse userResponse;

  UserServerApi userServerApi = UserServerApi();

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        FutureBuilder<UserResponse> (
          future: userServerApi.getMyInfo(),
          builder: (context, snapshot) {
            if(snapshot.hasData == false) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }else {
              userResponse = snapshot.data!;
              return Center(
                child: Column(
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: height * 0.08),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                         image: NetworkImage(userResponse.profileUrl),
                          fit: BoxFit.fill
                        )
                      ),
                      width: width * 0.4,
                      height: width * 0.4,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20),
                      child: Text(
                        userResponse.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            color: Color(0xff2C2C2C)
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
          },
        ),
      ],
    );
  }

}