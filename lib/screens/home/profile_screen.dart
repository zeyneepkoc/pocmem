import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pocmem/config/size_config.dart';
import 'package:pocmem/constants/colors/color.dart';
import 'package:provider/provider.dart';

import '../../constants/class/hero_dialog.dart';
import '../../models/user.dart';
import '../../services/database.dart';

class ProfileScreen extends StatefulWidget {
  Map<String, dynamic>? userInfo;
  ProfileScreen({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int memoriesCount = 0;
  Map<String, dynamic> _bookInfo = ({});
  getMemoriesCount(String? uid) async {
    var qSnap =
        await Database().memoriesRef.doc(uid).collection("userMemories").get();
    setState(() {
      memoriesCount = qSnap.docs.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserModel?>(context);
    getMemoriesCount(_user!.uid);
    Database().usersRef.doc(_user.uid).get().then((DocumentSnapshot ds) {
      setState(() {
        widget.userInfo = ds.data() as Map<String, dynamic>;
      });
    });
    Database()
        .memoryBookRef
        .doc(_user.uid)
        .get()
        .then((DocumentSnapshot ds) => {
              setState(() {
                _bookInfo = ds.data() as Map<String, dynamic>;
              })
            });
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(SizeConfig.defaultSize * 13),
            child: Center(
              child: InkWell(
                onLongPress: () {
                  //book edit
                },
                child: Container(
                  decoration: const BoxDecoration(
                      color: darkColor,
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(10),
                          bottomLeft: Radius.circular(10))),
                  height: SizeConfig.defaultSize * 110,
                  width: SizeConfig.defaultSize * 75,
                  child: Stack(
                    children: [
                      Positioned(
                        left: SizeConfig.defaultSize * 5,
                        child: Container(
                          height: SizeConfig.defaultSize * 110,
                          width: SizeConfig.defaultSize * 0.5,
                          color: Colors.white,
                        ),
                      ),
                      Positioned(
                        top: SizeConfig.defaultSize * 30,
                        left: SizeConfig.defaultSize * 20,
                        child: Text(
                          _bookInfo["bookName"],
                          style: TextStyle(
                              fontSize: SizeConfig.defaultSize * 7,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultSize * 13.0,
                vertical: SizeConfig.defaultSize * 8),
            child: SizedBox(
              height: SizeConfig.defaultSize * 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        "BOOK INFO",
                        style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 7,
                            color: darkColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: SizeConfig.defaultSize * 6,
                      ),
                      InkWell(
                        child: Hero(
                          tag: _showBookInfo,
                          child: Icon(
                            Icons.edit,
                            color: darkColor,
                            size: SizeConfig.defaultSize * 6,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .push(HeroDialogRoute(builder: (context) {
                            return UpdateBookInformation(
                              bookInfo: _bookInfo,
                            );
                          }));
                        },
                      )
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                            text: "Book Name ",
                            style: TextStyle(
                                color: darkColor, fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: _bookInfo["bookName"],
                            style: const TextStyle(color: backgroundColor)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                            text: "Memory Count ",
                            style: TextStyle(
                                color: darkColor, fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: memoriesCount.toString(),
                            style: const TextStyle(color: backgroundColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: SizeConfig.defaultSize * 13.0,
                vertical: SizeConfig.defaultSize * 8),
            child: Container(
              height: SizeConfig.defaultSize * 40,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Row(
                    children: [
                      Text(
                        "PROFILE INFO",
                        style: TextStyle(
                            fontSize: SizeConfig.defaultSize * 7,
                            color: darkColor,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: SizeConfig.defaultSize * 6,
                      ),
                      InkWell(
                        child: Hero(
                          tag: _showProfileInfo,
                          child: Icon(
                            Icons.edit,
                            color: darkColor,
                            size: SizeConfig.defaultSize * 6,
                          ),
                        ),
                        onTap: () {
                          Navigator.of(context)
                              .push(HeroDialogRoute(builder: (context) {
                            return UpdateProfileInformation(
                                userInfo: widget.userInfo);
                          }));
                        },
                      )
                    ],
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                            text: "Name ",
                            style: TextStyle(
                                color: darkColor, fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.userInfo!["name"] +
                                " " +
                                widget.userInfo!["surname"],
                            style: const TextStyle(color: backgroundColor)),
                      ],
                    ),
                  ),
                  RichText(
                    text: TextSpan(
                      children: <TextSpan>[
                        const TextSpan(
                            text: "Email ",
                            style: TextStyle(
                                color: darkColor, fontWeight: FontWeight.bold)),
                        TextSpan(
                            text: widget.userInfo!["email"],
                            style: const TextStyle(color: backgroundColor)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

const String _showBookInfo = 'show-book-info';
const String _showProfileInfo = 'show-profile-info';

class UpdateBookInformation extends StatefulWidget {
  Map<String, dynamic>? bookInfo;
  UpdateBookInformation({Key? key, required this.bookInfo}) : super(key: key);

  @override
  State<UpdateBookInformation> createState() => _UpdateBookInformationState();
}

class _UpdateBookInformationState extends State<UpdateBookInformation> {
  @override
  Widget build(BuildContext context) {
    final _controllerBookName =
        TextEditingController(text: widget.bookInfo!["bookName"]);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Hero(
          tag: _showBookInfo,
          child: SingleChildScrollView(
            child: Container(
              height: SizeConfig.defaultSize * 90,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.elliptical(
                      SizeConfig.defaultSize * 9, SizeConfig.defaultSize * 9),
                ),
                color: lightColor,
              ),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Book Name",
                        style: TextStyle(
                            color: darkColor,
                            fontSize: SizeConfig.defaultSize * 12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Enter a memory book name",
                        fillColor: backgroundColor,
                        filled: true,
                        border: InputBorder.none,
                      ),
                      cursorColor: darkColor,
                      style: TextStyle(
                        fontSize: SizeConfig.defaultSize * 7,
                      ),
                      controller: _controllerBookName,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.defaultSize * 7,
                  ),
                  IconButton(
                    onPressed: () async {
                      bool isUpdated = await Database().updateMemoryBook(
                          widget.bookInfo!["ownerId"],
                          _controllerBookName.text.toString());
                      if (isUpdated == true) {
                        SmartDialog.show(
                          widget: Container(
                            height: SizeConfig.defaultSize * 15,
                            width: SizeConfig.defaultSize * 50,
                            decoration: BoxDecoration(
                              color: darkColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Book Name Updated',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.pop(context);
                      } else {
                        const Center(
                          child: CircularProgressIndicator(
                            color: darkColor,
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.check_rounded,
                      size: SizeConfig.defaultSize * 10,
                      color: darkColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UpdateProfileInformation extends StatefulWidget {
  Map<String, dynamic>? userInfo;
  UpdateProfileInformation({Key? key, required this.userInfo})
      : super(key: key);

  @override
  State<UpdateProfileInformation> createState() =>
      _UpdateProfileInformationState();
}

class _UpdateProfileInformationState extends State<UpdateProfileInformation> {
  bool passwordCheckObscureText = true;
  @override
  Widget build(BuildContext context) {
    final _controllerName =
        TextEditingController(text: widget.userInfo!["name"]);
    final _controllerSurname =
        TextEditingController(text: widget.userInfo!["surname"]);
    final _controllerEmail =
        TextEditingController(text: widget.userInfo!["email"]);
    final _controllerPassword =
        TextEditingController(text: widget.userInfo!["password"]);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Hero(
          tag: _showProfileInfo,
          child: SingleChildScrollView(
            child: Container(
              height: SizeConfig.defaultSize * 190,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.elliptical(
                      SizeConfig.defaultSize * 9, SizeConfig.defaultSize * 9),
                ),
                color: lightColor,
              ),
              child: Column(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "Profile Information",
                        style: TextStyle(
                            color: darkColor,
                            fontSize: SizeConfig.defaultSize * 12),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Enter your name",
                        fillColor: backgroundColor,
                        filled: true,
                        border: InputBorder.none,
                      ),
                      cursorColor: darkColor,
                      style: TextStyle(
                        fontSize: SizeConfig.defaultSize * 7,
                      ),
                      controller: _controllerName,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Enter your surname",
                        fillColor: backgroundColor,
                        filled: true,
                        border: InputBorder.none,
                      ),
                      cursorColor: darkColor,
                      style: TextStyle(
                        fontSize: SizeConfig.defaultSize * 7,
                      ),
                      controller: _controllerSurname,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: TextField(
                      enabled: false,
                      maxLines: 1,
                      decoration: const InputDecoration(
                        hintText: "Enter your email",
                        fillColor: backgroundColor,
                        filled: true,
                        border: InputBorder.none,
                      ),
                      cursorColor: darkColor,
                      style: TextStyle(
                        fontSize: SizeConfig.defaultSize * 7,
                      ),
                      controller: _controllerEmail,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(15.0),
                    child: TextField(
                      maxLines: 1,
                      decoration: InputDecoration(
                        hintText: "Enter your password",
                        fillColor: backgroundColor,
                        filled: true,
                        border: InputBorder.none,
                        suffixIcon: InkWell(
                          child: Icon(
                            Icons.visibility,
                            color: darkColor,
                          ),
                          onTap: () {
                            setState(() {
                              passwordCheckObscureText =
                                  !passwordCheckObscureText;
                            });
                          },
                        ),
                      ),
                      obscureText: passwordCheckObscureText,
                      cursorColor: darkColor,
                      style: TextStyle(
                        fontSize: SizeConfig.defaultSize * 7,
                      ),
                      controller: _controllerPassword,
                    ),
                  ),
                  IconButton(
                    onPressed: () async {
                      bool? isUpdated;
                      if (_controllerName.text.isNotEmpty &&
                          _controllerSurname.text.isNotEmpty &&
                          _controllerEmail.text.isNotEmpty &&
                          _controllerPassword.text.isNotEmpty) {
                        isUpdated = await Database().updateUserInfo(
                            widget.userInfo!["uid"],
                            ({
                              "name": _controllerName.text.toString(),
                              "surname": _controllerSurname.text.toString(),
                              "password": _controllerPassword.text.toString()
                            }));
                      }
                      if (isUpdated == true) {
                        SmartDialog.show(
                          widget: Container(
                            height: SizeConfig.defaultSize * 15,
                            width: SizeConfig.defaultSize * 50,
                            decoration: BoxDecoration(
                              color: darkColor,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            alignment: Alignment.center,
                            child: const Text(
                              'Information Updated',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                        await Future.delayed(const Duration(seconds: 2));
                        Navigator.pop(context);
                      } else {
                        const Center(
                          child: CircularProgressIndicator(
                            color: darkColor,
                          ),
                        );
                      }
                    },
                    icon: Icon(
                      Icons.check_rounded,
                      size: SizeConfig.defaultSize * 10,
                      color: darkColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
