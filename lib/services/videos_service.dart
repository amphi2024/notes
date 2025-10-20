import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';

import '../utils/attachment_path.dart';

final videosService = VideosService.getInstance();

class VideoState {
  final Player player = Player();
  late final VideoController controller = VideoController(player);

  VideoState(String noteId, String filename) {
    player.open(Media(noteVideoPath(noteId, filename)), play: false);
    player.stream.error.listen((d) {

    });
  }
}

class VideosService {
  static VideosService _instance = VideosService();

  static VideosService getInstance() => _instance;

  String noteId = "";
  Map<String, VideoState> videos = {};

  void clear() {
    videos.forEach((key, value) => value.player.dispose());
    videos.clear();
  }

  VideoState get(String filename) {
    return videos.putIfAbsent(filename, () => VideoState(noteId, filename));
  }

  void refresh(String filename) {
    get(filename).player.dispose();
    videos[filename] = VideoState(noteId, filename);
  }
}