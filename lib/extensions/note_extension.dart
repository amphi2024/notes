import 'package:amphi/models/app_colors_core.dart';
import 'package:amphi/models/app_theme_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:notes/models/app_settings.dart';
import 'package:notes/models/app_theme.dart';
import 'package:notes/models/content.dart';
import 'package:notes/models/dark_theme.dart';
import 'package:notes/models/light_theme.dart';
import 'package:notes/models/note.dart';

extension NoteExtension on Note {
  String toHTML(String directoryName) {
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
background-color: ${ (backgroundColor ?? lightTheme.noteBackgroundColor).toRGB() };
color: ${ (textColor ?? lightTheme.noteTextColor).toRGB() };
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
   </style>
    </head>
    <body>
    """;

    for(Content content in contents) {
      switch(content.type) {
        case "img":
          html += """
          <img src="${directoryName}/${content.value}">
          """;
          break;
        case "video":
          html += """
          <video src="${directoryName}/${content.value}">
          """;
          break;
        case "table":
          break;
        case "note":
          break;
        case "view-pager":
          break;
        case "divider":
          break;
        case "text":
          String text = content.value;
          // List<String> split = text.split("\n");
          // for(int i = 0 ; i< split.length; i++) {
          //   String style  = "";
          //   content.style?.forEach((key, value) {
          //     switch (key) {
          //       case "bold":
          //         style += "font-weight: bold;";
          //         break;
          //       case "size":
          //         style += "font-size: ${value}px;";
          //         break;
          //     }
          //   });
          //
          // if(i == split.length - 1) {
          //   html += """
          // <div style="${style}">${split[i]}</div>
          // """;
          // }
          // else {
          //   html += """
          // <div style="${style}">${split[i]}<br></div>
          // """;
          // }
          //
          // }
          if(text != "\n") {

            List<String> split = text.split("\n");
            for(int i = 0 ; i< split.length; i++) {
              if(split[i].isEmpty) {
                html += """
            <br>
            """;
              }
              else {
                String style  = "";
                content.style?.forEach((key, value) {
                  switch (key) {
                    case "bold":
                      style += "font-weight: bold;";
                      break;
                    case "size":
                      style += "font-size: ${value}px;";
                      break;
                  }
                });

                html += """
            <div style="${style}">${split[i]}</div>
            """;
              }


            // if(i == split.length - 1) {
            //   html += """
            // <div style="${style}">${split[i]}</div>
            // """;
            // }
            // else {
            //   html += """
            // <div style="${style}">${split[i]}<br></div>
            // """;
            // }

            }


          //   String style  = "";
          //   content.style?.forEach((key, value) {
          //     switch (key) {
          //       case "bold":
          //         style += "font-weight: bold;";
          //         break;
          //       case "size":
          //         style += "font-size: ${value}px;";
          //         break;
          //     }
          //   });
          //   style += "";
          //
          //   html += """
          // <div style="${style}">${text.replaceAll("\n", "<br>")}</div>
          // """;
          }

          break;
      }
    }


    html += """
    </body>
    </html>
    """;

    return html;
  }
}
extension RgbExtension on Color {
  String toRGB() {
    return "rgba( ${red}, ${green} , ${blue} , ${opacity})";
  }
}