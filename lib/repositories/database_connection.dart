import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseConnection{
  setDatabase() async{
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_rentalz_sqflite-v4');
    var database =
      await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  _onCreatingDatabase(Database database, int version) async{
    await database.execute(
        "CREATE TABLE categories(id INTEGER PRIMARY KEY, name TEXT, description TEXT)"
      );

    await database.execute(
        "CREATE TABLE bedrooms(id INTEGER PRIMARY KEY, name TEXT, description TEXT)"
      );

    await database.execute(
        "CREATE TABLE furnitures(id INTEGER PRIMARY KEY, name TEXT, description TEXT)"
      );

    // create apartment todos
    await database.execute(
        'CREATE TABLE apartments(id INTEGER PRIMARY KEY, title TEXT, description TEXT , rent TEXT, reporter TEXT , todoDate TEXT , category TEXT , bedroom TEXT, furniture TEXT , isFinished INTEGER)'
      );
    }
  }





