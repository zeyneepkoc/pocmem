import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class Database {
  final CollectionReference usersRef =
      FirebaseFirestore.instance.collection("users");
  final CollectionReference memoryBookRef =
      FirebaseFirestore.instance.collection("memoryBook");
  final CollectionReference memoriesRef =
      FirebaseFirestore.instance.collection("memories");
  final CollectionReference plansRef =
      FirebaseFirestore.instance.collection("plans");
  final Reference storageRef = FirebaseStorage.instance.ref();

  Future createUser(String uid, Map<String, dynamic> userInformation) async {
    try {
      usersRef.doc(uid).set({
        "uid": uid,
        "email": userInformation["email"].toString(),
        "password": userInformation["password"].toString(),
        "name": userInformation["name"].toString(),
        "surname": userInformation["surname"].toString(),
      });
      memoryBookRef.doc(uid).set({
        "ownerId": uid,
        "bookName": "My PocMem",
      });
    } catch (e) {}
  }

  Future<bool> createMemory(
      String? uid, Map<String, dynamic> memoryInformation) async {
    bool isCreated = false;
    try {
      final doc = memoriesRef.doc(uid).collection("userMemories").doc();
      await doc.set({
        "memoryId": doc.id,
        "ownerId": uid,
        "timestamp": DateTime.now(),
        "date": memoryInformation["date"],
        "heading": memoryInformation["heading"],
        "memoryText": memoryInformation["memoryText"],
        "photo": [],
        "audio": [],
        "video": [],
      });
      String memoryId = doc.id;
      List media =
          await createMediaInFirestore(uid!, memoryInformation, memoryId);
      await doc.update({
        "photo": media[0],
        "audio": media[1],
        "video": media[2],
      });
      isCreated = true;
    } catch (e) {
      isCreated = false;
    }
    return Future<bool>.value(isCreated);
  }

  Future createMediaInFirestore(String uid,
      Map<String, dynamic> memoryInformation, String memoryId) async {
    List imageList = [], audioList = [], videoList = [];
    try {
      for (File image in memoryInformation["media"][0]) {
        UploadTask uploadTask = storageRef
            .child(uid)
            .child(memoryId)
            .child("photo")
            .child("image_${DateTime.now().millisecondsSinceEpoch}")
            .putFile(image);
        final snapshot = await uploadTask.whenComplete(() => {});
        final url = await snapshot.ref.getDownloadURL();
        imageList.add(url);
      }
      for (File audio in memoryInformation["media"][1]) {
        UploadTask uploadTask = storageRef
            .child(uid)
            .child(memoryId)
            .child("audio")
            .child("audio_${DateTime.now().millisecondsSinceEpoch}")
            .putFile(audio);
        final snapshot = await uploadTask.whenComplete(() => {});
        final url = await snapshot.ref.getDownloadURL();
        audioList.add(url);
      }
      for (File video in memoryInformation["media"][2]) {
        UploadTask uploadTask = storageRef
            .child(uid)
            .child(memoryId)
            .child("video")
            .child("video_${DateTime.now().millisecondsSinceEpoch}")
            .putFile(video);
        final snapshot = await uploadTask.whenComplete(() => {});
        final url = await snapshot.ref.getDownloadURL();
        videoList.add(url);
      }
    } catch (e) {}
    return [imageList, audioList, videoList];
  }

  createPlan(String? uid, Map<String, dynamic> planInformation) async {
    bool isCreated = false;
    try {
      final doc = plansRef
          .doc(uid)
          .collection("userPlans_" + planInformation["year"])
          .doc();
      await doc.set({
        "planId": doc.id,
        "ownerId": uid,
        // add timestamp
        "date": DateTime.now(),
        "year": planInformation["year"],
        "planText": planInformation["planText"],
        "steps": planInformation["steps"],
        "control": planInformation["control"],
      });
      isCreated = true;
    } catch (e) {
      isCreated = false;
      SmartDialog.showToast(e.toString());
    }
    return Future<bool>.value(isCreated);
  }

  Future disabledDates(String? uid) async {
    var _memoryDoc =
        await memoriesRef.doc(uid).collection("userMemories").doc().get();
    Map<String, dynamic>? data = _memoryDoc.data();
    var _value = data!["date"];
    return _value;
  }

  Stream<QuerySnapshot> getMemories(String? uid, bool descending) async* {
    var _memoriesSnapshot = memoriesRef
        .doc(uid)
        .collection("userMemories")
        .orderBy("date", descending: descending)
        .snapshots();
    yield* _memoriesSnapshot;
  }

  Stream<QuerySnapshot> searchMemories(String? uid, String search) async* {
    var _searchMemoriesSnapshot = memoriesRef
        .doc(uid)
        .collection("userMemories")
        .orderBy("heading")
        .startAt([search]).endAt([search + '\uf8ff']).snapshots();
    yield* _searchMemoriesSnapshot;
  }

  Stream<QuerySnapshot> getPhoto(String? uid) async* {
    var _snapshot = memoriesRef
        .doc(uid)
        .collection("userMemories")
        .where("photo", isNotEqualTo: []).snapshots();
    yield* _snapshot;
  }

  Stream<QuerySnapshot> getPhotoInformation(String? uid, String? url) async* {
    var _snapshot = memoriesRef
        .doc(uid)
        .collection("userMemories")
        .where("photo", arrayContains: url)
        .snapshots();
    yield* _snapshot;
  }

  Stream<QuerySnapshot> getVideo(String? uid) async* {
    var _snapshot = memoriesRef
        .doc(uid)
        .collection("userMemories")
        .where("video", isNotEqualTo: []).snapshots();
    yield* _snapshot;
  }

  Stream<QuerySnapshot> getVideoInformation(String? uid, String? url) async* {
    var _snapshot = memoriesRef
        .doc(uid)
        .collection("userMemories")
        .where("video", arrayContains: url)
        .snapshots();
    yield* _snapshot;
  }

  Stream<QuerySnapshot> getAudio(String? uid) async* {
    var _snapshot = memoriesRef
        .doc(uid)
        .collection("userMemories")
        .where("audio", isNotEqualTo: []).snapshots();
    yield* _snapshot;
  }

  Stream<QuerySnapshot> getAudioInformation(String? uid, String? url) async* {
    var _snapshot = memoriesRef
        .doc(uid)
        .collection("userMemories")
        .where("audio", arrayContains: url)
        .snapshots();
    yield* _snapshot;
  }

  Stream<QuerySnapshot> getPlans(String? uid, String year) async* {
    var _plansSnapshot = plansRef
        .doc(uid)
        .collection("userPlans_" + year)
        .orderBy("date", descending: true)
        .snapshots();
    yield* _plansSnapshot;
  }

  Stream<QuerySnapshot> searchPlans(
      String? uid, String year, String search) async* {
    var _searchPlansSnapshot = plansRef
        .doc(uid)
        .collection("userPlans_" + year)
        .orderBy("planText")
        .startAt([search]).endAt([search + '\uf8ff']).snapshots();
    yield* _searchPlansSnapshot;
  }

  Future<bool> deleteMemory(String? uid, String memoryId) {
    bool isDeleted = false;
    try {
      storageRef
          .child(uid!)
          .child(memoryId)
          .delete()
          .then((value) => print("başarıyla silindi"));
      memoriesRef.doc(uid).collection("userMemories").doc(memoryId).delete();
      print("sil" + uid + " " + memoryId);
      isDeleted = true;
    } catch (e) {
      isDeleted = false;
    }
    return Future<bool>.value(isDeleted);
  }

  Future<bool> updateMemory(
      String? uid, Map<String, dynamic> memoryInformation) async {
    bool isUpdated = false;
    try {
      List media = await createMediaInFirestore(
          uid!, memoryInformation, memoryInformation["memoryId"]);
      await memoriesRef
          .doc(uid)
          .collection("userMemories")
          .doc(memoryInformation["memoryId"])
          .update({
        "heading": memoryInformation["heading"],
        "memoryText": memoryInformation["memoryText"],
        "photo": media[0],
        "audio": media[1],
        "video": media[2],
      });
      isUpdated = true;
    } catch (e) {
      isUpdated = false;
    }
    return Future<bool>.value(isUpdated);
  }

  Future<bool> updatePlan(
      String? uid, Map<String, dynamic> planInformation) async {
    bool isUpdated = false;
    try {
      await plansRef
          .doc(uid)
          .collection("userPlans_" + planInformation["year"])
          .doc(planInformation["planId"])
          .update({
        "planText": planInformation["planText"],
        "steps": planInformation["steps"],
        "control": planInformation["control"],
      });
      isUpdated = true;
    } catch (e) {
      isUpdated = false;
    }
    return Future<bool>.value(isUpdated);
  }

  Future<bool> updateMemoryBook(String? uid, String bookName) async {
    bool isUpdated = false;
    try {
      await memoryBookRef.doc(uid).update({"bookName": bookName});
      isUpdated = true;
    } catch (e) {
      isUpdated = false;
    }
    return Future<bool>.value(isUpdated);
  }

  Future<bool> updateUserInfo(String? uid, Map<String, dynamic> userInformation) async {
    bool isUpdated = false;
    try {
      await usersRef.doc(uid).update({
        "name": userInformation["name"],
        "surname": userInformation["surname"],
        "password":userInformation["password"],
      });
      isUpdated = true;
    } catch (e) {
      isUpdated = false;
    }
    return Future<bool>.value(isUpdated);
  }
}
