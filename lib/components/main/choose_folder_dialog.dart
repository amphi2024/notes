import 'dart:io';

import 'package:flutter/material.dart';
import 'package:notes/components/main/list_view/linear_item_border.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/extensions/sort_extension.dart';
import 'package:notes/models/app_state.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/folder.dart';
import 'package:notes/models/icons.dart';
import 'package:notes/models/note.dart';

class ChooseFolderDialog extends StatefulWidget {

  const ChooseFolderDialog({super.key});

  @override
  State<ChooseFolderDialog> createState() => _ChooseFolderDialogState();
}

class _ChooseFolderDialogState extends State<ChooseFolderDialog> {

  Map<String, List<Folder>> folderList = {};
  List<String> history = [""];

  @override
  void initState() {
    getFolders();
    super.initState();
  }

 void getFolders()  {
    Directory directory = Directory(appStorage.notesPath);
    for(FileSystemEntity file in directory.listSync()) {
      if(file.path.endsWith(".folder") && file is File) {
        bool exists = false;
        for(dynamic item in appStorage.selectedNotes!) {
          if(item is Folder && item.path == file.path) {
            exists = true;
          }
        }
        if(!exists) {
          Folder folder = Folder.fromFile(file);
          if(folderList[folder.location] == null) {
            folderList[folder.location] = [];
          }
          if(folderList[folder.filename] == null) {
            folderList[folder.filename] = [];
          }

          folderList[folder.location]!.add(folder);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if(history.isEmpty) {
      history.add("");
    }

    return Dialog(
      child: Container(
        width: 250,
        height: 500,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                    onPressed: () {},
                    icon: const Icon(AppIcons.times)),
                IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                      for( dynamic item in AppStorage.getInstance().selectedNotes!) {
                        if(item is Note) {
                          AppStorage.getNoteList(item.location).remove(item);
                          item.location = history.last;
                          item.save(changeModified: false);
                          AppStorage.getNoteList(history.last).add(item);
                        }
                        else if(item is Folder) {
                          AppStorage.getNoteList(item.location).remove(item);
                          item.location = history.last;
                          item.save(changeModified: false);
                          AppStorage.getNoteList(history.last).add(item);
                        }
                      }
                      AppStorage.getNoteList(history.last).sortByOption();
                      appState.notifySomethingChanged(() {
                        AppStorage.getInstance().selectedNotes = null;
                      });
                    },
                    icon: const Icon(AppIcons.check, size: 20))
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(top: 7.5),
              child: SizedBox(
                height: 440,
                child: ListView.builder(
                    itemCount: history.length == 1 ? folderList[history.last]!.length : folderList[history.last]!.length + 1,
                    itemBuilder: (context, index) {
                      LinearItemBorder border = LinearItemBorder(index: index, length: history.length == 1 ? folderList[history.last]!.length : folderList[history.last]!.length + 1, context: context);
                      if(index == 0 && history.length > 1) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              if(history.length > 1) {
                                history.removeLast();
                              }
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 7.5, right: 7.5),
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                border:  Border(
                                  bottom: border.borderSide,
                                ),
                                borderRadius: border.borderRadius
                            ),
                            child: Row(
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 10.0),
                                  child: Icon(
                                    AppIcons.folder,
                                    size: 25,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                  child: Text(
                                    "...",
                                    style: TextStyle(
                                        color: Theme.of(context).colorScheme.onSurface,
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }
                      else {
                        Folder folder = folderList[history.last]![history.length > 1 ? index - 1 : index];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                             history.add(folder.filename);
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(left: 7.5, right: 7.5),
                            width: double.infinity,
                            height: 60,
                            decoration: BoxDecoration(
                                color: Theme.of(context).cardColor,
                                border:  Border(
                                  bottom: border.borderSide,
                                ),
                                borderRadius: border.borderRadius
                            ),
                            child: Stack(
                              children: [
                                Row(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.only(left: 10.0),
                                      child: Icon(
                                        AppIcons.folder,
                                        size: 25,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 10.0, right: 10.0),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                        children: [
                                          Text(
                                            folder.title,
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSurface,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold
                                            ),
                                          ),
                                          Text(
                                            "${folder.modified.toLocalizedShortString(context)}   ${AppStorage.getNoteList(folder.filename).length}",
                                            style: TextStyle(
                                                color: Theme.of(context).colorScheme.onSurface,
                                                fontSize: 15
                                            ),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
