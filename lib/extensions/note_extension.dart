import 'dart:convert';
import 'dart:io';

import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_storage.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/dark_theme.dart';
import 'package:notes/models/light_theme.dart';
import 'package:notes/models/note.dart';
import 'package:pdf/widgets.dart' as PDF;
extension NoteExtension on Note {
  String toHTML(BuildContext context) {
    AppTheme appTheme = appSettings.appTheme!;
    LightTheme lightTheme = appTheme.lightTheme;
    DarkTheme darkTheme = appTheme.darkTheme;
    String html = """
   <!DOCTYPE html>
<html>
<head>
<title>${title}</title>
<meta charset="utf-8">
<style>

body {

 font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
background-color: ${(backgroundColor ?? lightTheme.noteBackgroundColor).toRGB()};
color: ${(textColor ?? lightTheme.noteTextColor).toRGB()};
font-size: ${textSize ?? 15}px;

}

 @media (prefers-color-scheme: dark) {
            body {
             font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
                background-color: ${(backgroundColor ?? darkTheme.noteBackgroundColor).toRGB()};
                color: ${(textColor ?? darkTheme.noteTextColor).toRGB()};
                font-size: ${textSize ?? 15}px;
            }
        }
        
          img {
      max-width: 100%;
      height: auto;
      display: block;
    }
    table {
       border-collapse: collapse;
      width: 100%;
    }
    td {
      border: 1px solid;
      padding: 8px;
      text-align: left;
    }
   </style>
    </head>
    <body>
    """;

    html += toHtmlContents(context, contents);

    html += """
    </body>
    </html>
    """;

    return html;
  }

  String toHtmlContents(BuildContext context, List<Content> contentList) {
    String html = "";
    for (Content content in contentList) {
      switch (content.type) {
        case "img":
          var fileType = FilenameUtils.extensionName(content.value);
          html += """
          <img src="data:image/$fileType;base64,${base64FromSomething(content.value, "images")}">
          """;
          break;
        case "video":
          var fileType = FilenameUtils.extensionName(content.value);
          html += """
          <video src="data:image/$fileType;base64,${base64FromSomething(content.value, "videos")}">
          """;
          break;
        case "table":
          html += "<table border='1'><tbody>";
          for(var rows in content.value) {
            html += "<tr>";
            for(Map<String, dynamic> data in rows) {
              if(data.containsKey("text")) {
                html += """
                <td>
                ${data["text"]}
                </td>
                """;
              }
              else if(data.containsKey("img")) {
                var fileType = FilenameUtils.extensionName(data["img"]);
                html += """
                    <td><img src="data:image/$fileType;base64,${base64FromSomething(data["img"], "images")}"></td>
                     """;
              }
              else if(data.containsKey("video")) {
                var fileType = FilenameUtils.extensionName(data["video"]);
                html += """
                    <td>
                    <video src="data:video/$fileType;base64,${base64FromSomething(data["video"], "images")}">
                     </td>
          """;
              }
              else if(data.containsKey("date")) {
                html += """
                    <td>
                   ${DateTime.fromMillisecondsSinceEpoch(data["date"]).toLocal().toLocalizedString(context)}
                     </td>
          """;
              }
            }
            html += "</tr>";
          }
          html += "</tbody>";
          html += "</table>";
          break;
        case "note":
          Map<String, dynamic> map = content.value;
          List<Content> subNoteContents = [];
          for (Map<String, dynamic> contentMap in map["contents"]) {
            subNoteContents.add(Content.fromMap(contentMap));
          }
          html += """
          <details>
           <summary>${map["title"]}</summary>
            ${toHtmlContents(context, subNoteContents)}
          </details>
          """;
          break;
        case "view-pager":
          html += "<div>";
          for(Map<String, dynamic> data in content.value) {
            List<Content> viewPagerContents = [];
            for(Map<String, dynamic> contentData in data["contents"]) {
              viewPagerContents.add(Content.fromMap(contentData));
            }
            html+= toHtmlContents(context, viewPagerContents);
          }
          html += "</div>";
          break;
        case "divider":
          html += """
          <hr>
          """;
          break;
        case "text":
          html += content.textToHTML();
          break;
      }
    }
    return html;
  }

  String toMarkdown() {
    String markdown = "";

    for(var content in contents) {
      switch(content.type) {
        case "text":
          markdown += content.textToHTML();
        default:
          markdown += "\n";
          break;
      }
    }

    return markdown;
  }

  PDF.Document toPDF() {
    final pdf = PDF.Document();
    List<PDF.Widget> list = [];
    for (Content content in contents) {
      switch (content.type) {
        case "text":
          list.add(
              PDF.Text(content.value,
            style: content.style?.toPDFTextStyle(),
          ));
          break;
        case "img":

          break;

        case "video":

          break;
      }
    }

    var page = PDF.Page(
      build: (context) => PDF.Column(
        crossAxisAlignment: PDF.CrossAxisAlignment.start,
        children: list,
      )
    );

    pdf.addPage(page);
    // for(var widget in list) {
    //
    // }

    return pdf;
  }

  String base64FromSomething(String value, String directoryName) {
    var file = File(PathUtils.join(appStorage.notesPath, name, directoryName, value));
    return base64Encode( file.readAsBytesSync());
  }
}

extension NoteContentExtension on Content {
  String textToHTML() {
    String text = value;
    String html = "";
    if (text != "\n") {
      List<String> split = text.split("\n");
      for (int i = 0; i < split.length; i++) {
        if (split[i].isEmpty) {
          html += """
                  <br>
                """;
          style?.forEach((key, value) {
            switch (key) {
              case "list":
                switch (value) {
                  case "bullet":
                    break;
                  case "ordered":
                    break;
                  case "checked":
                    html += """<input type="checkbox">""";
                    break;
                  case "unchecked":
                    html += """<input type="checkbox">""";
                    break;
                }
                break;
            }
          });
        } else {
          String styleText = "";
          style?.forEach((key, value) {
            switch (key) {
              case "bold":
                styleText += "font-weight: bold;";
                break;
              case "size":
                styleText += "font-size: ${value}px;";
                break;
              case "list":
                switch (value) {
                  case "bullet":
                    break;
                  case "ordered":
                    break;
                  case "checked":
                    html += """<input type="checkbox">""";
                    break;
                  case "unchecked":
                    html += """<input type="checkbox">""";
                    break;
                }
                break;
              case "underline":
                styleText += "text-decoration: underline;";
                break;
              default:
                break;
            }
          });

          html += """
            <div style="${styleText}">${split[i]}</div>
            """;
        }
      }
    } else {
      style?.forEach((key, value) {
        switch (key) {
          case "list":
            switch (value) {
              case "bullet":
                break;
              case "ordered":
                break;
              case "checked":
                html += """<input type="checkbox" checked>""";
                break;
              case "unchecked":
                html += """<input type="checkbox">""";
                break;
            }
            break;
        }
      });


    }

    return html;
  }
}

extension NoteStyleExtension on Map {
  PDF.TextStyle toPDFTextStyle() {
    return PDF.TextStyle(

    );
  }
}

extension RgbExtension on Color {
  String toRGB() {
    return "rgba( ${red}, ${green} , ${blue} , ${opacity})";
  }
}
