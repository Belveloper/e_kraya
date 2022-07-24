import 'package:cloud_firestore/cloud_firestore.dart';
class DataModel{
  final String date;
  final String nomPdf;
  final String pdf;

  DataModel({this.date, this.nomPdf, this.pdf});

  List<DataModel> dataList (QuerySnapshot querySnapshot){
    return querySnapshot.docs.map((snapshot){
      final Map<String ,dynamic> datamap =snapshot.data();
      return DataModel(date: datamap['date'],nomPdf: datamap['nom_pdf'],pdf:datamap['pdf']);
    }).toList();
    }

}