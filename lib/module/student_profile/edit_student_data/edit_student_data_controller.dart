import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:tahfeez_app/model/WhatsappMassage.dart';

class EditStudentDataController extends GetxController {
  TextEditingController firstNameEditController = TextEditingController();
  TextEditingController midNameEditController = TextEditingController();
  TextEditingController lastNameEditController = TextEditingController();
  TextEditingController DOBEditController = TextEditingController();
  TextEditingController phoneEditController = TextEditingController();
  TextEditingController IdnEditController = TextEditingController();
  String? imagePath;
  final formKey = GlobalKey<FormState>();

  getStudentData() async {
    var r = await myFierstor.getStudentData(
        mEmail: Get.arguments['memorizerEmail'],
        idn: Get.arguments['studentIDn']);

    firstNameEditController.text = r['f_name'];
    midNameEditController.text = r['m_name'];
    lastNameEditController.text = r['l_name'];
    DOBEditController.text = r['DOB'];
    phoneEditController.text = r['phone'];
    IdnEditController.text = r['IDn'];
    imagePath = r['image'];
    return r;
  }

  Future editStudentData() async {
    var r = await myFierstor.setStudentData(
        mEmail: Get.arguments['memorizerEmail'],
        idn: Get.arguments['studentIDn'],
        data: {
          'f_name': firstNameEditController.text,
          'm_name': midNameEditController.text,
          'l_name': lastNameEditController.text,
          'DOB': DOBEditController.text,
          'phone': phoneEditController.text,
          'IDn': IdnEditController.text,
        });
  }

  Future<String> cropImage(File pickedFile) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      compressFormat: ImageCompressFormat.jpg,
      compressQuality: 100,
      aspectRatio: const CropAspectRatio(ratioX: 10, ratioY: 10),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: false,
          cropStyle: CropStyle.circle,
          aspectRatioPresets: [
            // CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            // CropAspectRatioPreset.ratio4x3,
            // CropAspectRatioPresetCustom(),
          ],
        ),
        IOSUiSettings(
          title: 'Cropper',
          aspectRatioPresets: [
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio4x3,
            // CropAspectRatioPresetCustom(),
          ],
        ),
      ],
    );
    log('${croppedFile?.path}');
    if (croppedFile != null) {
      croppedFile = croppedFile;

      // update();
      return croppedFile.path;
    }
    return Future.value(' ');
  }

  Future<String> fetchPersonImage() async {
    String path = '';
    FilePickerResult? image = await FilePicker.platform.pickFiles(
        type: FileType.image,
        withData: true,
        withReadStream: true,
        allowMultiple: false);
    if (image != null && image.files.first.path != null) {
      // path = await copyFilesToAppDirectory(
      //     oldFile: File(image.files.first.path!),
      //     subFolderName: 'Persons',
      //     newFileName:
      //         '${displayPersons[index].id}_${displayPersons[index].name}.${image.files.first.extension}');

      // editPerson(
      //   Person(
      //     id: displayPersons[index].id,
      //     name: displayPersons[index].name,
      //     color: displayPersons[index].color,
      //     picture: path,
      //   ),
      // );
    }
    update();
    return image!.files.first.path!;
  }

  uploadPersonImage(String croopedPath) async {
    // Create a storage reference from our app
    final storageRef = FirebaseStorage.instance.ref();

    var userid = await FirebaseAuth.instance.currentUser!.uid;

    final fileUploadRef = storageRef
        .child("images/$userid-${DateTime.now().microsecondsSinceEpoch}");

    var upload = await fileUploadRef.putFile(File(croopedPath));

    myFierstor.setStudentData(
        mEmail: Get.arguments['memorizerEmail'],
        idn: Get.arguments['studentIDn'],
        data: {'image': await upload.ref.getDownloadURL()});
  }

  editStudentImage() async {
    String path = await fetchPersonImage();
    String croopedPath = await cropImage(File(path));
    uploadPersonImage(croopedPath);
    // update();
  }
}
