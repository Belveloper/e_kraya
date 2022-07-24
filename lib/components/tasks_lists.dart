import 'package:e_kraya/Screens/todo_screen.dart';
import 'package:e_kraya/components/tasks_tile.dart';
import 'package:e_kraya/models/task.dart';
import 'package:flutter/material.dart';

class TasksList extends StatefulWidget {
   final List<Task> tasks;
   TasksList({this.tasks});
  @override
  _TasksListState createState() => _TasksListState();
}

class _TasksListState extends State<TasksList> {

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (context, index) {
        return TasksTile(
          tasktitle: widget.tasks[index].name,
          isChecked: widget.tasks[index].isDone,
            callBack : (checkboxState){
                setState(() {
                 widget.tasks[index].toggleDone();
                });
            },
            deleteTaskCallBack:(){deleteTask(widget.tasks[index]);} ,
        );
      },
      itemCount: widget.tasks.length,
    );
  }
  void deleteTask(Task task){

    setState(() {
      widget.tasks.remove(task);
    });
  }

}
