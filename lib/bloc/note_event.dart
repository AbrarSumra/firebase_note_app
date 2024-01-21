import '../models/note_model.dart';

abstract class NoteEvent {}

class AddNote extends NoteEvent {
  NoteModel newNote;

  AddNote({required this.newNote});
}

class FetchNote extends NoteEvent {}

class UpdateNote extends NoteEvent {
  int index;
  NoteModel updateNote;

  UpdateNote({required this.index, required this.updateNote});
}

class DeleteNote extends NoteEvent {
  int index;

  DeleteNote({required this.index});
}
