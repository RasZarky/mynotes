import 'dart:async';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'crud_exception.dart';


class NotesService {
  Database? _db;

  List<DatabaseNotes> _notes = [];

  static final NotesService _shared = NotesService._sharedInstance();
  NotesService._sharedInstance();
  factory NotesService() => _shared;

  final _notesStreamController =
  StreamController<List<DatabaseNotes>>.broadcast();

  Stream<List<DatabaseNotes>> get allNotes => _notesStreamController.stream;

  Future<DatabaseUser> getOrCreateUser({required String email}) async {
    try{
      final user = await getUser(email: email);
      return user;
    } on CouldNotDeleteUser{
      final createdUser = await createUser(email: email);
      return createdUser;
    } catch (e){
      rethrow;
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes.toList();
    _notesStreamController.add(_notes);
  }

  Future<DatabaseNotes> updateNote({
    required DatabaseNotes note,
    required String text,
  }) async {
    await _ensureDbIsOpen();
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
        final updatedNote = await getNote(id: note.id);
        _notes.removeWhere((note) => note.id == updatedNote.id);
        _notes.add(updatedNote);
        _notesStreamController.add(_notes);
        return updatedNote;
      }
  }

  Future<Iterable<DatabaseNotes>> getAllNotes() async{
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
        notesTable,
    );

    return notes.map((noteRow) => DatabaseNotes.fromRow(noteRow));

  }

  Future<DatabaseNotes> getNote({required int id}) async{
    await _ensureDbIsOpen();
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
       final note = DatabaseNotes.fromRow(notes.first);
       _notes.removeWhere((note) => note.id == id);
       _notes.add(note);
       _notesStreamController.add(_notes);
       return note;
    }
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletion = db.delete(notesTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletion;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deleteCount = await db.delete(
      notesTable,
      where: "id = ?",
      whereArgs: [id],
    );
    if (deleteCount == 0){
      throw CouldNotDeleteNote();
    } else {
      _notes.removeWhere((note) => note.id == id);
      _notesStreamController.add(_notes);
    }
  }

  Future<DatabaseNotes> createNote({required DatabaseUser owner}) async  {
    await _ensureDbIsOpen();
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

    _notes.add(note);
    _notesStreamController.add(_notes);

    return note;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
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
    await _ensureDbIsOpen();
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
    await _ensureDbIsOpen();
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

  Future<void> _ensureDbIsOpen() async{
    try {
      await open();
    } on DatabaseAlreadyOpenException{

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

        await _cacheNotes();

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