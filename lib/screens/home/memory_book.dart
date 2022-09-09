import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:pocmem/config/size_config.dart';
import 'package:pocmem/screens/home/media_screen/audio_player_item.dart';
import 'package:pocmem/services/database.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../constants/colors/color.dart';
import '../../methods/convert_timestamp_to_date.dart';
import '../../models/user.dart';
import 'media_screen/chewie_list_item.dart';

class MemoryBook extends StatefulWidget {
  Map<String, dynamic>? userInfo, bookInfo;
  MemoryBook({
    Key? key,
    required this.userInfo,
    required this.bookInfo,
  }) : super(key: key);

  @override
  State<MemoryBook> createState() => _MemoryBookState();
}

class _MemoryBookState extends State<MemoryBook> {
  final PageController _pageController = PageController();
  final PageController _pageBuilderController = PageController();
  final TextEditingController _textController = TextEditingController();
  int currentIndex = 1, memoriesCount = 0;
  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        currentIndex = _pageController.page!.toInt() + 1;
        _textController.text = currentIndex.toString();
      });
    });
  }

  jumpToPage() {
    setState(() {
      if (currentIndex.toString() != _textController.text.toString() &&
          _textController.text.isNotEmpty) {
        WidgetsBinding.instance.addPostFrameCallback((_) => _pageController
            .jumpToPage(int.parse(_textController.text.toString()) - 1));
      }
    });
  }

  jumpToPageBuilderWithIndex(int page) {
    setState(() {
      WidgetsBinding.instance
          .addPostFrameCallback((_) => _pageBuilderController.jumpToPage(page));
    });
  }

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
    return SafeArea(
        child: Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: SizeConfig.screenHeight - 30,
          color: lightColor,
          child: StreamBuilder<QuerySnapshot>(
              stream: Database().getMemories(_user.uid, false),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: darkColor,
                        ),
                      )
                    : PageView.builder(
                        controller: _pageBuilderController,
                        itemCount: 2,
                        itemBuilder: (BuildContext context, int index) {
                          return index == 0
                              ? Container(
                                  color: darkColor,
                                  child: Column(
                                    children: [
                                      Expanded(
                                        child: FittedBox(
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                SizeConfig.defaultSize * 19),
                                            child: Center(
                                              child: Text(
                                                widget.bookInfo!["bookName"],
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            21),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: EdgeInsets.symmetric(
                                              horizontal:
                                                  SizeConfig.defaultSize * 10),
                                          child: Column(
                                            children: [
                                              Text(
                                                widget.userInfo!["name"]
                                                        .toString() +
                                                    " " +
                                                    widget.userInfo!["surname"]
                                                        .toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            17),
                                              ),
                                              SizedBox(
                                                height:
                                                    SizeConfig.defaultSize * 5,
                                              ),
                                              Text(
                                                "Memory Count: " +
                                                    memoriesCount.toString(),
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        SizeConfig.defaultSize *
                                                            7),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : PageView(
                                  controller: _pageController,
                                  children: snapshot.data!.docs.map((memory) {
                                    return Padding(
                                      padding: const EdgeInsets.all(20.0),
                                      child: Stack(
                                        children: [
                                          Column(
                                            children: <Widget>[
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: <Widget>[
                                                  Text(
                                                    convertTimestampToDateList(
                                                            memory["date"])[0]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .defaultSize *
                                                            8,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                  Text(
                                                    convertTimestampToDateList(
                                                            memory["date"])[1]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .defaultSize *
                                                            8,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                  Text(
                                                    convertTimestampToDateList(
                                                            memory["date"])[2]
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .defaultSize *
                                                            8,
                                                        fontWeight:
                                                            FontWeight.w300),
                                                  ),
                                                ],
                                              ),
                                              Divider(
                                                height: SizeConfig.defaultSize *
                                                    1.2,
                                                color: Colors.black12,
                                              ),
                                              SizedBox(
                                                height:
                                                    SizeConfig.defaultSize * 9,
                                              ),
                                              ExpandableText(
                                                textWidget: Text(
                                                  memory["heading"],
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                              .defaultSize *
                                                          6.5,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                  maxLines: 2,
                                                  textAlign: TextAlign.justify,
                                                ),
                                                helperTextList: const [
                                                  '...',
                                                  '^'
                                                ],
                                                helper: Helper.text,
                                                helperTextStyle:
                                                    const TextStyle(
                                                        color: darkColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: backgroundColor,
                                                      offset: Offset(2, 2),
                                                      blurRadius: 3)
                                                ],
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                              ),
                                              SizedBox(
                                                height:
                                                    SizeConfig.defaultSize * 9,
                                              ),
                                              ExpandableText(
                                                textWidget: Text(
                                                  memory["memoryText"],
                                                  style: TextStyle(
                                                      fontSize: SizeConfig
                                                              .defaultSize *
                                                          6.5,
                                                      fontWeight:
                                                          FontWeight.w300),
                                                  maxLines: 3,
                                                  textAlign: TextAlign.justify,
                                                ),
                                                helperTextList: const [
                                                  '...',
                                                  '^'
                                                ],
                                                helper: Helper.text,
                                                helperTextStyle:
                                                    const TextStyle(
                                                        color: darkColor,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                boxShadow: const [
                                                  BoxShadow(
                                                      color: backgroundColor,
                                                      offset: Offset(2, 2),
                                                      blurRadius: 3)
                                                ],
                                                padding:
                                                    const EdgeInsets.all(5.0),
                                              ),
                                              SizedBox(
                                                height: memory["photo"].length +
                                                            memory["audio"]
                                                                .length +
                                                            memory["video"]
                                                                .length >
                                                        0
                                                    ? SizeConfig.defaultSize * 5
                                                    : 0,
                                              ),
                                              Container(
                                                height: memory["photo"].length >
                                                        0
                                                    ? SizeConfig.defaultSize *
                                                        50
                                                    : 0,
                                                color: Colors.white,
                                                child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        memory["photo"].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7.0),
                                                        child: SizedBox(
                                                          height: SizeConfig
                                                                  .defaultSize *
                                                              50,
                                                          width: SizeConfig
                                                                  .defaultSize *
                                                              50,
                                                          child: Image.network(
                                                            memory["photo"]
                                                                [index],
                                                            fit: BoxFit.fill,
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              SizedBox(
                                                height:
                                                    SizeConfig.defaultSize * 2,
                                              ),
                                              Container(
                                                height: memory["video"].length >
                                                        0
                                                    ? SizeConfig.defaultSize *
                                                        50
                                                    : 0,
                                                color: Colors.white,
                                                child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        memory["video"].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7.0),
                                                        child: SizedBox(
                                                            height: SizeConfig
                                                                    .defaultSize *
                                                                70,
                                                            width: SizeConfig
                                                                    .defaultSize *
                                                                70,
                                                            child: ChewieListItem(
                                                                videoPlayerController:
                                                                    VideoPlayerController.network(
                                                                        memory["video"]
                                                                            [
                                                                            index]),
                                                                looping: false,
                                                                showControl:
                                                                    true)),
                                                      );
                                                    }),
                                              ),
                                              SizedBox(
                                                height:
                                                    SizeConfig.defaultSize * 2,
                                              ),
                                              Container(
                                                height: memory["audio"].length >
                                                        0
                                                    ? SizeConfig.defaultSize *
                                                        60
                                                    : 0,
                                                color: Colors.white,
                                                child: ListView.builder(
                                                    scrollDirection:
                                                        Axis.horizontal,
                                                    itemCount:
                                                        memory["audio"].length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(7.0),
                                                        child: Container(
                                                          height: SizeConfig
                                                                  .defaultSize *
                                                              60,
                                                          width: SizeConfig
                                                                  .defaultSize *
                                                              60,
                                                          decoration: BoxDecoration(
                                                              border: Border.all(
                                                                  color:
                                                                      darkColor)),
                                                          child: Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(3.0),
                                                            child:
                                                                AudioPlayerItem(
                                                              audioUrl: memory[
                                                                          "audio"]
                                                                      [index]
                                                                  .toString(),
                                                            ),
                                                          ),
                                                        ),
                                                      );
                                                    }),
                                              ),
                                              const Spacer(),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  const Spacer(),
                                                  Text(
                                                    currentIndex.toString(),
                                                    style: TextStyle(
                                                        fontSize: SizeConfig
                                                                .defaultSize *
                                                            5),
                                                  ),
                                                  const Spacer(),
                                                  Row(
                                                    children: [
                                                      SizedBox(
                                                        width: SizeConfig
                                                                .defaultSize *
                                                            10,
                                                        height: SizeConfig
                                                                .defaultSize *
                                                            10,
                                                        child: TextFormField(
                                                          controller:
                                                              _textController,
                                                          onChanged: (value) {
                                                            setState(() {
                                                              jumpToPage();
                                                            });
                                                          },
                                                          decoration:
                                                              const InputDecoration(
                                                                  fillColor:
                                                                      darkColor,
                                                                  focusColor:
                                                                      darkColor),
                                                          cursorColor:
                                                              darkColor,
                                                        ),
                                                      ),
                                                      const Text(""),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ],
                                          ),
                                          Positioned(
                                            bottom: SizeConfig.defaultSize * 15,
                                            left: SizeConfig.defaultSize * 0.5,
                                            right: SizeConfig.defaultSize * 0.5,
                                            child: SizedBox(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  currentIndex != 1
                                                      ? OutlinedButton(
                                                          style: ButtonStyle(
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18.0),
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        backgroundColor),
                                                          ),
                                                          onPressed: () {
                                                            _pageController
                                                                .previousPage(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          400),
                                                              curve: Curves
                                                                  .bounceIn,
                                                            );
                                                            if (_pageController
                                                                    .page!
                                                                    .toInt() ==
                                                                0) {
                                                              jumpToPageBuilderWithIndex(
                                                                  0);
                                                            }
                                                          },
                                                          child: const Icon(
                                                            Icons
                                                                .arrow_left_rounded,
                                                            color: darkColor,
                                                          ),
                                                        )
                                                      : OutlinedButton(
                                                          style: ButtonStyle(
                                                            shape: MaterialStateProperty
                                                                .all<
                                                                    RoundedRectangleBorder>(
                                                              RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            18.0),
                                                              ),
                                                            ),
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all<Color>(
                                                                        backgroundColor),
                                                          ),
                                                          onPressed: () {
                                                            _pageController
                                                                .previousPage(
                                                              duration:
                                                                  const Duration(
                                                                      milliseconds:
                                                                          400),
                                                              curve: Curves
                                                                  .bounceIn,
                                                            );
                                                            if (_pageController
                                                                    .page!
                                                                    .toInt() ==
                                                                0) {
                                                              jumpToPageBuilderWithIndex(
                                                                  0);
                                                            }
                                                          },
                                                          child: const Text(
                                                            "Defter",
                                                            style: TextStyle(
                                                                color:
                                                                    darkColor),
                                                          ),
                                                        ),
                                                  OutlinedButton(
                                                    style: ButtonStyle(
                                                      shape: MaterialStateProperty
                                                          .all<
                                                              RoundedRectangleBorder>(
                                                        RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      18.0),
                                                        ),
                                                      ),
                                                      backgroundColor:
                                                          MaterialStateProperty
                                                              .all<Color>(
                                                                  backgroundColor),
                                                    ),
                                                    onPressed: () {
                                                      _pageController.nextPage(
                                                        duration:
                                                            const Duration(
                                                                milliseconds:
                                                                    400),
                                                        curve: Curves.bounceIn,
                                                      );
                                                    },
                                                    child: const Icon(
                                                      Icons.arrow_right_rounded,
                                                      color: darkColor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList(),
                                );
                        },
                      );
              }),
        ),
      ),
    ));
  }
}
