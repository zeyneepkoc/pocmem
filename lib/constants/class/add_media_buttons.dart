import 'package:flutter/material.dart';

import '../../config/size_config.dart';
import '../colors/color.dart';

InkWell addMediaButtons(IconData icon, String text, Function() press) {
  return InkWell(
    onTap: press,
    child: Container(
      height: SizeConfig.defaultSize * 30,
      width: SizeConfig.defaultSize * 50,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: SizeConfig.defaultSize * 3),
        child: Center(
          child: Column(
            children: <Widget>[
              Icon(
                icon,
                color: darkColor,
                size: SizeConfig.defaultSize * 10,
              ),
              SizedBox(
                height: SizeConfig.defaultSize * 2,
              ),
              Text(
                text,
                style: TextStyle(
                    color: darkColor,
                    fontSize: SizeConfig.defaultSize * 7),
              ),
            ],
          ),
        ),
      ),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.all(
          Radius.elliptical(
              SizeConfig.defaultSize * 4, SizeConfig.defaultSize * 4),
        ),
      ),
    ),
  );
}