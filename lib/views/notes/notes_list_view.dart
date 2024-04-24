import 'package:animate_do/animate_do.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';

typedef NoteCallback = void Function(CloudNote note);

class NotesListView extends StatelessWidget {
  final Iterable<CloudNote> notes;
  final NoteCallback onDeleteNote;
  final NoteCallback onTap;

  const NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      child: Container(
        padding: const EdgeInsets.only(
          top: 10,
          right: 10,
          left: 10,
        ),
        child: FadeInUp(
          duration: const Duration(milliseconds: 1000),
          child: ListView.builder(
            shrinkWrap: false,
            itemCount: notes.length,
            itemBuilder: (context, index) {
              final note = notes.elementAt(index);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(143, 148, 251, .4),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  padding: const EdgeInsets.all(15),
                  child: ListTile(
                    onTap: () {
                      onTap(note);
                    },
                    title: Text(
                      note.text,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                          fontSize: 18,
                      ),
                    ),
                    trailing: IconButton(
                      onPressed: () async {
                        final shouldDelete = await showDeleteDialog(context);
                        if (shouldDelete) {
                          onDeleteNote(note);
                        }
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}