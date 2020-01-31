import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  _showRegisterScreen(){
    showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text("Add annotation"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  controller: _titleController,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Title",
                    hintText: "Type a title"
                  ),
                ),
                TextField(
                  controller: _descriptionController,
                  autofocus: false,
                  decoration: InputDecoration(
                      labelText: "Description",
                      hintText: "Type a description"
                  ),
                )
              ],
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: ()=> Navigator.pop(context),
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: (){

                  //salvar
                },
                child: Text("Save"),
              )
            ],
          );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Take a Note"),
        backgroundColor: Colors.lightGreen,
      ),
      body: Center(),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.green,
          foregroundColor: Colors.white,
          child: Icon(Icons.add),
          onPressed: (){
            _showRegisterScreen();
          }
      ),
    );
  }
}
