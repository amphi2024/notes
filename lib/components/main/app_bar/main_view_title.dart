import 'package:amphi/models/app.dart';
import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/icons.dart';

class MainViewTitle extends StatefulWidget {
  final String? title;
  final int notesCount;
  final void Function()? onEditNotes;
  const MainViewTitle({super.key, this.title, required this.notesCount, this.onEditNotes});

  @override
  State<MainViewTitle> createState() => _MainViewTitleState();
}

class _MainViewTitleState extends State<MainViewTitle> {
  bool fileCountVisibility = false;

  @override
  Widget build(BuildContext context) {
    if (appStorage.selectedNotes == null) {
      return Builder(builder: (context) {
        return GestureDetector(
            onTap: () {
              setState(() {
                fileCountVisibility = !fileCountVisibility;
              });
            },
            child: Padding(
              padding: const EdgeInsets.only(left: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: 110),
                    child: Text(
                      widget.title == null ? AppLocalizations.of(context).get("@notes") : widget.title!,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 750),
                    opacity: fileCountVisibility ? 1.0 : 0.0,
                    curve: Curves.easeOutQuint,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        "${widget.notesCount}",
                        style: TextStyle(
                          color: Theme.of(context).disabledColor,
                          fontSize: 14,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Visibility(
                    visible: App.isWideScreen(context),
                    child: AnimatedOpacity(
                      duration: const Duration(milliseconds: 750),
                      opacity: fileCountVisibility ? 1.0 : 0.0,
                      curve: Curves.easeOutQuint,
                      child: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          if (widget.onEditNotes != null && App.isWideScreen(context)) {
                            widget.onEditNotes!();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ));
      });
    } else {
      return Align(
        alignment: Alignment.topLeft,
        child: IconButton(
          icon: Icon(AppIcons.check),
          onPressed: () {
            appState.notifySomethingChanged(() {
              appStorage.selectedNotes = null;
            });
          },
        ),
      );
    }
  }
}
