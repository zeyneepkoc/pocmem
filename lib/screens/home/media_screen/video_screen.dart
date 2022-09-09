import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocmem/screens/home/media_screen/chewie_list_item.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../../config/size_config.dart';
import '../../../constants/colors/color.dart';
import '../../../methods/convert_timestamp_to_date.dart';
import '../../../models/user.dart';
import '../../../services/database.dart';

class VideoScreen extends StatefulWidget {
  const VideoScreen({Key? key}) : super(key: key);

  @override
  State<VideoScreen> createState() => _VideoScreenState();
}

class _VideoScreenState extends State<VideoScreen> {
  String _videoUrl = "";
  Widget _videoWidget = Container();

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
          child: _videoUrl == ""
              ? null
              : Stack(
                  children: [
                    _videoWidget,
                    Positioned(
                      height: 15,
                      width: 120,
                      bottom: 2,
                      left: 3,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: Database().getVideoInformation(
                            _user!.uid, _videoUrl.toString()),
                        builder: (BuildContext context,
                            AsyncSnapshot<dynamic> snapshot) {
                          return snapshot.hasData
                              ? Text(convertTimestampToDate(
                                  snapshot.data.docs[0]["date"]))
                              : Container();
                        },
                      ),
                    ),
                    Positioned(
                      bottom: 2,
                      right: 3,
                      child: InkWell(
                        child: Icon(
                          Icons.file_download,
                          size: SizeConfig.defaultSize * 7,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
        SizedBox(
          height: SizeConfig.defaultSize * 5,
        ),
        SizedBox(
          height: SizeConfig.defaultSize * 150,
          child: StreamBuilder<QuerySnapshot>(
              stream: Database().getVideo(_user!.uid),
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
                      .map((memory) => memory["video"]
                          .map((video) => video.toString())
                          .toList())
                      .toList()));
                  List _videoList = [];
                  for (var value in _jsonList) {
                    if (value.runtimeType == List) {
                      for (String video in value) {
                        _videoList.add(video.toString());
                      }
                    } else if (value.runtimeType == String) {
                      _videoList.add(value);
                    }
                  }
                  return GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 7,
                            crossAxisSpacing: 7),
                    children: [
                      for (String video in _videoList) {video}
                    ]
                        .map(
                          (video) => InkWell(
                            child: ChewieListItem(
                              videoPlayerController:
                                  VideoPlayerController.network(video
                                      .toString()
                                      .substring(
                                          1, video.toString().length - 1)),
                              looping: false,
                              showControl: false,
                            ),
                            onTap: () {
                              setState(() {
                                _videoUrl = video
                                    .toString()
                                    .substring(1, video.toString().length - 1);
                                _videoWidget = ChewieListItem(
                                    videoPlayerController:
                                        VideoPlayerController.network(
                                            _videoUrl),
                                    looping: false,
                                    showControl: true);
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
