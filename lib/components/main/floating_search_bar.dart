import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../providers/selected_notes_provider.dart';

class FloatingSearchBar extends ConsumerWidget {

  final FocusNode focusNode;
  const FloatingSearchBar(
      {super.key, required this.focusNode});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectingNotes = ref.watch(selectedNotesProvider) != null;
    final buttonRotated = ref.watch(floatingButtonStateProvider);
    var bottomPadding = MediaQuery.of(context).padding.bottom;
    if(bottomPadding == 0) {
      bottomPadding = 15;
    }

    return AnimatedPositioned(
      duration: Duration(milliseconds: !selectingNotes && buttonRotated ? 1000 : 1250),
      curve: Curves.easeOutQuint,
      left: !selectingNotes && buttonRotated ? 20 : -235,
      bottom: bottomPadding + 105,
      child: Container(
        width: 200,
        height: 45,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme
                    .of(context)
                    .shadowColor,
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            color: Theme
                .of(context)
                .floatingActionButtonTheme
                .backgroundColor,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: TextField(
              focusNode: focusNode,
              onChanged: (text) {
                ref.read(searchKeywordProvider.notifier).setKeyword(text);
              },
              onTapOutside: (event) {
                ref.read(searchKeywordProvider.notifier).endSearch();
              },
              decoration: InputDecoration(
                  border: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                  )
              ),
            ),
          ),
        ),
      ),
    );
  }
}