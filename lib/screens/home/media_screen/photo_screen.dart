import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:pocmem/config/size_config.dart';
import 'package:pocmem/constants/class/hero_dialog.dart';
import 'package:pocmem/constants/colors/color.dart';
import 'package:provider/provider.dart';
import '../../../methods/convert_timestamp_to_date.dart';
import '../../../models/user.dart';
import '../../../services/database.dart';

class PhotoScreen extends StatefulWidget {
  const PhotoScreen({Key? key}) : super(key: key);

  @override
  State<PhotoScreen> createState() => _PhotoScreenState();
}

class _PhotoScreenState extends State<PhotoScreen> {
  String _photoUrl = "";

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserModel?>(context);
    return Column(
      children: <Widget>[
        SizedBox(
          height: SizeConfig.defaultSize * 5,
        ),
        Container(
          height: SizeConfig.defaultSize * 70,
          width: SizeConfig.defaultSize * 120,
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: lightColor,
            borderRadius: BorderRadius.circular(10),
          ),
          child: _photoUrl == ""
              ? null
              : Stack(
                  children: [
                    Center(
                      child: Image.network(
                        _photoUrl,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Positioned(
                      height: 20,
                      width: 120,
                      bottom: 2,
                      left: 3,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                            stream: Database().getPhotoInformation(
                                _user!.uid, _photoUrl.toString()),
                            builder: (BuildContext context,
                                AsyncSnapshot<dynamic> snapshot) {
                              return snapshot.hasData
                                  ? Text(convertTimestampToDate(
                                      snapshot.data.docs[0]["date"]))
                                  : Container();
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 3,
                      child: Row(
                        children: [
                          InkWell(
                            child: Icon(
                              Icons.file_download,
                              size: SizeConfig.defaultSize * 7,
                              color: Colors.black54,
                            ),
                          ),
                          InkWell(
                            child: Icon(
                              Icons.zoom_out_map,
                              size: SizeConfig.defaultSize * 7,
                              color: Colors.black45,
                            ),
                            onTap: () {
                              Navigator.of(context)
                                  .push(HeroDialogRoute(builder: (context) {
                                return ShowPhoto(photoUrl: _photoUrl);
                              }));
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
        ),
        SizedBox(
          height: SizeConfig.defaultSize * 5,
        ),
        SizedBox(
          height: SizeConfig.defaultSize * 150,
          child: StreamBuilder<QuerySnapshot>(
              stream: Database().getPhoto(_user!.uid),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: darkColor,
                    ),
                  );
                } else {
                  List<dynamic> _jsonList = json.decode(json.encode(snapshot
                      .data!.docs
                      .map((memory) => memory["photo"]
                          .map((photo) => photo.toString())
                          .toList())
                      .toList()));
                  List _photoList = [];
                  for (var value in _jsonList) {
                    if (value.runtimeType == List) {
                      for (String photo in value) {
                        _photoList.add(photo.toString());
                      }
                    } else if (value.runtimeType == String) {
                      _photoList.add(value);
                    }
                  }
                  return GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 4,
                            mainAxisSpacing: 7,
                            crossAxisSpacing: 7),
                    children: [
                      for (String photo in _photoList) {photo}
                    ]
                        .map(
                          (photo) => InkWell(
                            child: Image.network(
                              photo
                                  .toString()
                                  .substring(1, photo.toString().length - 1),
                              fit: BoxFit.cover,
                            ),
                            onTap: () {
                              setState(() {
                                _photoUrl = photo
                                    .toString()
                                    .substring(1, photo.toString().length - 1);
                              });
                            },
                          ),
                        )
                        .toList(),
                  );
                }
              }),
        ),
      ],
    );
  }
}

class ShowPhoto extends StatelessWidget {
  final String photoUrl;
  const ShowPhoto({Key? key, required this.photoUrl}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return PhotoView(
      imageProvider: NetworkImage(photoUrl),
    );
  }
}
