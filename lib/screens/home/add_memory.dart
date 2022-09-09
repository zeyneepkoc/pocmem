import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pocmem/constants/colors/color.dart';
import 'package:pocmem/models/user.dart';
import 'package:pocmem/services/database.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import '../../config/size_config.dart';
import '../../constants/class/add_media_buttons.dart';
import '../../constants/class/custom_toast.dart';
import '../../constants/class/hero_dialog.dart';

class AddMemory extends StatefulWidget {
  const AddMemory({Key? key, String? uid}) : super(key: key);

  @override
  State<AddMemory> createState() => _AddMemoryState();
}

List<File>? _imageFileList = [];
List<File>? _videoFileList = [];
List<File>? _audioFileList = [];

class _AddMemoryState extends State<AddMemory> {
  DateTime? _date;
  final TextEditingController _controllerHeading = TextEditingController();
  final TextEditingController _controllerMemoryText = TextEditingController();
  @override
  void initState() {
    super.initState();
    _imageFileList = [];
    _videoFileList = [];
    _audioFileList = [];
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserModel?>(context);
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
                        _date = null;
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
                  child: TextButton(
                    onPressed: () async {
                      bool _whichDayToEnable(DateTime date) {
                        if (date == Database().disabledDates(_user!.uid)) {
                          return false;
                        }
                        return true;
                      }

                      showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(1900),
                          lastDate: DateTime(DateTime.now().year,
                              DateTime.now().month, DateTime.now().day),
                          selectableDayPredicate: _whichDayToEnable,
                          helpText: "Tarih seç",
                          cancelText: "İptal",
                          confirmText: "Seç",
                          builder: (context, child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary: darkColor, // header background color
                                  onPrimary:
                                      Colors.white70, // header text color
                                  onSurface: backgroundColor, // body text color
                                ),
                              ),
                              child: child!,
                            );
                          }).then((date) {
                        setState(() {
                          _date = date;
                        });
                      });
                    },
                    child: Text(
                      _date == null
                          ? "Date"
                          : "${_date!.day}/${_date!.month}/${_date!.year}",
                      style: TextStyle(
                        color: darkColor,
                        fontSize: _date == null
                            ? SizeConfig.defaultSize * 8.5
                            : SizeConfig.defaultSize * 6.5,
                      ),
                    ),
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.transparent),
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
                  child: TextButton(
                    onPressed: () async {
                      if (_date != null) {
                        if (_controllerHeading.text.isNotEmpty) {
                          if (_controllerMemoryText.text.isNotEmpty) {
                            bool isMemoryCreated =
                                await Database().createMemory(
                                    _user!.uid,
                                    ({
                                      "date": _date,
                                      "heading": _controllerHeading.text,
                                      "memoryText": _controllerMemoryText.text,
                                      "media": [
                                        _imageFileList!,
                                        _audioFileList,
                                        _videoFileList
                                      ],
                                    }));
                            if (isMemoryCreated == true) {
                              _controllerHeading.clear();
                              _controllerMemoryText.clear();
                              _date = null;
                              _imageFileList = [];
                              _audioFileList = [];
                              _videoFileList = [];
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
                                    'Saved',
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
                      } else {
                        SmartDialog.showToast("",
                            debounceTemp: true,
                            widget: const CustomToast("Select a date"));
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
                                          _imageFileList!.length.toString() +
                                              "  Images",
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.defaultSize * 7,
                                            color: darkColor,
                                          ),
                                        ),
                                        Text(
                                          _audioFileList!.length.toString() +
                                              "  Audios",
                                          style: TextStyle(
                                            fontSize:
                                                SizeConfig.defaultSize * 7,
                                            color: darkColor,
                                          ),
                                        ),
                                        Text(
                                          _videoFileList!.length.toString() +
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
                                    return MediaPopupCard();
                                  }));
                                }),
                            SizedBox(
                              width: SizeConfig.defaultSize * 10,
                            ),
                            addMediaButtons(Icons.video_call_rounded,
                                "Add video", selectVideo),
                          ],
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
    }
    setState(() {
      _imageFileList!.length;
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
    }
    setState(() {
      _audioFileList!.length;
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
    }
    setState(() {
      _videoFileList!.length;
    });
  }
}

const String _showMedias = 'show-medias';

class MediaPopupCard extends StatefulWidget {
  MediaPopupCard({
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
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3),
                            children: [
                              for (File image in _imageFileList!) {image.path}
                            ]
                                .map(
                                  (image) => Card(
                                    color: Colors.white70,
                                    child: Stack(
                                      children: <Widget>[
                                        Image(
                                          image: FileImage(
                                            File(image.toString().substring(1,
                                                image.toString().length - 1)),
                                          ),
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
                                            onTap: () {},
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
                                  for (File video in _videoFileList!) {video}
                                ]
                                    .map(
                                      (video) => Card(
                                        color: Colors.white70,
                                        child: Stack(
                                          children: <Widget>[
                                            const Center(),
                                            Positioned(
                                              top: 0,
                                              right: 0,
                                              child: InkWell(
                                                child: Icon(
                                                  Icons.close,
                                                  size: SizeConfig.defaultSize *
                                                      7,
                                                ),
                                                onTap: () {},
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
                                      for (File auido in _audioFileList!)
                                        {auido.path}
                                    ]
                                        .map(
                                          (video) => Card(
                                            color: Colors.white70,
                                            child: Stack(
                                              children: <Widget>[
                                                const Center(),
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
                                                    onTap: () {},
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
          color:
              selectedMedia == index ? Colors.deepPurple[400] : Colors.black45,
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
