import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wscube_firebase/bloc/note_event.dart';
import 'package:wscube_firebase/bloc/note_state.dart';

import '../models/note_model.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  final CollectionReference _noteCollection =
      FirebaseFirestore.instance.collection('notes');

  NoteBloc(super.initialState);

  NoteState get initialState => NoteInitialState();

  Stream<NoteState> mapEventToState(NoteEvent event) async* {
    if (event is AddNote) {
      yield* _mapAddNoteToState(event);
    } else if (event is FetchNote) {
      yield* _mapFetchNotesToState();
    }
    // Add other event handling logic here
  }

  Stream<NoteState> _mapAddNoteToState(AddNote event) async* {
    try {
      yield NoteLoadingState();
      await _noteCollection.add({
        'title': event.newNote.title,
        'desc': event.newNote.desc,
        "time": event.newNote.time,
      });
      yield* _mapFetchNotesToState(); // Fetch updated notes after adding
    } catch (e) {
      yield NoteErrorState(errorMsg: 'Failed to add note.');
    }
  }

  Stream<NoteState> _mapFetchNotesToState() async* {
    try {
      yield NoteLoadingState();
      final snapshot = await _noteCollection.get();
      final notes = snapshot.docs.map((doc) => NoteModel.fromMap).toList();
      yield NoteLoadedState(loadedNote: notes as List<NoteModel>);
    } catch (e) {
      yield NoteErrorState(errorMsg: 'Failed to fetch notes.');
    }
  }
}
