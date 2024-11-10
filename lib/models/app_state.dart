import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/models/folder.dart';

final appState = AppState.getInstance();

class AppState {

  static final AppState _instance = AppState._internal();

  AppState._internal();

  static AppState getInstance() => _instance;

  late void Function( void Function() ) notifySomethingChanged;
 // List<String> history = [""];
  //Folder? showingFolder;
  List<Folder?> history = [null];

  late NoteEditingController noteEditingController;

  double noteListScrollPosition = 0;

}