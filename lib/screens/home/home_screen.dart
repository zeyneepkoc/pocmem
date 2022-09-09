import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:jiffy/jiffy.dart';
import 'package:pocmem/config/size_config.dart';
import 'package:pocmem/constants/colors/color.dart';
import 'package:pocmem/screens/home/memory_book.dart';
import 'package:pocmem/screens/home/showMemory.dart';
import 'package:pocmem/services/database.dart';
import 'package:provider/provider.dart';

import '../../methods/convert_timestamp_to_date.dart';
import '../../models/user.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    _search = "";
    _controllerSearch.clear();
  }

  String _search = "";
  final TextEditingController _controllerSearch = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserModel?>(context);
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          SizedBox(
            height: SizeConfig.defaultSize * 7,
          ),
          Container(
            height: SizeConfig.defaultSize * 15,
            width: SizeConfig.defaultSize * 110,
            child: TextFormField(
              decoration: const InputDecoration(
                icon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                hintText: "Search",
                border: InputBorder.none,
              ),
              cursorColor: Colors.black,
              onChanged: (String value) {
                setState(() {
                  _search = value;
                });
              },
            ),
            decoration: BoxDecoration(
              color: Colors.black12,
              borderRadius: BorderRadius.circular(SizeConfig.defaultSize * 25),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: SizeConfig.defaultSize * 7,
            ),
          ),
          Divider(
            height: SizeConfig.defaultSize * 2,
          ),
          SizedBox(
            height: SizeConfig.defaultSize * 240,
            child: StreamBuilder<QuerySnapshot>(
              stream: _search == ""
                  ? Database().getMemories(_user!.uid, true)
                  : Database().searchMemories(_user!.uid, _search),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: darkColor,
                        ),
                      )
                    : ListView(
                        children: snapshot.data!.docs.map((memory) {
                          return Container(
                            padding: const EdgeInsets.all(10.0),
                            child: NeumorphicButton(
                              onPressed: () {
                                setState(() {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ShowMemory(
                                              memoryInfo: ({
                                                "ownerId": memory["ownerId"],
                                                "memoryId": memory["memoryId"],
                                                "date":
                                                    convertTimestampToDateList(
                                                            memory["date"])[1]
                                                        .toString(),
                                                "year":
                                                    convertTimestampToDateList(
                                                            memory["date"])[2]
                                                        .toString(),
                                                "heading": memory["heading"],
                                                "memoryText":
                                                    memory["memoryText"],
                                                "photo": memory["photo"],
                                                "audio": memory["audio"],
                                                "video": memory["video"],
                                              }),
                                            )),
                                  );
                                });
                              },
                              child: Column(
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: <Widget>[
                                      Text(convertTimestampToDateList(
                                              memory["date"])[0]
                                          .toString()),
                                      Text(convertTimestampToDateList(
                                              memory["date"])[1]
                                          .toString()),
                                      Text(convertTimestampToDateList(
                                              memory["date"])[2]
                                          .toString()),
                                    ],
                                  ),
                                  Divider(
                                    height: SizeConfig.defaultSize * 1.2,
                                    color: Colors.black12,
                                  ),
                                  Text(memory["heading"]),
                                  ExpandableText(
                                    textWidget: Text(
                                      memory["memoryText"],
                                      maxLines: 3,
                                      textAlign: TextAlign.justify,
                                    ),
                                    helperTextList: const ['...', '^'],
                                    helper: Helper.text,
                                    helperTextStyle: const TextStyle(
                                        color: darkColor,
                                        fontWeight: FontWeight.bold),
                                    boxShadow: const [
                                      BoxShadow(
                                          color: backgroundColor,
                                          offset: Offset(2, 2),
                                          blurRadius: 3)
                                    ],
                                    padding: const EdgeInsets.all(5.0),
                                  ),
                                  SizedBox(
                                    height: memory["photo"].length +
                                                memory["audio"].length +
                                                memory["video"].length >
                                            0
                                        ? SizeConfig.defaultSize * 5
                                        : 0,
                                  ),
                                  SizedBox(
                                    height: memory["photo"].length > 0
                                        ? SizeConfig.defaultSize * 30
                                        : 0,
                                    child: ListView.builder(
                                        scrollDirection: Axis.horizontal,
                                        itemCount: memory["photo"].length,
                                        itemBuilder: (context, index) {
                                          return SizedBox(
                                            height: SizeConfig.defaultSize * 40,
                                            width: SizeConfig.defaultSize * 40,
                                            child: Image.network(
                                              memory["photo"][index],
                                              fit: BoxFit.fill,
                                            ),
                                          );
                                        }),
                                  ),
                                  SizedBox(
                                    height: SizeConfig.defaultSize * 2,
                                  ),
                                  memory["video"].length > 0
                                      ? Text(
                                          "+" +
                                              memory["video"]
                                                  .length
                                                  .toString() +
                                              " video",
                                        )
                                      : Container(
                                          height: 0,
                                        ),
                                  memory["audio"].length > 0
                                      ? Text(
                                          "+" +
                                              memory["audio"]
                                                  .length
                                                  .toString() +
                                              " audio",
                                        )
                                      : Container(
                                          height: 0,
                                        ),
                                ],
                              ),
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                boxShape: NeumorphicBoxShape.roundRect(
                                    BorderRadius.circular(9)),
                                depth: 8,
                                color: Colors.white,
                                lightSource: LightSource.topLeft,
                              ),
                              padding: const EdgeInsets.all(10.0),
                            ),
                          );
                        }).toList(),
                      );
              },
            ),
          ),
        ],
      ),
    );
  }
}
