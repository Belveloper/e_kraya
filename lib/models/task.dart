class Task{

  final String name;
  bool isDone;
  Task({this.name,this.isDone=false});

  void toggleDone(){
    this.isDone=!this.isDone;
  }

  Task.fromMap(Map map) :
        this.isDone=map['isDone'],
        this.name=map['name'];

Map toMap(){

  return {
    'name':this.name,
    'isDone':this.isDone,
  };
  }
}

