import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expandable_widgets/expandable_widgets.dart';
import 'package:flutter/material.dart';
import 'package:pocmem/screens/home/plan_screen/edit_plan.dart';
import 'package:provider/provider.dart';

import '../../../config/size_config.dart';
import '../../../constants/colors/color.dart';
import '../../../models/user.dart';
import '../../../services/database.dart';

class PlanScreen extends StatefulWidget {
  const PlanScreen({Key? key}) : super(key: key);

  @override
  State<PlanScreen> createState() => _PlanScreenState();
}

class _PlanScreenState extends State<PlanScreen> {
  @override
  void initState() {
    super.initState();
    _search = "";
    _controllerSearch.clear();
    year = DateTime.now().year;
  }

  String _search = "";
  final TextEditingController _controllerSearch = TextEditingController();
  var year = DateTime.now().year;
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
          Container(
            margin: EdgeInsets.only(top: SizeConfig.defaultSize),
            width: SizeConfig.defaultSize * 55,
            height: SizeConfig.defaultSize * 15,
            child: Center(
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        year != 0 ? year -= 1 : year;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_left_rounded,
                      color: darkColor,
                    ),
                  ),
                  Text(
                    year.toString(),
                    style: TextStyle(
                        color: darkColor,
                        fontSize: SizeConfig.defaultSize * 8.5,
                        fontWeight: FontWeight.w500),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        year != DateTime.now().year ? year += 1 : year;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_right_rounded,
                      color: darkColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: SizeConfig.defaultSize * 230,
            child: StreamBuilder<QuerySnapshot>(
              stream: _search == ""
                  ? Database().getPlans(_user!.uid, year.toString())
                  : Database()
                      .searchPlans(_user!.uid, year.toString(), _search),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                return !snapshot.hasData
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: darkColor,
                        ),
                      )
                    : ListView(
                        children: snapshot.data!.docs.map((plan) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(7.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(
                                        SizeConfig.defaultSize * 3),
                                    color: backgroundColor,
                                  ),
                                  padding: const EdgeInsets.all(10.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        children: <Widget>[
                                          SizedBox(
                                            width: SizeConfig.defaultSize * 115,
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                ExpandableText(
                                                  textWidget: Text(
                                                    plan["planText"],
                                                    maxLines: 3,
                                                    textAlign:
                                                        TextAlign.justify,
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
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                ),
                                                IconButton(
                                                  onPressed: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder:
                                                                (context) =>
                                                                    EditPlan(
                                                                      planInfo:
                                                                          ({
                                                                        "ownerId":
                                                                            plan["ownerId"],
                                                                        "planId":
                                                                            plan["planId"],
                                                                        "planText":
                                                                            plan["planText"],
                                                                        "steps":
                                                                            plan["steps"],
                                                                        "year":
                                                                            plan["year"],
                                                                      }),
                                                                    )));
                                                  },
                                                  icon: const Icon(
                                                    Icons.edit,
                                                    color: Colors.white,
                                                  ),
                                                  iconSize:
                                                      SizeConfig.defaultSize *
                                                          6,
                                                )
                                              ],
                                            ),
                                          ),
                                          SizedBox(
                                            width: SizeConfig.defaultSize * 115,
                                            child: plan["steps"].length > 0
                                                ? Text(
                                                    "Steps:" +
                                                        plan["steps"]
                                                            .length
                                                            .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: darkColor),
                                                  )
                                                : null,
                                          ),
                                          SizedBox(
                                            height: plan["steps"].length > 0
                                                ? SizeConfig.defaultSize * 28
                                                : 0,
                                            width: SizeConfig.defaultSize * 120,
                                            child: ListView.builder(
                                              itemCount: plan["steps"].length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                      int index) {
                                                return Row(
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              5.0),
                                                      child: SizedBox(
                                                        width: SizeConfig
                                                                .defaultSize *
                                                            100,
                                                        child: ExpandableText(
                                                          textWidget: Text(
                                                            plan["steps"]![
                                                                        index]![
                                                                    "stepText"]
                                                                .toString(),
                                                            maxLines: 2,
                                                            textAlign: TextAlign
                                                                .justify,
                                                          ),
                                                          helperTextList: const [
                                                            '...',
                                                            '^'
                                                          ],
                                                          helper: Helper.text,
                                                          helperTextStyle:
                                                              const TextStyle(
                                                                  color:
                                                                      darkColor,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5.0),
                                                        ),
                                                      ),
                                                    ),
                                                    plan["steps"]![index]![
                                                                "stepCheck"] ==
                                                            true
                                                        ? const Icon(
                                                            Icons.check,
                                                            color: Colors.white,
                                                          )
                                                        : const Icon(
                                                            Icons.clear,
                                                            color:
                                                                Colors.black54,
                                                          )
                                                  ],
                                                );
                                              },
                                            ),
                                          ),
                                        ],
                                      ),
                                      plan["control"] == true
                                          ? const Icon(
                                              Icons.check,
                                              color: Colors.white,
                                            )
                                          : const Icon(
                                              Icons.clear,
                                              color: Colors.black54,
                                            )
                                    ],
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: SizeConfig.defaultSize * 3,
                              )
                            ],
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
