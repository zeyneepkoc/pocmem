import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:pocmem/models/plan_steps.dart';
import 'package:pocmem/services/database.dart';
import 'package:provider/provider.dart';

import '../../../config/size_config.dart';
import '../../../constants/class/custom_toast.dart';
import '../../../constants/colors/color.dart';
import '../../../models/user.dart';
import '../add_memory.dart';

class EditPlan extends StatefulWidget {
  Map<String, dynamic>? planInfo;
  EditPlan({Key? key, this.planInfo}) : super(key: key);
  @override
  State<EditPlan> createState() => _EditPlanState();
}

class _EditPlanState extends State<EditPlan> {
  final TextEditingController _controllerPlanText = TextEditingController();
  int step = 0;
  List<StepModel> stepModelList = [];

  @override
  void initState() {
    _controllerPlanText.text = widget.planInfo!["planText"];
    step = widget.planInfo!["steps"].length;
    for (int i = 0; i < step; i++) {
      stepModelList.add(StepModel(
        check: widget.planInfo!["steps"][i]["stepCheck"],
        text: widget.planInfo!["steps"][i]["stepText"],
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final _user = Provider.of<UserModel?>(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    margin: EdgeInsets.only(
                        top: SizeConfig.defaultSize * 5,
                        left: SizeConfig.defaultSize * 4),
                    width: SizeConfig.defaultSize * 37,
                    height: SizeConfig.defaultSize * 15,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        setState(() {});
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
                        widget.planInfo!["year"],
                        style: TextStyle(
                            color: darkColor,
                            fontSize: SizeConfig.defaultSize * 8.5),
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
                        if (_controllerPlanText.text.isNotEmpty) {
                          bool isPlanUpdated = await Database().updatePlan(
                              widget.planInfo!["ownerId"],
                              ({
                                "planId": widget.planInfo!["planId"],
                                "year": DateTime.now().year.toString(),
                                "planText": _controllerPlanText.text,
                                "steps": stepMap(),
                                "control": planCheckControl(),
                              }));
                          if (isPlanUpdated == true) {
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
                                  'Plan Updated',
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
                        } else {
                          SmartDialog.showToast("",
                              debounceTemp: true,
                              widget: const CustomToast("Enter a text"));
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
              Column(
                children: <Widget>[
                  Container(
                    margin: const EdgeInsets.all(10),
                    height: SizeConfig.defaultSize * 30,
                    child: TextField(
                      maxLines: 5,
                      decoration: const InputDecoration(
                        hintText: "Enter a plan text",
                        fillColor: lightColor,
                        filled: true,
                        border: InputBorder.none,
                      ),
                      cursorColor: darkColor,
                      style: TextStyle(
                        fontSize: SizeConfig.defaultSize * 5.5,
                      ),
                      controller: _controllerPlanText,
                    ),
                  ),
                  SizedBox(
                    height: SizeConfig.defaultSize * 10,
                  ),
                  Container(
                    width: SizeConfig.defaultSize * 137,
                    child: Text(
                      "Steps",
                      style: TextStyle(
                          fontSize: SizeConfig.defaultSize * 6.5,
                          color: darkColor,
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        margin: const EdgeInsets.all(5),
                        height: SizeConfig.defaultSize * 10,
                        width: SizeConfig.defaultSize * 100,
                        decoration: BoxDecoration(
                            color: lightColor,
                            borderRadius: BorderRadius.circular(5)),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: step,
                            itemBuilder: (BuildContext context, int index) {
                              return Step(
                                  stepListControl() > index ? true : false);
                            }),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  step != 0 ? step-- : step;
                                  stepModelList.isNotEmpty
                                      ? stepModelList.removeLast()
                                      : stepModelList;
                                });
                              },
                              icon: const Icon(
                                Icons.remove,
                                color: darkColor,
                              )),
                          Text(
                            step.toString(),
                            style: const TextStyle(color: darkColor),
                          ),
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  step++;
                                  stepModelList.add(StepModel(check: false));
                                });
                              },
                              icon: const Icon(
                                Icons.add,
                                color: darkColor,
                              )),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    height: SizeConfig.defaultSize * 2,
                  ),
                  SizedBox(
                    height: SizeConfig.defaultSize * 195,
                    width: SizeConfig.defaultSize * 150,
                    child: ListView.builder(
                        itemCount: step,
                        itemBuilder: (BuildContext context, int index) {
                          return StepContainer(index);
                        }),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget Step(bool check) {
    return Container(
      height: SizeConfig.defaultSize * 5,
      width: SizeConfig.defaultSize * 10,
      color: check == true ? darkColor : Colors.black26,
      child: check == true
          ? const Icon(
              Icons.check,
              color: Colors.white70,
            )
          : const Icon(
              Icons.remove,
              color: Colors.black54,
            ),
    );
  }

  Widget StepContainer(int index) {
    final _controllerStepText =
        TextEditingController(text: stepModelList[index].text);
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: SizeConfig.defaultSize * 115,
            child: TextField(
              maxLines: 2,
              decoration: const InputDecoration(
                hintText: "Enter a step text",
                fillColor: lightColor,
                filled: true,
                border: InputBorder.none,
              ),
              cursorColor: darkColor,
              style: TextStyle(
                fontSize: SizeConfig.defaultSize * 5,
              ),
              controller: _controllerStepText,
              onChanged: (value){
                stepModelList[index].text = value;
              },
            ),
          ),
        ),
        IconButton(
          onPressed: () {
            setState(() {
              stepModelList[index].check = !(stepModelList[index].check);
            });
          },
          icon: Icon(
              stepModelList[index].check == false ? Icons.clear : Icons.check),
          color:
              stepModelList[index].check == false ? Colors.black26 : darkColor,
        )
      ],
    );
  }

  int stepListControl() {
    int checkIsTrue = 0;
    for (var element in stepModelList) {
      element.check == true ? checkIsTrue++ : checkIsTrue;
    }
    return checkIsTrue;
  }

  bool planCheckControl() {
    bool planCheck = true;
    for (var element in stepModelList) {
      if (element.check == false) {
        planCheck = false;
        break;
      } else {
        planCheck = true;
      }
    }
    return planCheck;
  }

  List stepMap() {
    List _list = [];
    for (var s in stepModelList) {
      _list.add({"stepText": s.text, "stepCheck": s.check});
    }
    return _list;
  }
}
