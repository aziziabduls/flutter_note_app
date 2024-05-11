import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/models/note.dart';
import 'package:note_app/models/note_database.dart';
import 'package:provider/provider.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  TextEditingController textEditingController = TextEditingController();

  @override
  void initState() {
    fetchNotes();
    super.initState();
  }

  // Create a note
  void createNote() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'New Note',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: textEditingController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'write a new note..',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CupertinoButton(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                        onPressed: () {
                          if (textEditingController.text.isNotEmpty ||
                              textEditingController.text != '') {
                            context
                                .read<NoteDatabase>()
                                .addNote(textEditingController.text);
                            // Clear text editing
                            textEditingController.clear();

                            fetchNotes();

                            // pop modal
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Create'),
                      ),
                      const SizedBox(height: 10),
                      CupertinoButton(
                        borderRadius: BorderRadius.circular(50),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Read all note
  void fetchNotes() async {
    context.watch<NoteDatabase>().fetchNotes();
  }

  // Update a note
  void updateNote(Note note) async {
    textEditingController.text = note.text;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Edit Note',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: textEditingController,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    hintText: 'write a new note..',
                    hintStyle: TextStyle(
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.w400,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(10),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: MediaQuery.of(context).size.width,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      CupertinoButton(
                        color: Theme.of(context).primaryColor,
                        borderRadius: BorderRadius.circular(50),
                        onPressed: () {
                          if (textEditingController.text.isNotEmpty ||
                              textEditingController.text != '') {
                            context.read<NoteDatabase>().updateNotes(
                                note.id, textEditingController.text);
                            // Clear text editing
                            textEditingController.clear();

                            fetchNotes();

                            // pop modal
                            Navigator.pop(context);
                          }
                        },
                        child: const Text('Update'),
                      ),
                      const SizedBox(height: 10),
                      CupertinoButton(
                        borderRadius: BorderRadius.circular(50),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // Delete a note
  void deleteNote(int id, Note note) async {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(12),
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Would you like to delete this note?',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.yellowAccent.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Note:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        note.text,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                CupertinoButton(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(50),
                  onPressed: () {
                    context.read<NoteDatabase>().deleteNote(id);
                    fetchNotes();
                    Navigator.pop(context);
                  },
                  child: const Text('Delete '),
                ),
                const SizedBox(height: 10),
                CupertinoButton(
                  borderRadius: BorderRadius.circular(50),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final noteDatabase = context.watch<NoteDatabase>();
    List<Note> currentNotes = noteDatabase.currentNotes;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Flutter Notes'),
      ),
      body: currentNotes.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Note is empty',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                  const Text(
                    "Let's create new note by Flutter x Isar Database.",
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 20),
                  CupertinoButton(
                    color: Theme.of(context).primaryColor,
                    borderRadius: BorderRadius.circular(50),
                    onPressed: createNote,
                    child: const Text('Create a new note'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              reverse: true,
              shrinkWrap: true,
              itemCount: currentNotes.length,
              itemBuilder: (context, index) {
                final note = currentNotes[index];
                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    border: Border.all(
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListTile(
                    onTap: () {
                      updateNote(note);
                    },
                    onLongPress: () {
                      deleteNote(note.id, note);
                    },
                    title: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Text(
                        note.text,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: Visibility(
        visible: currentNotes.isNotEmpty,
        child: FloatingActionButton(
          backgroundColor: Theme.of(context).primaryColor,
          onPressed: createNote,
          child: const Icon(
            CupertinoIcons.add,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
