import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../icons/icons.dart';
import '../../providers/selected_notes_provider.dart';

class TrashPageTitle extends ConsumerWidget {
  const TrashPageTitle({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedNotes = ref.watch(selectedNotesProvider);
    if (selectedNotes != null) {
      return Row(
        children: [
          IconButton(
              icon: Icon(AppIcons.check),
              onPressed: () {
                ref.read(selectedNotesProvider.notifier).endSelection();
              }),
        ],
      );
    }
    return Row(
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                AppIcons.back,
                size: 25,
              ),
              Text(
                AppLocalizations.of(context).get("@trash"),
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              )
            ],
          ),
        ),
      ],
    );
  }
}
