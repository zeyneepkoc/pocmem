import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pocmem/screens/home/media_screen/chewie_list_item.dart';
import 'package:video_player/video_player.dart';

import '../../config/size_config.dart';
import '../../constants/class/add_media_buttons.dart';
import '../../constants/class/custom_toast.dart';
import '../../constants/class/hero_dialog.dart';
import '../../constants/colors/color.dart';
import '../../services/database.dart';
import 'add_memory.dart';

class ShowMemory extends StatefulWidget {
  Map<String, dynamic>? memoryInfo;
  ShowMemory({Key? key, this.memoryInfo}) : super(key: key);

  @override
  State<ShowMemory> createState() => _ShowMemoryState();
}

List<File>? _imageFileList = [];
List<File>? _videoFileList = [];
List<File>? _audioFileList = [];
List? _imageList = [];
List? _audioList = [];
List? _videoList = [];

class _ShowMemoryState extends State<ShowMemory> {
  final TextEditingController _controllerHeading = TextEditingController();
  final TextEditingController _controllerMemoryText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _imageFileList = [];
    _videoFileList = [];
    _audioFileList = [];
    _imageList = [];
    _audioList = [];
    _videoList = [];
    if (widget.memoryInfo!["photo"].length != 0) {
      for (int i = 0; i < widget.memoryInfo!["photo"].length; i++) {
        _imageList!.add(widget.memoryInfo!["photo"][i]);
      }
      print(_imageFileList);
    }
    if (widget.memoryInfo!["audio"].length != 0) {
      for (int i = 0; i < widget.memoryInfo!["audio"].length; i++) {
        _audioList!.add(widget.memoryInfo!["audio"][i]);
      }
      print(_audioFileList);
    }
    if (widget.memoryInfo!["video"].length != 0) {
      for (int i = 0; i < widget.memoryInfo!["video"].length; i++) {
        _videoList!.add(widget.memoryInfo!["video"][i]);
      }
      print(_videoFileList);
    }
    _controllerHeading.text = widget.memoryInfo!["heading"];
    _controllerMemoryText.text = widget.memoryInfo!["memoryText"];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.defaultSize * 5,
                      left: SizeConfig.defaultSize * 4),
                  width: SizeConfig.defaultSize * 37,
                  height: SizeConfig.defaultSize * 15,
                  child: TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        _imageFileList = [];
                        _videoFileList = [];
                        _audioFileList = [];
                        _imageList = [];
                        _audioList = [];
                        _videoList = [];
                        _controllerHeading.clear();
                        _controllerMemoryText.clear();
                      });
                    },
                    child: Text(
                      "Cancel",
                      style: TextStyle(
                        color: darkColor,
                        fontSize: SizeConfig.defaultSize * 6.5,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(lightColor),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(27),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.defaultSize * 12,
                ),
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.defaultSize * 5),
                  width: SizeConfig.defaultSize * 37,
                  height: SizeConfig.defaultSize * 15,
                  child: Center(
                    child: Text(
                      widget.memoryInfo!["date"] +
                          " " +
                          widget.memoryInfo!["year"],
                      style: TextStyle(
                          fontSize: SizeConfig.defaultSize * 6.5,
                          color: darkColor,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(
                  width: SizeConfig.defaultSize * 12,
                ),
                Container(
                  margin: EdgeInsets.only(top: SizeConfig.defaultSize * 5),
                  width: SizeConfig.defaultSize * 37,
                  height: SizeConfig.defaultSize * 15,
                  child: TextButton(
                    onPressed: () async {
                      if (_controllerHeading.text.isNotEmpty) {
                        if (_controllerMemoryText.text.isNotEmpty) {
                          bool isMemoryUpdated = await Database().updateMemory(
                              widget.memoryInfo!["ownerId"],
                              ({
                                "memoryId": widget.memoryInfo!["memoryId"],
                                "heading": _controllerHeading.text,
                                "memoryText": _controllerMemoryText.text,
                                "media": [_imageList, _audioList, _videoList],
                              }));
                          if (isMemoryUpdated == true) {
                            _controllerHeading.clear();
                            _controllerMemoryText.clear();
                            _imageFileList = [];
                            _audioFileList = [];
                            _videoFileList = [];
                            _imageList = [];
                            _audioList = [];
                            _videoList = [];
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
                                  'Memory Updated',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            );
                            await Future.delayed(const Duration(seconds: 2));
                            Navigator.pop(context);
                          }
                        } else {
                          SmartDialog.showToast("",
                              debounceTemp: true,
                              widget: const CustomToast("Enter a text"));
                        }
                      } else {
                        SmartDialog.showToast("",
                            debounceTemp: true,
                            widget: const CustomToast("Enter a heading"));
                      }
                    },
                    child: Text(
                      "Save",
                      style: TextStyle(
                        color: darkColor,
                        fontSize: SizeConfig.defaultSize * 6.5,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(lightColor),
                      shape: MaterialStateProperty.all(
                        const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(27),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: SizeConfig.defaultSize * 3,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.all(12),
                      height: SizeConfig.defaultSize * 20,
                      child: TextField(
                        maxLines: 2,
                        decoration: const InputDecoration(
                          hintText: "Enter a memory heading",
                          fillColor: lightColor,
                          filled: true,
                          border: InputBorder.none,
                        ),
                        cursorColor: darkColor,
                        style: TextStyle(
                          fontSize: SizeConfig.defaultSize * 5.5,
                        ),
                        controller: _controllerHeading,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(12),
                      height: SizeConfig.defaultSize * 100,
                      child: TextField(
                        maxLines: 250,
                        decoration: const InputDecoration(
                          hintText: "Enter a memory text",
                          fillColor: lightColor,
                          filled: true,
                          border: InputBorder.none,
                        ),
                        cursorColor: darkColor,
                        style: TextStyle(
                          fontSize: SizeConfig.defaultSize * 5.5,
                        ),
                        controller: _controllerMemoryText,
                      ),
                    ),
                    SizedBox(
                      height: SizeConfig.defaultSize * 20,
                    ),
                    Column(
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: SizeConfig.defaultSize * 10,
                            ),
                            addMediaButtons(Icons.add_photo_alternate_rounded,
                                "Add photo", selectImage),
                            SizedBox(
                              width: SizeConfig.defaultSize * 20,
                            ),
                            addMediaButtons(
                                Icons.audiotrack, "Add audio", selectAudio),
                          ],
                        ),
                        SizedBox(
                          height: SizeConfig.defaultSize * 5,
                        ),
                        Row(
                          children: <Widget>[
                            SizedBox(
                              width: SizeConfig.defaultSize * 10,
                            ),
                            InkWell(
                                child: Hero(
                                  tag: _showMedias,
                                  child: Container(
                                    height: SizeConfig.defaultSize * 50,
                                    width: SizeConfig.defaultSize * 60,
                                    decoration: BoxDecoration(
                                      color: lightColor,
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(
                                              SizeConfig.defaultSize * 4,
                                              SizeConfig.defaultSize * 4)),
                                    ),
                                    padding: EdgeInsets.symmetric(
                                        vertical: SizeConfig.defaultSize * 12),
                                    child: Column(
                                      children: <Widget>[
                                        Text(
                                          _imageList!.length.toString() +
                                              "  Images",
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.defaultSize * 7,
                                            color: darkColor,
                                          ),
                                        ),
                                        Text(
                                          _audioList!.length.toString() +
                                              "  Audios",
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.defaultSize * 7,
                                            color: darkColor,
                                          ),
                                        ),
                                        Text(
                                          _videoList!.length.toString() +
                                              "  Videos",
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.defaultSize * 7,
                                            color: darkColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  Navigator.of(context)
                                      .push(HeroDialogRoute(builder: (context) {
                                    return const MediaPopupCard();
                                  }));
                                  setState(() {
                                    _imageList!.length;
                                    _audioList!.length;
                                    _videoList!.length;
                                  });
                                }),
                            SizedBox(
                              width: SizeConfig.defaultSize * 10,
                            ),
                            addMediaButtons(Icons.video_call_rounded,
                                "Add video", selectVideo),
                          ],
                        ),
                        IconButton(
                          onPressed: () async {
                            bool isDeleted = await Database().deleteMemory(
                                widget.memoryInfo!["ownerId"],
                                widget.memoryInfo!["memoryId"]);
                            if (isDeleted == true) {
                              _controllerHeading.clear();
                              _controllerMemoryText.clear();
                              _imageList = [];
                              _audioList = [];
                              _videoList = [];
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
                                    'Deleted',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              );
                              await Future.delayed(const Duration(seconds: 2));
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: darkColor,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void selectImage() async {
    FilePickerResult? resultImage = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
    );
    if (resultImage != null) {
      _imageFileList!.addAll(
        resultImage.paths.map((imagePath) => File(imagePath!)),
      );
      _imageList!
          .addAll(resultImage.paths.map((imagePath) => File(imagePath!)));
    }
    setState(() {
      _imageList!.length;
    });
  }

  void selectAudio() async {
    FilePickerResult? resultAudio = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.audio,
    );
    if (resultAudio != null) {
      File audioFile = File(resultAudio.files.single.path!);
      _audioFileList!.add(audioFile);
      _audioList!.add(audioFile);
    }
    setState(() {
      _audioList!.length;
    });
  }

  void selectVideo() async {
    FilePickerResult? resultVideo = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.video,
    );
    if (resultVideo != null) {
      File videoFile = File(resultVideo.files.single.path!);
      _videoFileList!.add(videoFile);
      _videoList!.add(videoFile);
    }
    setState(() {
      _videoList!.length;
    });
  }
}

const String _showMedias = 'show-medias';

class MediaPopupCard extends StatefulWidget {
  const MediaPopupCard({
    Key? key,
  }) : super(key: key);

  @override
  State<MediaPopupCard> createState() => _MediaPopupCardState();
}

class _MediaPopupCardState extends State<MediaPopupCard> {
  int selectedMedia = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Hero(
          tag: _showMedias,
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
                  SizedBox(
                    height: SizeConfig.defaultSize * 2,
                  ),
                  Material(
                    color: lightColor,
                    borderRadius: BorderRadius.all(
                      Radius.elliptical(SizeConfig.defaultSize * 9,
                          SizeConfig.defaultSize * 9),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: List.generate(
                        3,
                        (index) => mediaTabBar(index),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.defaultSize * 160,
                    child: selectedMedia == 0
                        ? GridView(
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            children: [
                              for (var image in _imageList!)
                                {
                                  image.toString().contains("file_picker")
                                      ? image.path
                                      : image
                                }
                            ]
                                .map(
                                  (image) => Card(
                                    color: backgroundColor,
                                    child: Stack(
                                      children: <Widget>[
                                        image.toString().contains("file_picker")
                                            ? Image.file(
                                                File(image.toString().substring(
                                                    1,
                                                    image.toString().length -
                                                        1)),
                                                fit: BoxFit.fill,
                                              )
                                            : Image.network(
                                                image.toString().substring(
                                                    1,
                                                    image.toString().length -
                                                        1),
                                                fit: BoxFit.fill,
                                              ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: InkWell(
                                            child: Icon(
                                              Icons.close,
                                              size: SizeConfig.defaultSize * 7,
                                            ),
                                            onTap: () {
                                              setState(() {
                                                final path = image
                                                    .toString()
                                                    .substring(
                                                        1,
                                                        image
                                                                .toString()
                                                                .length -
                                                            1);
                                                final retVal = _imageFileList!
                                                    .removeWhere((file) =>
                                                        file.path == path);
                                                final retVal2 = _imageList!
                                                    .removeWhere((file) =>
                                                        file.runtimeType !=
                                                                String
                                                            ? file.path == path
                                                            : file == path);
                                                print(image.runtimeType);
                                                _imageList!.length;
                                              });
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                                .toList(),
                          )
                        : selectedMedia == 1
                            ? GridView(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                children: [
                                  for (var video in _videoList!)
                                    {
                                      video.toString().contains("file_picker")
                                          ? video.path
                                          : video
                                    }
                                ]
                                    .map(
                                      (video) => Card(
                                        color: backgroundColor,
                                        child: Stack(
                                          children: <Widget>[
                                            video
                                                    .toString()
                                                    .contains("file_picker")
                                                ? ChewieListItem(
                                                    videoPlayerController:
                                                        VideoPlayerController
                                                            .file(
                                                      File(video
                                                          .toString()
                                                          .substring(
                                                              1,
                                                              video
                                                                      .toString()
                                                                      .length -
                                                                  1)),
                                                    ),
                                                    looping: false,
                                                    showControl: false)
                                                : ChewieListItem(
                                                    videoPlayerController:
                                                        VideoPlayerController
                                                            .network(
                                                      video.toString().substring(
                                                          1,
                                                          video
                                                                  .toString()
                                                                  .length -
                                                              1),
                                                    ),
                                                    looping: false,
                                                    showControl: false,
                                                  ),
                                            Icon(
                                              Icons.play_arrow,
                                              color: darkColor,
                                            ),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: InkWell(
                                                child: Icon(
                                                  Icons.close,
                                                  size: SizeConfig.defaultSize *
                                                      7,
                                                ),
                                                onTap: () {
                                                  setState(() {
                                                    final path = video
                                                        .toString()
                                                        .substring(
                                                            1,
                                                            video
                                                                    .toString()
                                                                    .length -
                                                                1);
                                                    final retVal =
                                                        _videoFileList!
                                                            .removeWhere(
                                                                (file) =>
                                                                    file.path ==
                                                                    path);
                                                    final retVal2 = _videoList!
                                                        .removeWhere((file) =>
                                                            file.runtimeType !=
                                                                    String
                                                                ? file.path ==
                                                                    path
                                                                : file == path);
                                                    _videoFileList!.length;
                                                  });
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                    .toList(),
                              )
                            : selectedMedia == 2
                                ? GridView(
                                    gridDelegate:
                                        const SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 3),
                                    children: [
                                      for (var audio in _audioList!)
                                        {
                                          audio
                                                  .toString()
                                                  .contains("file_picker")
                                              ? audio.path
                                              : audio
                                        }
                                    ]
                                        .map(
                                          (audio) => Card(
                                            color: backgroundColor,
                                            child: Stack(
                                              children: <Widget>[
                                                const Center(
                                                    child: Icon(Icons
                                                        .audiotrack_rounded)),
                                                Positioned(
                                                  top: 0,
                                                  right: 0,
                                                  child: InkWell(
                                                    child: Icon(
                                                      Icons.close,
                                                      size: SizeConfig
                                                              .defaultSize *
                                                          7,
                                                    ),
                                                    onTap: () {
                                                      setState(() {
                                                        final path = audio
                                                            .toString()
                                                            .substring(
                                                                1,
                                                                audio
                                                                        .toString()
                                                                        .length -
                                                                    1);
                                                        final retVal =
                                                            _audioFileList!
                                                                .removeWhere(
                                                                    (file) =>
                                                                        file.path ==
                                                                        path);
                                                        final retVal2 = _audioList!
                                                            .removeWhere((file) =>
                                                                file.runtimeType !=
                                                                        String
                                                                    ? file.path ==
                                                                        path
                                                                    : file ==
                                                                        path);
                                                        _audioFileList!.length;
                                                      });
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  )
                                : Container(),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container mediaTabBar(int index) {
    return Container(
        height: SizeConfig.defaultSize * 15,
        width: SizeConfig.defaultSize * 36,
        decoration: BoxDecoration(
          color: selectedMedia == index ? backgroundColor : Colors.black45,
          borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 2),
        ),
        child: index == 0
            ? InkWell(
                child: Column(
                  children: const <Widget>[
                    Icon(
                      Icons.photo,
                      color: Colors.white,
                    ),
                    Text(
                      "Photos",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                onTap: () {
                  setState(() {
                    selectedMedia = 0;
                  });
                },
              )
            : index == 1
                ? InkWell(
                    child: Column(
                      children: const <Widget>[
                        Icon(
                          Icons.videocam,
                          color: Colors.white,
                        ),
                        Text(
                          "Videos",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    onTap: () {
                      setState(() {
                        selectedMedia = 1;
                      });
                    },
                  )
                : index == 2
                    ? InkWell(
                        child: Column(
                          children: const <Widget>[
                            Icon(
                              Icons.audiotrack,
                              color: Colors.white,
                            ),
                            Text(
                              "Audios",
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                        onTap: () {
                          setState(() {
                            selectedMedia = 2;
                          });
                        },
                      )
                    : Container());
  }
}
