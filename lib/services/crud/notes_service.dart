import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'crud_exception.dart';


class NotesService {
  Database? _db;

  Future<DatabaseNotes> updateNote({
    required DatabaseNotes note,
    required String text,
  }) async {
      final db = _getDatabaseOrThrow();
      await getNote(id: note.id);
      final updateCount = await db.update(
        notesTable,
        {
          textColumn: text,
          isSyncedWithCloudColumn: 0,
        }
      );

      if (updateCount == 0){
        throw CouldNotFindNote();
      } else {
        return await getNote(id: note.id);
      }
  }

  Future<Iterable<DatabaseNotes>> getAllNotes() async{
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
        notesTable,
    );

    return notes.map((noteRow) => DatabaseNotes.fromRow(noteRow));

  }

  Future<DatabaseNotes> getNote({required int id}) async{
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      notesTable,
      limit: 1,
      where: "id = ?",
      whereArgs: [id]
    );

    if (notes.isEmpty){
      throw CouldNotFindNote();
    } else{
       return DatabaseNotes.fromRow(notes.first);
    }
  }

  Future<int> deleteAllNotes() async {
    final db = _getDatabaseOrThrow();
    return  db.delete(notesTable);
  }

  Future<void> deleteNote({required int id}) async {
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      notesTable,
      where: "id = ?",
      whereArgs: [id],
    );
    if (deleteCount == 0){
      throw CouldNotDeleteNote();
    }
  }

  Future<DatabaseNotes> createNote({required DatabaseUser owner}) async  {
    final db = await _getDatabaseOrThrow();
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner ){
      throw CouldNotDeleteUser();
    }

    const text = "";

    final noteId = await db.insert(notesTable, {
      userIdColumn: owner.id,
      textColumn: text,
      isSyncedWithCloudColumn: 1
    });
    
    final note = DatabaseNotes(
        id: noteId,
        userId: owner.id,
        text: text, isSyncedWithCloud: true);

    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    final db = _getDatabaseOrThrow();
    final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (results.isEmpty){
      throw CouldNotFindUser();
    } else {
      return DatabaseUser.fromRow(results.first);
    }
  }

  Future<DatabaseUser> createUser({required String email}) async {
    final db = _getDatabaseOrThrow();
   final results = await db.query(
      userTable,
      limit: 1,
      where: "email = ?",
      whereArgs: [email.toLowerCase()],
    );

    if (results.isNotEmpty){
      throw UserAlreadyExist();
    }

    final userId = db.insert(userTable, {
      emailColumn: email.toLowerCase(),
    });

    return DatabaseUser(id: userId as int, email: email);
  }
  
  Future<void> deleteUser({required String email})async {
    final db = _getDatabaseOrThrow();
    final deleteAccount = await db.delete(
      userTable,
      where: "email = ?",
      whereArgs: [email.toLowerCase()]
      ,);
    if (deleteAccount != 1){
      throw CouldNotDeleteUser();
    }
  }

  Database _getDatabaseOrThrow(){
    final db = _db;
    if (db == null){
      throw DatabaseNotOpenException();
    } else{
      return db;
    }
  }

  Future<void> close() async{
    final db = _db;
    if (db == null){
      throw DatabaseNotOpenException();
    } else{
      await db.close();
      _db = null;
    }
  }

  Future<void> open() async {
    if (_db != null){
      throw DatabaseAlreadyOpenException();
    } else{
      try{
        final docsPath = await getApplicationDocumentsDirectory();
        final dbPath = join(docsPath.path, dbName);
        final db = await openDatabase(dbPath);
        _db = db;

        await db.execute(createUserTable);

        await db.execute(createNotesTable);

      } on MissingPlatformDirectoryException{
          throw UnableToGetDocumentDirectoryException();
      }
    }
  }
}

class DatabaseUser{
  final int id;
  final String email;
  const DatabaseUser({required this.id, required this.email});

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        email = map[emailColumn] as String;

  @override
  String toString() => "Person, ID = $id, email = $email";

  @override bool operator == (covariant DatabaseUser other) => id == other.id;

  @override
  int get hashCode => super.hashCode;

}


class DatabaseNotes{
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;
  DatabaseNotes({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,});

  DatabaseNotes.fromRow(Map<String, Object?> map)
      : id = map[idColumn] as int,
        userId = map[userIdColumn] as int,
        text = map[textColumn] as String,
        isSyncedWithCloud = map[isSyncedWithCloudColumn as int]
            == 1 ? true : false ;

  @override
  String toString() => "Note, ID = $id, userId = $userId,"
      " isSyncedWithCloud = $isSyncedWithCloud, text = $text";

  @override bool operator == (covariant DatabaseNotes other) => id == other.id;

  @override
  int get hashCode => super.hashCode;
}

const dbName = "notes.db";
const notesTable = "notes";
const userTable = "user";
const idColumn = "id";
const emailColumn = "email";
const userIdColumn = "user_id";
const textColumn = "text";
const isSyncedWithCloudColumn = "is_synced_with_cloud";
const createNotesTable = '''CREATE TABLE "notes" (
	        "id"	INTEGER NOT NULL,
	        "user_id"	INTEGER NOT NULL,
	        "text"	TEXT,
	        "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
	        PRIMARY KEY("id" AUTOINCREMENT),
	        FOREIGN KEY("user_id") REFERENCES "user"("id")
          );''';
const createUserTable = '''CREATE TABLE IF NOT EXISTS "user" (
	        "id" INTEGER NOT NULL UNIQUE,
	        "email"	TEXT NOT NULL UNIQUE,
	        PRIMARY KEY("id" AUTOINCREMENT)
          );''';