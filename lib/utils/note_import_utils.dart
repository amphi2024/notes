import 'dart:convert';

import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_quill/quill_delta.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:markdown/markdown.dart' as md;
import 'package:markdown_quill/markdown_quill.dart';
import 'package:notes/components/note_editor/embed_block/audio/audio_block_embed.dart';
import 'package:notes/components/note_editor/embed_block/video/video_block_embed.dart';
import 'package:notes/providers/tables_provider.dart';
import 'package:notes/utils/select_file_utils.dart';

import '../components/note_editor/embed_block/divider/divider_block_embed.dart';
import '../components/note_editor/embed_block/image/image_block_embed.dart';
import '../components/note_editor/embed_block/table/note_table_block_embed.dart';
import '../models/table_data.dart';

extension ImportExtension on QuillController {
  Future<void> importNote({required String noteId, required String fileContent, required WidgetRef ref}) async {
    try {
      final delta = Delta();
      final data = jsonDecode(fileContent);
      final content = data["content"] ?? ["contents"];
      if (content is List<dynamic>) {
        for (var item in content) {
          final value = item["value"];

          switch (item["type"]) {
            case "img":
              if (value is String) {
                var split = value.split(";");
                if (split.length > 2) {
                  // !BASE64;jpg;abc.....
                  final file = await createdImageFileWithBase64(noteId, split[2], ".${split[1]}");
                  final block = BlockEmbed.custom(ImageBlockEmbed(file.path));
                  delta.insert(block.toJson());
                }
              }
              break;
            case "video":
              if (value is String) {
                var split = value.split(";");
                if (split.length > 2) {
                  // !BASE64;mp4;abc.....
                  final file = await createdVideoFileWithBase64(noteId, split[2], ".${split[1]}");
                  final block = BlockEmbed.custom(VideoBlockEmbed(file.path));
                  delta.insert(block.toJson());
                }
              }
              break;
            case "audio":
              if (value is String) {
                var split = value.split(";");
                if (split.length > 2) {
                  // !BASE64;mp3;abc.....
                  final file = await createdAudioFileWithBase64(noteId, split[2], ".${split[1]}");
                  final block = BlockEmbed.custom(AudioBlockEmbed(file.path));
                  delta.insert(block.toJson());
                }
              }
              break;
            case "table":
              final id = ref.read(tablesProvider.notifier).generatedId();
              ref.read(tablesProvider.notifier).insertTable(id, TableData.fromMap(item));
              BlockEmbed blockEmbed = BlockEmbed.custom(NoteTableBlockEmbed(id));
              delta.insert(blockEmbed.toJson());
              break;
            case "divider":
              BlockEmbed blockEmbed = BlockEmbed.custom(DividerBlockEmbed(""));
              delta.insert(blockEmbed.toJson());
              break;
          // TODO: Add support for file
            default:
              delta.insert(value, item["style"]);
              break;
          }
        }

        document.compose(delta, ChangeSource.local);
      }
    } catch (_) {}
  }

  void importMarkdown(String fileContent) {
    final mdDocument = md.Document(encodeHtml: false);
    final mdToDelta = MarkdownToDelta(markdownDocument: mdDocument);
    final convertedDelta = mdToDelta.convert(fileContent);

    final delta = Delta();
    for(var item in convertedDelta.toList()) {
      final value = item.value;
      if(value is Map<String, dynamic>) {
        final imageSrc = value["image"];
        if(imageSrc is String) {
          if(imageSrc.startsWith("https://")) {
            // TODO: Download external image URLs and embed them into the note
          }
        }
      }
      else {
        delta.insert(item.value, item.attributes);
      }
    }

    document.compose(delta, ChangeSource.local);
  }
}
