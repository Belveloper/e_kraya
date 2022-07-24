import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:e_kraya/components/tasks_lists.dart';
import 'package:e_kraya/models/task.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ToDoRoute extends StatefulWidget {
  @override
  _ToDoRouteState createState() => _ToDoRouteState();
}

class _ToDoRouteState extends State<ToDoRoute> {

  final _auth = FirebaseAuth.instance;
  List<Task> tasks = [];
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    // TODO: implement initState
    initSharedPreferences();
    super.initState();
  }
  initSharedPreferences() async{
    sharedPreferences = await SharedPreferences.getInstance();
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    String taskTilteText;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
        showModalBottomSheet(context: context, builder: (context){

          return Container(
            padding: EdgeInsets.only(left: 50,right: 50.0),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.start,
             children: [
               Text('Ajouter une tache',style: TextStyle(fontSize: 30.0,color: Colors.green,fontWeight: FontWeight.w500,fontFamily: 'Righteous')),
               SizedBox(height: 30.0,),
               TextFormField(
                   textAlign: TextAlign.center,
                 onChanged: (value){
                     setState(() {
                       taskTilteText=value;
                     });
                 },
               ),
               SizedBox(height: 30.0,),
               TextButton(onPressed: (){
                 setState(() {
                  if(taskTilteText!=null && taskTilteText.isNotEmpty){
                   tasks.add(Task(name: taskTilteText));
                  saveData();}
                 });
                 Navigator.pop(context);
               }, child: Text("valider",style: TextStyle(color: Colors.green,fontWeight: FontWeight.w200,fontFamily: 'Righteous')),)
             ],
           ),
          );
        });
        },
        backgroundColor: Colors.green,
        child: Icon(Icons.add),
      ),
      backgroundColor: Colors.green,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: EdgeInsets.only(
                top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  child: Icon(
                    Icons.list,
                    size: 30.0,
                    color: Colors.green,
                  ),
                  radius: 30.0,
                  backgroundColor: Colors.white,
                ),
                SizedBox(
                  height: 10.0,
                ),
                Text(
                  'Votre Liste à Faire',
                  style: TextStyle(
                    fontSize: 45,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  tasks.length==1 ?'1 Tache':'${tasks.length} Taches',
                  style: TextStyle(fontSize: 18.0, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            child: GestureDetector(
              onLongPress: null,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20.0),
                      topRight: Radius.circular(20.0)),
                ),
                child: TasksList(tasks: tasks,),
                ),
            ),
            ),

        ],
      ),
    );
  }
void saveData(){
    List<String> spList =tasks.map((item) => jsonEncode(item.toMap())).toList();
    sharedPreferences.setStringList('tasks', spList);

    print(spList);
}
void loadData(){

    setState(() {
      List<String> splist= sharedPreferences.getStringList('tasks');
      tasks=splist.map((item) => Task.fromMap(jsonDecode(item))).toList();
    });
}

}



