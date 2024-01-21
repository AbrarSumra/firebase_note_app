import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wscube_firebase/models/note_model.dart';

part 'note_event.dart';
part 'note_state.dart';

class NoteBloc extends Bloc<NoteEvent, NoteState> {
  FirebaseFirestore fireStore;
  NoteBloc({required this.fireStore}) : super(NoteInitialState()) {
    on<AddNote>((event, emit) async {
      emit(NoteLoadingState());
      /*var check = await fireStore.;
      collRef.doc(widget.userId).collection("notes").add(NoteModel(
            title: titleController.text.toString(),
            desc: descController.text.toString(),
            time: DateTime.now().millisecondsSinceEpoch.toString(),
          ).toMap());*/
    });
  }
}
