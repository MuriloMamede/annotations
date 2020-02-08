import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:anotacoes/model/Annotation.dart';
class AnnotationHelper{

  static final String tableName = "annotation";


  static final AnnotationHelper _annotationHelper = AnnotationHelper._internal();

  Database _db;

  factory AnnotationHelper(){
    return _annotationHelper;
  }
  AnnotationHelper._internal() {}

  get db async{

    if( _db != null ){
      return _db;
    }else{
      _db = await inicializeDB();
      return _db;
    }

  }

  _onCreate(Database db, int version ) async{
    String sql = "CREATE TABLE $tableName (id INTEGER PRIMARY KEY AUTOINCREMENT, title VARCHAR(15), description TEXT, date DATETIME);";
    await db.execute(sql);
  }


  inicializeDB()async{
    final dBPath = await getDatabasesPath();

    final dBLocal = join(dBPath, "myAnnotation.db");


    var db = await openDatabase(dBLocal, version: 1, onCreate: _onCreate);
    print(db);
    return db;
  }

  Future<int> saveAnnotation(Annotation annotation) async{

    var bd = await db;

    int result = await bd.insert(tableName, annotation.toMap());
    return result;
  }

  recoveryAnnotation() async{

    var bd = await db;
    String sql = "SELECT * FROM $tableName ORDER BY date DESC;";
    List annotations = await bd.rawQuery(sql);
    return annotations;
  }

  Future<int> updateAnnotation(Annotation annotation)async{
    var bd = await db;
    return await bd.update(
      tableName,
      annotation.toMap(),
      where: "id = ?",
      whereArgs: [annotation.id]
    );
  }

  Future<int> removeAnnotation(int id) async{
    var bd = await db;
    return await bd.delete(tableName,
    where: "id = ?",
    whereArgs:   [id]
    );
  }
}

