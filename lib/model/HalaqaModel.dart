
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:tahfeez_app/sqfDB.dart';

class HalaqaModel{
  final String? id;
  final String city;
  final String center;
  final String mEmail;
  final Map<String,dynamic> memorizer;
  final List<Map<String,dynamic>> students;

  const HalaqaModel({
    this.id,
    required this.center,
    required this.city,
    required this.memorizer,
    required this.students,
    required this.mEmail
  });


  toJson()=>{"city":city,"center":center,"memorizer":memorizer, "students":students};

  factory HalaqaModel.fromSnapshot(DocumentSnapshot<Map<String,dynamic>> document){
    print(document.data());
    final data= document.data()!;
    return HalaqaModel(city: data["city"], center: data["center"], memorizer:data["memorizer"], students:data["memorizer"],mEmail: data["mEmail"]);
  }

  factory HalaqaModel.fromSnapshots(QuerySnapshot<Map<String,dynamic>> document){
    // print(document.data());
    final data= document.docs;
    return HalaqaModel(city: data[1]["city"], center: data[1]["center"], memorizer:data[1]["memorizer"], students:data[1]["memorizer"], mEmail: data[1]["mEmail"]);
  }

  

}