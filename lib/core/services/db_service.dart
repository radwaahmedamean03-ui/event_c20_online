import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_c20_online/core/models/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
class DbService {
  static var firebase = FirebaseFirestore.instance;

  // static Future<void> addEvent(EventModel event) async {
  //   var doc = await firebase.collection("Events").doc();
  //   event.id = doc.id;
  //   doc.set(event.toJson());
  // }

  static Future<List<EventModel>> getEvents(String? categoryId) async {
    List<EventModel> events = [];
    var data;
    if (categoryId == null) {
      data = await firebase.collection("Events").get();
    } else {
      data = await firebase
          .collection("Events")
          .where("categoryId", isEqualTo: categoryId)
          .get();
    }

    for (var e in data.docs) {
      var event = EventModel.fromJson(e.data());
      events.add(event);
    }

    return events;
  }

  static Stream<QuerySnapshot<Map<String, dynamic>>> getEventsStream(
      String? categoryId,) {
    // List<EventModel> events = [];
    Stream<QuerySnapshot<Map<String, dynamic>>> data;
    if (categoryId == null) {
      data = firebase.collection("Events").snapshots();
    } else {
      data = firebase
          .collection("Events")
          .where("categoryId", isEqualTo: categoryId)
          .snapshots();
    }

    return data;
  }

  static Future<List<EventModel>> getFavEvents() async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    List<EventModel> events = [];
    var data = await firebase
        .collection("Events")
        .where("usersFav", arrayContains: userId)
        .get();

    for (var e in data.docs) {
      var event = EventModel.fromJson(e.data());
      events.add(event);
    }

    return events;
  }

  static Future<void> toggleFav(EventModel event) async {
    var userId = FirebaseAuth.instance.currentUser!.uid;
    if (event.usersFav.contains(userId)) {
      event.usersFav.remove(userId);
    } else {
      event.usersFav.add(userId);
    }
    await firebase.collection("Events").doc(event.id).update(event.toJson());
  }

  static final Future<void> _googleInitialization =
  GoogleSignIn.instance.initialize();

  static Future<UserCredential> signInWithGoogle() async {
    await _googleInitialization;

    final GoogleSignInAccount googleUser =
    await GoogleSignIn.instance.authenticate();

    final GoogleSignInAuthentication googleAuth =
        googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
    );

    return FirebaseAuth.instance.signInWithCredential(credential);
  }

  static Future<void> addEvent(EventModel event) async {
    var doc = await firebase.collection("Events").doc();
    event.id = doc.id;
    await doc.set(event.toJson());
  }

  static Future<void> updateEvent(EventModel event) async {
    await firebase.collection("Events").doc(event.id).update(event.toJson());
  }
  static Future<void> deleteEvent(String eventId) async {
    await firebase.collection("Events").doc(eventId).delete();
  }
}


