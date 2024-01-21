part of 'note_bloc.dart';

abstract class NoteState {}

class NoteInitialState extends NoteState {}

class NoteLoadingState extends NoteState {}

class NoteErrorState extends NoteState {}

class NoteLoadedState extends NoteState {}
