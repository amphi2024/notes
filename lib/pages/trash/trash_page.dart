import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/components/draggable_page.dart';
import 'package:notes/models/note.dart';
import 'package:notes/pages/trash/trash_page_app_bar.dart';
import 'package:notes/pages/trash/trash_page_title.dart';
import 'package:notes/providers/notes_provider.dart';
import 'package:notes/providers/selected_notes_provider.dart';
import 'package:notes/views/notes_view.dart';

class TrashPage extends ConsumerWidget {
  const TrashPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes = ref.watch(selectedNotesProvider);

    return DraggablePage(
      child: PopScope(
        canPop: selectedNotes == null,
        onPopInvokedWithResult: (value, data) {
          if (selectedNotes != null) {
            ref.watch(selectedNotesProvider.notifier).endSelection();
          }
        },
        child: Scaffold(
          appBar: AppBar(
            leadingWidth: 160,
            leading: const TrashPageTitle(),
            actions: trashPageAppbarActions(context: context, selectedNotes: selectedNotes, ref: ref),
          ),
          body: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16),
            child: NotesView(idList: ref
                .watch(notesProvider)
                .trash, folder: Note(id: "!TRASH")),
          ),
        ),
      ),
    );
  }
}
