import 'package:donut/server/apis.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

class WriteDonePage extends StatefulWidget {
  @override
  _WriteDoneState createState() => _WriteDoneState();
}

class _WriteDoneState extends State<WriteDonePage> {
  final _editTitleController = TextEditingController();
  final _editContentCotroller = TextEditingController();
  bool isPublic = false, err = false;

  DoneServerApi doneServerApi = DoneServerApi();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
        toolbarHeight: 60,
        centerTitle: false,
        title: const Text(
          "Write Done",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 26,
              color: Color(0xff2C2C2C)
          ),
        ),
        actions: [
          Container(
              child: IconButton(
                  onPressed: () {
                    String title = _editTitleController.text;
                    String content = _editContentCotroller.text;

                    if(title == "" || content == "") {
                      Fluttertoast.showToast(msg: "제목 혹은 내용을 입력해주세요!");
                      return;
                    }

                    doneServerApi.writeDone(title, content, isPublic, context);
                  },
                  icon: Icon(Icons.add_rounded),
                  iconSize: 40,
                  color: const Color(0xff2c2c2c)
              )
          ),
        ],
        titleSpacing: 15,
        leading: Container(
            child: Builder(
                builder: (context) => Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    color: const Color(0xff2C2C2C),
                    iconSize: 35,
                  ),
                )
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
                width: width * 0.871,
                height: 45,
                margin: EdgeInsets.only(top: height * 0.05),
                child: CupertinoTextField(
                  textAlignVertical: TextAlignVertical.top,
                  textInputAction: TextInputAction.next,
                  maxLines: 1,
                  textAlign: TextAlign.start,
                  controller: _editTitleController,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xffF4F4F4),
                  ),
                  onChanged: (val) {
                    setState(() {
                      err = false;
                    });
                  },
                  placeholder: '제목을 입력하세요',
                  placeholderStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xffD1D1D1)
                  ),
                  padding: const EdgeInsets.only(left: 20, top: 13),
                )
            ),
            Container(
                width: width * 0.871,
                height: height * 0.19,
                margin: EdgeInsets.only(top: 20),
                child: CupertinoTextField(
                  textAlignVertical: TextAlignVertical.top,
                  textInputAction: TextInputAction.newline,
                  maxLines: 20,
                  textAlign: TextAlign.start,
                  controller: _editContentCotroller,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xffF4F4F4),
                  ),
                  onChanged: (val) {
                    setState(() {
                      err = false;
                    });
                  },
                  placeholder: '내용을 입력하세요',
                  placeholderStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xffD1D1D1)
                  ),
                  padding: const EdgeInsets.only(left: 20, top: 20),
                )
            ),
            Container(
              margin: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: const Text(
                      '공개여부',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xff2c2c2c)
                      ),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(right: 10),
                    child: Checkbox(
                      focusColor: const Color(0xffD4B886),
                      activeColor: const Color(0xffD4B886),
                      value: isPublic,
                      onChanged: (bool? value) {
                        setState(() {
                          isPublic = value ?? false;
                        });
                      },
                    )
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UpdateDonePage extends StatefulWidget {
  int doneId;
  String title, content;

  UpdateDonePage(this.doneId, this.title, this.content);

  @override
  _UpdateDoneState createState() => _UpdateDoneState(doneId, title, content);
}

class _UpdateDoneState extends State<UpdateDonePage> {
  final _editTitleController = TextEditingController();
  final _editContentCotroller = TextEditingController();
  bool isPublic = false, err = false;

  int doneId;
  String title, content;

  _UpdateDoneState(this.doneId, this.title, this.content);

  DoneServerApi doneServerApi = DoneServerApi();

  @override
  void initState() {
    _editTitleController.text = title;
    _editContentCotroller.text = content;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xffffffff),
        toolbarHeight: 60,
        centerTitle: false,
        title: const Text(
          "Update Done",
          style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 26,
              color: Color(0xff2C2C2C)
          ),
        ),
        actions: [
          Container(
              child: IconButton(
                  onPressed: () {
                    String title = _editTitleController.text;
                    String content = _editContentCotroller.text;

                    doneServerApi.updateDone(doneId, title, content,context);
                  },
                  icon: Icon(Icons.check),
                  iconSize: 40,
                  color: const Color(0xff2c2c2c)
              )
          ),
        ],
        titleSpacing: 15,
        leading: Container(
            child: Builder(
                builder: (context) => Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    color: const Color(0xff2C2C2C),
                    iconSize: 35,
                  ),
                )
            )
        ),
      ),
      body: SingleChildScrollView(
        child: Column (
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                    width: width * 0.871,
                    height: 45,
                    margin: EdgeInsets.only(top: height * 0.05),
                    child: CupertinoTextField(
                      textAlignVertical: TextAlignVertical.top,
                      textInputAction: TextInputAction.next,
                      maxLines: 1,
                      textAlign: TextAlign.start,
                      controller: _editTitleController,
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                        color: Color(0xffF4F4F4),
                      ),
                      onChanged: (val) {
                        setState(() {
                          err = false;
                        });
                      },
                      placeholder: '기존제목 : $title',
                      placeholderStyle: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                          color: Color(0xffD1D1D1)
                      ),
                      padding: const EdgeInsets.only(left: 20, top: 13),
                    )
                ),
              ],
            ),
            Container(
                width: width * 0.871,
                height: height * 0.19,
                margin: EdgeInsets.only(top: 20),
                child: CupertinoTextField(
                  textAlignVertical: TextAlignVertical.top,
                  textInputAction: TextInputAction.newline,
                  maxLines: 20,
                  textAlign: TextAlign.start,
                  controller: _editContentCotroller,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(8)),
                    color: Color(0xffF4F4F4),
                  ),
                  onChanged: (val) {
                    setState(() {
                      err = false;
                    });
                  },
                  placeholder: '기존 내용 : $content',
                  placeholderStyle: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: Color(0xffD1D1D1)
                  ),
                  padding: const EdgeInsets.only(left: 20, top: 20),
                )
            ),
          ],
        ),
      ),
    );
  }
}

class ReadDoneDetail extends StatefulWidget {
  String title, content;
  bool isPublic;

  ReadDoneDetail(this.title, this.isPublic, this.content);

  @override
  _ReadDoneState createState() => _ReadDoneState(title, isPublic, content);
}

class _ReadDoneState extends State<ReadDoneDetail> {
  String title, content;
  bool isPublic;

  _ReadDoneState(this.title, this.isPublic, this.content);

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.white,
        toolbarHeight: 60,
        centerTitle: true,
        title: Text(
          title,
          style: TextStyle(
              fontFamily: 'NotoSansKR',
              fontWeight: FontWeight.w700,
              fontSize: 20,
              color: Color(0xff2c2c2c)
          ),
        ),
        leading: Container(
            child: Builder(
                builder: (context) => Container(
                  margin: const EdgeInsets.only(left: 10),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back_ios_rounded),
                    onPressed: () => Navigator.of(context).pop(),
                    color: const Color(0xff2C2C2C),
                    iconSize: 35,
                  ),
                )
            )
        ),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30, left: 20),
                      child: Text(
                        '공개여부',
                        style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Color(0xff2C2C2C)
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 30, right: 20),
                    child: Text(
                      isPublic ? '공개' : '비공개',
                      style: TextStyle(
                          fontFamily: 'NotoSansKR',
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Color(0xff2c2c2c)
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(top: 30, left: 20),
                      child: Text(
                        '내용',
                        style: TextStyle(
                            fontFamily: 'NotoSansKR',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Color(0xff2C2C2C)
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
          Center(
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: width * 0.871,
              padding: EdgeInsets.all(10),
              child: Text(
                content,
                style: TextStyle(
                    fontFamily: 'NotoSansKR',
                    fontWeight: FontWeight.normal,
                    fontSize: 18,
                    color: Color(0xff2C2C2C)
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8)),
                color: Color(0xffF4F4F4),
              ),
            ),
          ),
        ],
      ),
    );
  }

}