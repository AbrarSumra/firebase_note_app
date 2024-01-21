import '../models/note_model.dart';

abstract class NoteState {}

class NoteInitialState extends NoteState {}

class NoteLoadingState extends NoteState {}

class NoteErrorState extends NoteState {
  String errorMsg;

  NoteErrorState({required this.errorMsg});
}

class NoteLoadedState extends NoteState {
  List<NoteModel> loadedNote;

  NoteLoadedState({required this.loadedNote});
}
