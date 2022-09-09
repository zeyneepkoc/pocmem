import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pocmem/methods/time_format.dart';
import 'package:provider/provider.dart';

import '../../../config/size_config.dart';
import '../../../constants/colors/color.dart';
import '../../../methods/convert_timestamp_to_date.dart';
import '../../../models/user.dart';
import '../../../services/database.dart';

class AudioScreen extends StatefulWidget {
  const AudioScreen({Key? key}) : super(key: key);

  @override
  State<AudioScreen> createState() => _AudioScreenState();
}

class _AudioScreenState extends State<AudioScreen> {
  String _audioUrl = "";
  final audioPlayer = AudioPlayer();
  bool isPlaying = false;
  Duration duration = Duration.zero;
  Duration position = Duration.zero;

  @override
  void initState() {
    super.initState();

    setAudio();
  }

  Future setAudio() async {
    setState(() {
      audioPlayer.setUrl(_audioUrl);
    });

    audioPlayer.onPlayerStateChanged.listen((state) {
      setState(() {
        isPlaying = state == PlayerState.PLAYING;
      });
    });

    audioPlayer.onDurationChanged.listen((newDuration) {
      setState(() {
        duration = newDuration;
      });
    });

    audioPlayer.onAudioPositionChanged.listen((newPosition) {
      setState(() {
        position = newPosition;
      });
    });
  }

  @override
  void dispose() {
    audioPlayer.dispose();
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
          child: _audioUrl == ""
              ? null
              : Stack(
                  children: [
                    Column(
                      children: [
                        Container(
                          child: const Icon(Icons.audiotrack_rounded),
                          color: Colors.black26,
                          height: SizeConfig.defaultSize * 20,
                          width: SizeConfig.defaultSize * 20,
                        ),
                        Slider(
                          value: position.inSeconds.toDouble(),
                          onChanged: (value) async {
                            final position = Duration(seconds: value.toInt());
                            await audioPlayer.seek(position);
                            await audioPlayer.resume();
                          },
                          min: 0.0,
                          max: duration.inSeconds.toDouble(),
                          activeColor: darkColor,
                          inactiveColor: backgroundColor,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: SizeConfig.defaultSize * 4.8,
                              vertical: SizeConfig.defaultSize * 0.1),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(timeFormat(position)),
                              Text(timeFormat(duration))
                            ],
                          ),
                        ),
                        CircleAvatar(
                          radius: 25,
                          child: IconButton(
                            icon: Icon(
                              isPlaying ? Icons.pause : Icons.play_arrow,
                              color: Colors.white,
                            ),
                            onPressed: () async {
                              isPlaying
                                  ? await audioPlayer.pause()
                                  : await audioPlayer.resume();
                            },
                          ),
                          backgroundColor: darkColor,
                        ),
                      ],
                    ),
                    Positioned(
                      height: 15,
                      width: 120,
                      bottom: 2,
                      left: 3,
                      child: StreamBuilder<QuerySnapshot>(
                        stream: Database().getAudioInformation(
                            _user!.uid, _audioUrl.toString()),
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
              stream: Database().getAudio(_user!.uid),
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
                      .map((memory) => memory["audio"]
                          .map((audio) => audio.toString())
                          .toList())
                      .toList()));
                  List _audioList = [];
                  for (var value in _jsonList) {
                    if (value.runtimeType == List) {
                      for (String audio in value) {
                        _audioList.add(audio.toString());
                      }
                    } else if (value.runtimeType == String) {
                      _audioList.add(value);
                    }
                  }
                  return GridView(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 7,
                            crossAxisSpacing: 7),
                    children: [
                      for (String audio in _audioList) {audio}
                    ]
                        .map(
                          (audio) => InkWell(
                            child: Container(
                              child: const Icon(Icons.audiotrack_rounded),
                              color: Colors.black12,
                            ),
                            onTap: () {
                              setState(() {
                                position = Duration.zero;
                                duration = Duration.zero;
                                _audioUrl = audio
                                    .toString()
                                    .substring(1, audio.toString().length - 1);
                                setAudio();
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
