import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TasksTile extends StatelessWidget {
  final bool isChecked;
  final String tasktitle;
    final Function callBack;
    final Function deleteTaskCallBack;
  TasksTile({this.isChecked,this.tasktitle,this.callBack,this.deleteTaskCallBack});


@override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: deleteTaskCallBack,
      title: Text(tasktitle,style: TextStyle(decoration: isChecked ? TextDecoration.lineThrough:null),),
      trailing:  Checkbox(
        value: isChecked,
        onChanged: callBack,
        activeColor: Colors.green,

      ),

    );
  }
}
/*(bool checkboxState){
        setState(() {
          isChecked=checkboxState;
        });
          }*/
