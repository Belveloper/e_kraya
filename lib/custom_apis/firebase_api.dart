import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class FirebaseApi{

  static UploadTask(String destination , File file )async{
    try{
      final ref =FirebaseStorage.instance.ref();

        return ref.putFile(file);
    }on FirebaseException catch(e){
      return null;
    }


  }
}