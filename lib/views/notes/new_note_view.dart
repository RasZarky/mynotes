import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {

  @override
  void initState() {
    _notesService = NotesService();
    _textEditingController = TextEditingController();
    super.initState();
  }

  DatabaseNotes? _note;
  late final NotesService _notesService;

  late final TextEditingController _textEditingController;

  Future<DatabaseNotes> createNewNote() async{
    final existingNote = _note;
    if (existingNote != null){
      return existingNote;
    }
    final currentUser = AuthService.firebase().currentsUser;
    final email = currentUser?.email;
    final owner = await _notesService.getUser(email: email.toString());
    return await _notesService.createNote(owner: owner);
  }

  void _deleteNoteIfTextIsEmpty(){
    final note = _note;
    if (_textEditingController.text.isEmpty && note != null){
      _notesService.deleteNote(id: note.id);
    }
  }

  Future<void> _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textEditingController.text;
    if (note != null && text.isEmpty){
      await _notesService.updateNote(
          note: note,
          text: text,
      );
    }
  }

  Future<void> _textEditingControllerListener() async {
    final note = _note;
    if (note == null){
      return;
    }
    final text = _textEditingController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupControllerListener(){
    _textEditingController.removeListener(_textEditingControllerListener);
    _textEditingController.addListener(_textEditingControllerListener);
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New note"),
      ),
      body: FutureBuilder(
          future: createNewNote(),
          builder: (context, snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.done:
                _note = snapshot.data;
                _setupControllerListener();
                return TextField(
                  controller: _textEditingController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  decoration: const InputDecoration(
                    hintText: "Start typing your note..."
                  ),
                );
              default:
                return const CircularProgressIndicator();
            }
          }),
    );
  }
}
