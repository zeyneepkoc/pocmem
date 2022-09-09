import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:jiffy/jiffy.dart';

String convertTimestampToDate(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String dayAndMonth =
      Jiffy(dateTime).format("d") + " " + Jiffy(dateTime).format("MMMM");
  String year = Jiffy(dateTime).format("yyyy");
  return dayAndMonth + " " + year;
}

List<String> convertTimestampToDateList(Timestamp timestamp) {
  DateTime dateTime = timestamp.toDate();
  String day = Jiffy(dateTime).format("EEEE");
  String dayAndMonth =
      Jiffy(dateTime).format("d") + " " + Jiffy(dateTime).format("MMMM");
  String year = Jiffy(dateTime).format("yyyy");
  return [day, dayAndMonth, year];
}
