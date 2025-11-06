import 'dart:convert';
import 'dart:io';

import 'package:amphi/utils/file_name_utils.dart';
import 'package:flutter/material.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/models/app_settings.dart';

import 'package:notes/models/note.dart';
import 'package:notes/utils/attachment_path.dart';
import 'package:pdf/widgets.dart' as PDF;

extension NoteConverter on Note {
  String toHTML(BuildContext context) {
    final themeModel = appSettings.themeModel;

    String htmlContent = "";
    for (var item in content) {
      final value = item["value"];
      switch (item["type"]) {
        case "img":
          var fileTypeExtension = FilenameUtils.extensionName(value);
          htmlContent += """
          <img src="data:image/$fileTypeExtension;base64,${encodeFileToBase64(value, "images")}">
          """;
          break;
        case "video":
          var fileTypeExtension = FilenameUtils.extensionName(value);
          htmlContent += """
          <video src="data:image/$fileTypeExtension;base64,${encodeFileToBase64(value, "videos")}">
          """;
          break;
        case "audio":
          var fileTypeExtension = FilenameUtils.extensionName(value);
          htmlContent += """
          <audio src="data:image/$fileTypeExtension;base64,${encodeFileToBase64(value, "audio")}">
          """;
          break;
        case "table":
          htmlContent += "<table border='1'><tbody>";
          for (var rows in value) {
            htmlContent += "<tr>";
            for (Map<String, dynamic> data in rows) {
              if (data.containsKey("text")) {
                htmlContent += """
                <td>
                ${data["text"]}
                </td>
                """;
              } else if (data.containsKey("img")) {
                var fileType = FilenameUtils.extensionName(data["img"]);
                htmlContent += """
                    <td><img src="data:image/$fileType;base64,${encodeFileToBase64(data["img"], "images")}" alt="image"></td>
                     """;
              } else if (data.containsKey("video")) {
                var fileType = FilenameUtils.extensionName(data["video"]);
                htmlContent += """
                    <td>
                    <video src="data:video/$fileType;base64,${encodeFileToBase64(data["video"], "images")}">
                     </td>
          """;
              } else if (data.containsKey("date")) {
                htmlContent += """
                    <td>
                   ${DateTime.fromMillisecondsSinceEpoch(data["date"]).toLocal().toLocalizedString(context)}
                     </td>
          """;
              }
            }
            htmlContent += "</tr>";
          }
          htmlContent += "</tbody>";
          htmlContent += "</table>";
          break;
        case "divider":
          htmlContent += """
          <hr>
          """;
          break;
        case "text":
          htmlContent += textBlockToHtml(item);
          break;
      }
    }

    return """
   <!DOCTYPE html>
    <html>
    <head>
    <title>${title}</title>
    <meta charset="utf-8">
    <style>
    
    body {
    
     font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
    background-color: ${(backgroundColor ?? themeModel.lightColors.card).toRgbaString()};
    color: ${(textColor ?? themeModel.lightColors.text).toRgbaString()};
    font-size: ${textSize ?? 15}px;
    
    }

    @media (prefers-color-scheme: dark) {
        body {
         font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Roboto, "Helvetica Neue", Arial, sans-serif;
            background-color: ${(backgroundColor ?? themeModel.darkColors.card).toRgbaString()};
            color: ${(textColor ?? themeModel.darkColors.text).toRgbaString()};
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
    ${htmlContent}
    </body>
    </html>
    """;
  }

  String toMarkdown() {
    String markdown = "";

    // for(var content in content) {
    //   switch(content.type) {
    //     case "text":
    //       markdown += content.textToHTML();
    //     default:
    //       markdown += "\n";
    //       break;
    //   }
    // }

    return markdown;
  }

  PDF.Document toPDF() {
    final pdf = PDF.Document();
    List<PDF.Widget> list = [];
    // for (Content content in content) {
    //   switch (content.type) {
    //     case "text":
    //       list.add(
    //           PDF.Text(value,
    //         style: content.style?.toPDFTextStyle(),
    //       ));
    //       break;
    //     case "img":
    //
    //       break;
    //
    //     case "video":
    //
    //       break;
    //   }
    // }

    var page = PDF.Page(
        build: (context) => PDF.Column(
              crossAxisAlignment: PDF.CrossAxisAlignment.start,
              children: list,
            ));

    pdf.addPage(page);
    // for(var widget in list) {
    //
    // }

    return pdf;
  }

  String encodeFileToBase64(String filename, String directoryName) {
    var file = File(noteAttachmentPath(id, filename, directoryName));
    return base64Encode(file.readAsBytesSync());
  }
}

String textBlockToHtml(Map<String, dynamic> item) {
  String text = item["value"];
  var tagName = "div";
  var attributes = "";
  var style = "";
  var html = "";
  item["style"]?.forEach((key, value) {
    switch (key) {
      case "header":
        tagName = "h$value";
      case "bold":
        style += "font-weight: bold;";
        break;
      case "size":
        style += "font-size: ${value}px;";
        break;
      case "color":
        style += "color: $value";
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
        style += "text-decoration: underline;";
        break;
      case "link":
        tagName = "a";
        attributes = """href="$value"  """;
      case "strike":
        tagName = "s";
      default:
        break;
    }
  });
  html += "<$tagName style='display: inline; $style' $attributes>${text.replaceAll("\n", "<br>")}</$tagName>";

  return html;
}

extension NoteStyleExtension on Map {
  PDF.TextStyle toPDFTextStyle() {
    return PDF.TextStyle();
  }
}

extension RgbExtension on Color {
  String toRgbaString() {
    return "rgba( ${(r * 255.0).round()}, ${(g * 255.0).round()} , ${(b * 255.0).round()} , ${a})";
  }
}
