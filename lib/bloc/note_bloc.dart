import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wscube_firebase/bloc/note_event.dart';
import 'package:wscube_firebase/bloc/note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  FirebaseFirestore fireStore;

  NoteBloc({required this.fireStore}) : super(NoteInitialState()) {
    FutureOr<void> fetchNoteEvent(
        FetchNote event, Emitter<NoteState> emit) async {
      emit(NoteLoadingState());
      /*emit(NoteLoadedState(
          loadedNote: await fireStore
              .collection("users")
              .doc(event.uId)
              .collection("notes")
              .get()));*/
    }
  }
}
