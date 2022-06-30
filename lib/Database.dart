import 'dart:async';



import 'package:sqflite/sqflite.dart';


class SQLiteDbProvider {
  SQLiteDbProvider._(); 

  static final SQLiteDbProvider db = SQLiteDbProvider._(); 
  
  static Database _database; 

  Future<Database> get database 
}
