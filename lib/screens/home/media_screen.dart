import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:pocmem/config/size_config.dart';
import 'package:pocmem/constants/colors/color.dart';
import 'package:pocmem/screens/home/media_screen/audio_screen.dart';
import 'package:pocmem/screens/home/media_screen/video_screen.dart';

import 'media_screen/photo_screen.dart';

class MediaScreen extends StatefulWidget {
  const MediaScreen({Key? key}) : super(key: key);

  @override
  State<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends State<MediaScreen> {
  int _currentPage = 0;
  String _pageName = "Photo";
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: SizeConfig.defaultSize * 11.0),
              child: Text(
                _pageName,
                style: TextStyle(
                  color: darkColor,
                  fontWeight: FontWeight.w500,
                  fontSize: SizeConfig.defaultSize * 7.7,
                ),
              ),
            ),
            Row(
              children: List.generate(
                3,
                (index) => tabBar(index),
              ),
            ),
          ],
        ),
        SizedBox(
          height: SizeConfig.defaultSize * 255,
          width: SizeConfig.defaultSize * 125,
          child: mediaWidget(_currentPage),
        ),
      ],
    );
  }

  Row tabBar(int index) {
    return Row(
      children: [
        Container(
            height: SizeConfig.defaultSize * 15,
            width: SizeConfig.defaultSize * 15,
            decoration: BoxDecoration(
                color: _currentPage == index
                    ? Colors.deepPurple[400]
                    : Colors.black26,
                borderRadius: BorderRadius.circular(SizeConfig.defaultSize)),
            child: index == 0
                ? IconButton(
                    icon: const Icon(
                      Icons.photo,
                      color: Colors.white,
                    ),
                    tooltip: "Photo",
                    onPressed: () {
                      setState(() {
                        _currentPage = 0;
                        _pageName = "Photo";
                      });
                    },
                  )
                : index == 1
                    ? IconButton(
                        icon: const Icon(
                          Icons.videocam,
                          color: Colors.white,
                        ),
                        tooltip: "Video",
                        onPressed: () {
                          setState(() {
                            _currentPage = 1;
                            _pageName = "Video";
                          });
                        },
                      )
                    : index == 2
                        ? IconButton(
                            icon: const Icon(
                              Icons.audiotrack,
                              color: Colors.white,
                            ),
                            tooltip: "Audio",
                            onPressed: () {
                              setState(() {
                                _currentPage = 2;
                                _pageName = "Audio";
                              });
                            },
                          )
                        : null),
        SizedBox(
          width: SizeConfig.defaultSize,
        )
      ],
    );
  }

  Widget mediaWidget(int index) {
    if (index == 0) {
      return const PhotoScreen();
    } else if (index == 1) {
      return const VideoScreen();
    } else if (index == 2) {
      return const AudioScreen();
    }
    return Container();
  }
}
