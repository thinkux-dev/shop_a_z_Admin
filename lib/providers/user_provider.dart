import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:shop_a_z/auth/auth_service.dart';
import 'package:shop_a_z/db/db_helper.dart';
import 'package:shop_a_z/models/app_user_model.dart';

class UserProvider extends ChangeNotifier {
  List<AppUserModel> userList = [];

  getAllUsers() {
    DbHelper.getAllUsers().listen((event) {
      userList = List.generate(event.docs.length, (index) =>
        AppUserModel.fromJson(event.docs[index].data()));
    });
  }
}
