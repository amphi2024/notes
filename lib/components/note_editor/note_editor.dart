import 'dart:typed_data';

import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/components/note_editor/embed_block/divider/divider_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/image/image_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/sub_note/sub_note_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/table/note_data_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/video/video_embed_builder.dart';
import 'package:notes/components/note_editor/embed_block/view_pager/view_pager_embed_builder.dart';
import 'package:notes/components/note_editor/note_editing_controller.dart';
import 'package:notes/components/note_editor/note_editor_check_box_builder.dart';
import 'package:notes/models/note.dart';

class NoteEditor extends StatefulWidget {

  final NoteEditingController noteEditingController;

  const NoteEditor(
      {super.key, required this.noteEditingController});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  FocusNode focusNode = FocusNode();
  final ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    focusNode.dispose();
    scrollController.dispose();
    super.dispose();
  }
  // return DropTarget(
  // onDragDone: (details) async {
  // if(!widget.noteEditingController.readOnly) {
  // final files = details.files;
  // for(DropItem dropItem in files) {
  // switch(dropItem.path.split(".").last) {
  // case "jpg":
  // case "jpeg":
  // case "png":
  // case "gif":
  // File file = await Note.createdImageFile(dropItem.path);
  // final block = BlockEmbed.custom(ImageBlockEmbed(file.path));
  // appState.noteEditingController.insertBlock(block);
  // break;
  // case "mp4":
  // File file = await Note.createdVideoFile(dropItem.path);
  // final block = BlockEmbed.custom(VideoBlockEmbed(file.path));
  // appState.noteEditingController.insertBlock(block);
  // break;
  // }
  // }
  // }
  // },


  @override
  Widget build(BuildContext context) {
    final TextStyle defaultTextStyle = Theme.of(context).textTheme.bodyMedium!;
    Note note = widget.noteEditingController.note;
    final TextStyle textStyle =     TextStyle(
        color: note.textColor ?? defaultTextStyle.color,
        fontSize: note.textSize ?? defaultTextStyle.fontSize,
    fontFamily: note.font);
    return QuillEditor(
      controller: widget.noteEditingController,
      configurations: QuillEditorConfigurations(
        //autoFocus: !widget.reading,
        autoFocus: false,
        placeholder: AppLocalizations.of(context).get("@new_note"),
        customShortcuts: {

        },
        customStyles: DefaultStyles(
          paragraph: DefaultTextBlockStyle(
            textStyle,
            HorizontalSpacing(
              1, 1
          ),
            VerticalSpacing(
                1, 1
            ),
            VerticalSpacing(
               note.lineHeight ?? 1,  note.lineHeight ?? 1
            ),
            BoxDecoration(),),
          lists: DefaultListBlockStyle(
            textStyle,
            HorizontalSpacing(
              1, 1
            ),
            VerticalSpacing(
                1, 1
            ),
              VerticalSpacing(
                  note.lineHeight ?? 1,  note.lineHeight ?? 1
              ),
            BoxDecoration(),
              NoteEditorCheckboxBuilder()
          )
        ),
        onImagePaste: (Uint8List bytes) async {
          return "dsfsfsd";
        },
        showCursor: !widget.noteEditingController.readOnly,
        embedBuilders: [
          ImageEmbedBuilder(),
          VideoEmbedBuilder(),
          NoteDataEmbedBuilder(),
          SubNoteEmbedBuilder(),
          DividerEmbedBuilder(),
          ViewPagerEmbedBuilder()
          // ...FlutterQuillEmbeds.editorBuilders(
          //   imageEmbedConfigurations: QuillEditorImageEmbedConfigurations(
          //     imageErrorWidgetBuilder: (context, error, stackTrace) {
          //       return Text(
          //         'Error while loading an image: ${error.toString()}',
          //       );
          //     },
          //     imageProviderBuilder: (context, imageUrl) {
          //
          //       // cached_network_image is supported
          //       // only for Android, iOS and web
          //
          //       // We will use it only if image from network
          //       // if (isAndroid(supportWeb: false) ||
          //       //     isIOS(supportWeb: false) ||
          //       //     isWeb()) {
          //       //   // if (isHttpBasedUrl(imageUrl)) {
          //       //   //   return CachedNetworkImageProvider(
          //       //   //     imageUrl,
          //       //   //   );
          //       //   // }
          //       // }
          //       return getImageProviderByImageSource(
          //         imageUrl,
          //         imageProviderBuilder: null,
          //         context: context,
          //         assetsPrefix:
          //             QuillSharedExtensionsConfigurations.get(context: context)
          //                 .assetsPrefix,
          //       );
          //     },
          //   ),
          //   videoEmbedConfigurations: QuillEditorVideoEmbedConfigurations(
          //     // Loading YouTube videos on Desktop is not supported yet
          //     // // when using iframe platform view
          //     // youtubeVideoSupportMode: isDesktop(supportWeb: false)
          //     //     ? YoutubeVideoSupportMode.customPlayerWithDownloadUrl
          //     //     : YoutubeVideoSupportMode.iframeView,
          //   ),
          // )
        ],
      ),
      focusNode: focusNode,
      scrollController: scrollController,
    );
  }
}
