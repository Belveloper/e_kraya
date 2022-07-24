import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_kraya/models/data_model.dart';
import 'package:firestore_search/firestore_search.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:focused_menu/focused_menu.dart';
import 'package:focused_menu/modals.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class SearchFileRoute extends StatefulWidget {
  @override
  _SearchFileRouteState createState() => _SearchFileRouteState();
}

class _SearchFileRouteState extends State<SearchFileRoute> {
  final _fireStore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: FirestoreSearchScaffold(
          dataListFromSnapshot: DataModel().dataList,
          searchBy: 'nom_pdf',
          firestoreCollectionName: 'Fichiers',
          builder: (context, snapshot) {
            final List<DataModel> dataList = snapshot.data;
            // var type =snapshot.data.docs;

            return ListView.builder(
                itemCount: dataList?.length ?? 0,
                itemBuilder: (context, index) {
                  final DataModel data = dataList[index];

                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Card(
                        elevation: 5,
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                data.nomPdf.endsWith('pdf') ||
                                    data.nomPdf
                                        .toString()
                                        .endsWith('docx')
                                    ? Icons.picture_as_pdf
                                    : Icons.video_collection_sharp,
                                color:
                                data.nomPdf.toString().endsWith('pdf') ||
                                    data.nomPdf
                                        .toString()
                                        .endsWith('docx')
                                    ? Colors.red.shade400
                                    : Colors.purple.shade200,
                              ),
                            ),
                            SizedBox(
                                width: 230,
                                // height:40,
                                child: Text(
                                  ' ${data.nomPdf} ',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold),
                                )),
                            Expanded(
                              child: Text(
                                '\n${data.date}',
                                style: TextStyle(fontSize: 10),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: FocusedMenuHolder(
                                    menuItems: [
                                      FocusedMenuItem(
                                          title: Text(
                                            'Supprimer',
                                            style: TextStyle(
                                                color: Colors.white),
                                          ),
                                          onPressed: () async {
                                           // launch(snapshot.data.docs[index]['pdf']);
                                         /*   await _fireStore.runTransaction(
                                                    (Transaction
                                                myTransaction) async {
                                                  await myTransaction
                                                      .delete(type[index].reference);
                                                });
                                            Fluttertoast.showToast(
                                                msg: "Fichier supprimé",
                                                toastLength:
                                                Toast.LENGTH_SHORT,
                                                gravity:
                                                ToastGravity.CENTER,
                                                timeInSecForIosWeb: 2,
                                                backgroundColor:
                                                Colors.red,
                                                textColor: Colors.white,
                                                fontSize: 16.0);*/
                                          },
                                          trailingIcon: Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                          ),
                                          backgroundColor: Colors.red)
                                    ],
                                    onPressed: null,
                                    child:
                                    Icon(Icons.more_vert_outlined)),
                              )
                            ),
                          ],
                        ),
                      ),
                    ],
                  );
                });
          }),
    );
  }
}
