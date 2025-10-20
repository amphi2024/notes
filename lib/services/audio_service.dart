import 'package:media_kit/media_kit.dart';
import '../utils/attachment_path.dart';

final audioService = AudioService.getInstance();

class AudioState {
  bool isPlaying = false;
  final Player player = Player();

  AudioState(String noteId, String filename) {
    player.open(Media(noteAudioPath(noteId, filename)), play: false);
  }

}

class AudioService {
  static AudioService _instance = AudioService();

  static AudioService getInstance() => _instance;

  String noteId = "";
  Map<String, AudioState> audio = {};

  void clear() {
    audio.forEach((key, value) => value.player.dispose());
    audio.clear();
  }

  AudioState get(String filename) {
    return audio.putIfAbsent(filename, () => AudioState(noteId, filename));
  }

  void refresh(String filename) {
    get(filename).player.dispose();
    audio[filename] = AudioState(noteId, filename);
  }
}