import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:shop_a_z/db/db_helper.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shop_a_z/models/telescope_model.dart';
import 'package:shop_a_z/utils/constants.dart';

import '../models/brand_model.dart';
import '../models/image_model.dart';

class TelescopeProvider with ChangeNotifier {
  List<Brand> brandList = [];
  List<TelescopeModel> telescopeList = [];

  Future<void> addBrand(String name) {
    final brand = Brand(name: name);
    return DbHelper.addBrand(brand);
  }

  getAllBrands() {
    DbHelper.getAllBrands().listen((snapshot) {
      brandList = List.generate(snapshot.docs.length,
              (index) => Brand.fromJson(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  Future<void> addTelescope(TelescopeModel telescopeModel) {
    return DbHelper.addTelescope(telescopeModel);
  }

  getAllTelescopes() {
    DbHelper.getAllTelescopes().listen((snapshot) {
      telescopeList = List.generate(snapshot.docs.length,
              (index) => TelescopeModel.fromJson(snapshot.docs[index].data()));
      notifyListeners();
    });
  }

  TelescopeModel findTelescopeById(String id) =>
    telescopeList.firstWhere((element) => element.id == id);

  Future<void> updateTelescopeField(String id, String field, dynamic value) {
    return DbHelper.updateTelescopeField(id, {field : value});
  }

  Future<ImageModel> uploadImage(String imageLocalPath) async {
    final String imageName = 'image_${DateTime
        .now()
        .millisecondsSinceEpoch}';

    final photoRef = FirebaseStorage.instance
        .ref()
        .child('$telescopeImageDirectory$imageName');

    final uploadTask = photoRef.putFile(File(imageLocalPath));
    final snapshot = await uploadTask.whenComplete(() => null);
    final url = await snapshot.ref.getDownloadURL();
    return ImageModel(
      imageName: imageName,
      directoryName: telescopeImageDirectory,
      downloadUrl: url,
    );
  }

  Future<void> deleteImage(String id, ImageModel image) async {
    final photoRef = FirebaseStorage.instance.ref()
        .child('${image.directoryName}${image.imageName}');
    return photoRef.delete();
  }
}
