import 'dart:async';
import 'dart:convert';
import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';
import 'package:mynotes/extensions/list/filter.dart';
import 'package:mynotes/services/crud/crud_exceptions.dart';
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class NotesService {
  Database? _db;

  List<DatabaseNote> _notes = [];

  DatabaseUser? _user;

  NotesService._sharedInstance() {
    _notesStreamController = StreamController<List<DatabaseNote>>.broadcast(
      onListen: () {
        _notesStreamController.sink.add(_notes);
      },
    );
  }
  static final NotesService _shared = NotesService._sharedInstance();
  factory NotesService() => _shared;

  late final StreamController<List<DatabaseNote>> _notesStreamController;

  Stream<List<DatabaseNote>> get allNotes =>
      _notesStreamController.stream.filter(
        (note) {
          final currentuser = _user;
          if (currentuser != null) {
            return note.userId == currentuser.id;
          } else {
            throw UserShouldBeSetBeforeReadingAllNotesException();
          }
        },
      );

  Future<void> _ensureDbIsOpen() async {
    try {
      await open();
    } on DatabaseAlreadyOpenException {
      //
    }
  }

  Future<DatabaseUser> getOrCreateUser({
    required String email,
    bool setAsCurrentUser = true,
  }) async {
    try {
      final user = await getUser(email: email);
      if (setAsCurrentUser) {
        _user = user;
      }
      return user;
    } on UserNotFoundException {
      devtools.log("useless UserNotFoundException catch");
      rethrow;
    } catch (e) {
      devtools.log("get user failed");
      devtools.log("on exception $e");
      if (UserNotFoundException().toString().compareTo(e.toString()) == 0) {
        final createdUser = await createUser(email: email);
        if (setAsCurrentUser) {
          _user = createdUser;
        }
        return createdUser;
      } else {
        rethrow;
      }
    }
  }

  Future<void> _cacheNotes() async {
    final allNotes = await getAllNotes();
    _notes = allNotes;
    _notesStreamController.add(_notes);
  }

  Future<void> open() async {
    if (_db != null) throw DatabaseAlreadyOpenException();
    try {
      final docsPath = await getApplicationDocumentsDirectory();
      final dbPath = join(docsPath.path, dbName);
      final db = await openDatabase(dbPath);
      _db = db;
      // TODO: File check if database file is created then move these to db creation
      // Creates user Table if not existis
      await db.execute(createUserTable);
      // Create note Table if not existis
      await db.execute(createNoteTable);
      await _cacheNotes();
    } on MissingPlatformDirectoryException {
      throw UnableToGetDocumentsDirectoryException();
    } catch (e) {
      devtools.log("Failed to open database,");
      devtools.log('on exception: $e');
    }
  }

  Future<void> close() async {
    final db = _db;
    if (db == null) throw DatabaseIsNotOpenException();
    await db.close();
    _db = null;
  }

  Database _getDatabaseOrThrow() {
    final db = _db;
    if (db == null) throw DatabaseIsNotOpenException();
    return db;
  }

  Future<void> deleteUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      userTable,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    if (deletedCount != 1) throw CouldNotDeleteUserException();
  }

  Future<List<Map<String, Object?>>> findUserByEmail(
      {required String email, required Database db}) async {
    final result = await db.query(
      userTable,
      limit: 1,
      where: 'email = ?',
      whereArgs: [email.toLowerCase()],
    );
    return result;
  }

  Future<bool> checkIfUserExistis(
      {required String email, required Database db}) async {
    final results = await findUserByEmail(email: email, db: db);
    return results.isNotEmpty ? true : false;
  }

  Future<DatabaseUser> createUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    bool isUserAlreadyExists = await checkIfUserExistis(email: email, db: db);
    if (isUserAlreadyExists) throw UserAlreadyExistsException();
    final userId =
        await db.insert(userTable, {emailColum: email.toLowerCase()});
    final createdUser = DatabaseUser(id: userId, email: email);
    return createdUser;
  }

  Future<DatabaseUser> getUser({required String email}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final results = await findUserByEmail(email: email, db: db);
    if (results.isEmpty) throw UserNotFoundException;
    final user = DatabaseUser.fromRow(results.first);
    return user;
  }

  Future<DatabaseNote> createNote({required DatabaseUser owner}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    // make sure owner exists in the database with correct id
    final dbUser = await getUser(email: owner.email);
    if (dbUser != owner) throw UserNotFoundException();

    const text = '';
    //Create note
    final noteId = await db.insert(noteTable, {
      userIdColumn: owner.id,
      textColumn: text,
      // I think is better to add this after real sync with firebase
      isSyncedWithCloudColumn: 1,
    });
    final note = DatabaseNote(
      id: noteId,
      userId: owner.id,
      text: text,
      isSyncedWithCloud: true,
    );
    _notes.add(note);
    _notesStreamController.add(_notes);
    return note;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final deletedCount = await db.delete(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (deletedCount == 0) throw CouldNotDeleteNoteException();
    _notes.removeWhere((note) => note.id == id);
    _notesStreamController.add(_notes);
  }

  Future<int> deleteAllNotes() async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final numberOfDeletions = await db.delete(noteTable);
    _notes = [];
    _notesStreamController.add(_notes);
    return numberOfDeletions;
  }

  Future<DatabaseNote> getNote({required int id}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    final notes = await db.query(
      noteTable,
      where: 'id = ?',
      whereArgs: [id],
    );
    if (notes.isEmpty) throw CouldNotFindNoteException();
    final noteFromDb = DatabaseNote.fromRow(notes.first);
    _notes.removeWhere((noteFromCache) => noteFromCache.id == id);
    _notes.add(noteFromDb);
    _notesStreamController.add(_notes);
    return noteFromDb;
  }

  Future<List<DatabaseNote>> getAllNotes() async {
    final db = _getDatabaseOrThrow();
    final notes = await db.query(noteTable);
    return notes.map((noteRow) => DatabaseNote.fromRow(noteRow)).toList();
  }

  Future<DatabaseNote> updateNote(
      {required DatabaseNote note, required String text}) async {
    await _ensureDbIsOpen();
    final db = _getDatabaseOrThrow();
    await getNote(id: note.id);
    final updatesCount = await db.update(
        noteTable,
        {
          textColumn: text,
          isSyncedWithCloudColumn: 0,
        },
        where: 'id=?',
        whereArgs: [note.id]);
    if (updatesCount == 0) throw CouldNotUpdateNoteException();
    final updatedNote = await getNote(id: note.id);
    _notes.removeWhere((cacheNote) => cacheNote.id == updatedNote.id);
    _notes.add(updatedNote);
    _notesStreamController.add(_notes);
    return updatedNote;
  }
}

@immutable
class DatabaseUser {
  final int id;
  final String email;

  const DatabaseUser({
    required this.id,
    required this.email,
  });

  DatabaseUser.fromRow(Map<String, Object?> map)
      : id = map[idColum] as int,
        email = map[emailColum] as String;
  // Same thing
  //   factory DatabaseUser.fromMap(Map<String, dynamic> map) {
  //   return DatabaseUser(
  //     id: map['id']?.toInt() ?? 0,
  //     email: map['email'] ?? '',
  //   );
  // }

  @override
  String toString() => 'DatabaseUser(id: $id, email: $email)';

  DatabaseUser copyWith({
    int? id,
    String? email,
  }) {
    return DatabaseUser(
      id: id ?? this.id,
      email: email ?? this.email,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'email': email,
    };
  }

  String toJson() => json.encode(toMap());

  factory DatabaseUser.fromJson(String source) =>
      DatabaseUser.fromRow(json.decode(source));

  @override
  bool operator ==(covariant DatabaseUser other) {
    if (identical(this, other)) return true;
    return other.id == id;
  }

  @override
  int get hashCode => id.hashCode ^ email.hashCode;
}

class DatabaseNote {
  final int id;
  final int userId;
  final String text;
  final bool isSyncedWithCloud;

  DatabaseNote({
    required this.id,
    required this.userId,
    required this.text,
    required this.isSyncedWithCloud,
  });

  DatabaseNote.fromRow(Map<String, dynamic> map)
      : id = map[idColum]?.toInt() ?? 0,
        userId = map[userIdColumn]?.toInt() ?? 0,
        text = map[textColumn] ?? '',
        isSyncedWithCloud =
            map['isSyncedWithCloud']?.toInt() == 1 ? true : false;
  // Same Thing
  // factory DatabaseNote.fromMap(Map<String, dynamic> map) {
  //   return DatabaseNote(
  //     id: map[idColum]?.toInt() ?? 0,
  //     userId: map['userId']?.toInt() ?? 0,
  //     text: map['text'] ?? '',
  //     isSyncedWithCloud: map['isSyncedWithCloud'] ?? false,
  //   );
  // }

  DatabaseNote copyWith({
    int? id,
    int? userId,
    String? text,
    bool? isSyncedWithCloud,
  }) {
    return DatabaseNote(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      text: text ?? this.text,
      isSyncedWithCloud: isSyncedWithCloud ?? this.isSyncedWithCloud,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'text': text,
      'isSyncedWithCloud': isSyncedWithCloud,
    };
  }

  String toJson() => json.encode(toMap());

  factory DatabaseNote.fromJson(String source) =>
      DatabaseNote.fromRow(json.decode(source));

  @override
  String toString() {
    return 'DatabaseNote(id: $id, userId: $userId, isSyncedWithCloud: $isSyncedWithCloud, text: $text) ';
  }

  @override
  bool operator ==(covariant DatabaseNote other) {
    if (identical(this, other)) return true;
    return other.id == id;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        userId.hashCode ^
        text.hashCode ^
        isSyncedWithCloud.hashCode;
  }
}

const dbName = "notes.db";
const noteTable = "note";
const userTable = "user";
const idColum = "id";
const emailColum = "email";
const userIdColumn = "user_id";
const textColumn = "text";
const isSyncedWithCloudColumn = 'is_synced_with_cloud';
const createUserTable = '''
              CREATE TABLE IF NOT EXISTS "user" (
                "id"	INTEGER NOT NULL,
                "email"	TEXT NOT NULL UNIQUE,
                PRIMARY KEY("id" AUTOINCREMENT)
              );
      ''';
const createNoteTable = '''
              CREATE TABLE IF NOT EXISTS "note" (
                "id"	INTEGER NOT NULL,
                "user_id"	INTEGER NOT NULL,
                "text"	TEXT,
                "is_synced_with_cloud"	INTEGER NOT NULL DEFAULT 0,
                FOREIGN KEY("user_id") REFERENCES "user"("id"),
                PRIMARY KEY("id" AUTOINCREMENT)
              );
      ''';
