import 'package:flutter/material.dart';

import '../../config/size_config.dart';
import '../colors/color.dart';

class CustomToast extends StatelessWidget {
  const CustomToast(this.msg, {Key? key}) : super(key: key);

  final String msg;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        margin: EdgeInsets.only(bottom: SizeConfig.defaultSize * 15),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
        decoration: BoxDecoration(
          color: darkColor,
          borderRadius: BorderRadius.circular(100),
        ),
        child: Text(msg, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
