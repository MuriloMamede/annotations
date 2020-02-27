import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'Helper/AnnotationHelper.dart';
import 'model/Annotation.dart';
import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  var _db = AnnotationHelper();
  List<Annotation> _annotations = List<Annotation>();

  _showRegisterScreen({Annotation annotation}){
    String textSaveUpdate = "";
    if(annotation == null){//saving
      _titleController.text ="";
      _descriptionController.text="";
      textSaveUpdate = "Save";
    }else{//updating
      _titleController.text = annotation.title;
      _descriptionController.text= annotation.description;
      textSaveUpdate = "Update";
    }
    showDialog(
        context: context,
      builder: (context){
          return AlertDialog(
            title: Text("$textSaveUpdate annotation"),
            content: SingleChildScrollView(
                          child: Column(
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
            ),
            actions: <Widget>[
              FlatButton(
                onPressed: ()=> Navigator.pop(context),
                child: Text("Cancel"),
              ),
              FlatButton(
                onPressed: (){

                  _saveUpdateAnnotation(annotationSelected: annotation);
                  Navigator.pop(context);
                },
                child: Text(textSaveUpdate),
              )
            ],
          );
      }
    );
  }

  _recoveryAnnotation() async{

    List annotationsRecovered = await _db.recoveryAnnotation();

    List<Annotation> tempList = List<Annotation>();
    for(var item in annotationsRecovered){
      Annotation annotation = Annotation.fromMap(item);
      tempList.add(annotation);
    }
    setState(() {
      _annotations = tempList;

    });
    tempList = null;


  }




  _saveUpdateAnnotation( {Annotation annotationSelected}) async{

    String title = _titleController.text;
    String description = _descriptionController.text;
    if(annotationSelected == null){
      Annotation annotation = Annotation(title,description,DateTime.now().toString());
      int result = await _db.saveAnnotation(annotation);
    }else{
      annotationSelected.title = title;
      annotationSelected.description = description;
      int qtdUpdated = await _db.updateAnnotation(annotationSelected);
    }
    _titleController.clear();
    _descriptionController.clear();




    _recoveryAnnotation();
  }

  @override
  void initState(){
    super.initState();
    _recoveryAnnotation();
  }
  _formatDate(String date){

    initializeDateFormatting("pt_BR");

    //var formater = DateFormat("d/MM/y H:m");

    var formater = DateFormat.yMd("pt_BR");
    DateTime convertedDate = DateTime.parse(date);
    String formatedDate = formater.format( convertedDate);
    return formatedDate;
  }

  _removeAnnotation(int id) async{

    await _db.removeAnnotation(id);
    _recoveryAnnotation();
  }

  Widget createCard(context, index){
    final item = _annotations[index];
    return  Card(

    child:  Dismissible(

          background: Container( color: Colors.red,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Icon(
                  Icons.delete,
                  color: Colors.white,
                )
              ],
            ),
          ),
          direction: DismissDirection.endToStart,
          onDismissed: (direction){

            _removeAnnotation(item.id);
            setState(() {
              _annotations.removeAt(index);
            });
          },
          key: Key(item.id.toString()),
          child: ListTile(
            title: Text( item.title),
            subtitle: Text("${_formatDate(item.date)} - ${item.description}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[

                GestureDetector(
                  onTap: (){
                    _showRegisterScreen(annotation: item);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right: 16),
                    child: Icon(
                      Icons.edit,
                      color: Colors.green,
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }
  @override
  Widget build(BuildContext context) {

    _recoveryAnnotation();
    return Scaffold(
      appBar: AppBar(
        title: Text("Take a Note"),
        backgroundColor: Colors.lightGreen,
      ),
      body:  Column(
          children: <Widget>[
            Expanded(
              child: ListView.builder(
                itemCount: _annotations.length,
                itemBuilder: createCard
              )
      ),
              ],
            ),
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
