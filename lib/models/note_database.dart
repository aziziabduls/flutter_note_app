import 'package:flutter/material.dart';
import 'package:isar/isar.dart';
import 'package:note_app/models/note.dart';
import 'package:path_provider/path_provider.dart';

class NoteDatabase extends ChangeNotifier {
  static late Isar isar;

  // Init Database
  static Future<void> initialize() async {
    final dir = await getApplicationDocumentsDirectory();
    isar = await Isar.open([NoteSchema], directory: dir.path);
  }

  // List of notes
  final List<Note> currentNotes = [];

  // Create a note
  Future<void> addNote(String textFromUser) async {
    // Create a new note object
    final newNote = Note()..text = textFromUser;

    // Save to db
    await isar.writeTxn(() => isar.notes.put(newNote));

    // Re-read list note from db
    fetchNotes();
  }

  // Read all list note from db
  Future<void> fetchNotes() async {
    List<Note> fetchNotes = await isar.notes.where().findAll();
    currentNotes.clear();
    currentNotes.addAll(fetchNotes);

    notifyListeners();
  }

  // Update note from db
  Future<void> updateNotes(int id, String newText) async {
    final existingNote = await isar.notes.get(id);
    if (existingNote != null) {
      existingNote.text = newText;
      await isar.writeTxn(() => isar.notes.put(existingNote));
      await fetchNotes();
    }
  }

  // Delete note from db
  Future<void> deleteNote(int id) async {
    await isar.writeTxn(() => isar.notes.delete(id));
    await fetchNotes();
  }
}
