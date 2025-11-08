import 'dart:convert';
import 'dart:io';

import 'package:amphi/utils/file_name_utils.dart';
import 'package:amphi/utils/path_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:notes/extensions/date_extension.dart';
import 'package:notes/models/app_settings.dart';

import 'package:notes/models/note.dart';
import 'package:notes/utils/attachment_path.dart';
import 'package:pdf/widgets.dart' as PDF;

extension NoteConverter on Note {

  String toBundledFileContent() {
    List<Map<String, dynamic>> contentData = [];
    for (Map<String, dynamic> map in content) {
      switch (map["type"]) {
        case "img":
          var fileType = FilenameUtils.extensionName(map["value"]);
          contentData.add({"type": "img", "value": "!BASE64;$fileType;${encodeFileToBase64(map["value"], "images")}"});
          break;
        case "video":
          var fileType = FilenameUtils.extensionName(map["value"]);
          contentData.add({"type": "video", "value": "!BASE64;$fileType;${encodeFileToBase64(map["value"], "videos")}"});
          break;
        case "audio":
          var fileType = FilenameUtils.extensionName(map["value"]);
          contentData.add({"type": "audio", "value": "!BASE64;$fileType;${encodeFileToBase64(map["value"], "audio")}"});
          break;
        case "table":
          List<List<Map<String, dynamic>>> tableData = [];
          for (var rows in map["value"]) {
            if(rows is List<Map<String, dynamic>>) {
              List<Map<String, dynamic>> addingRows = [];
              for (var data in rows) {
                if (data["img"] != null) {
                  var fileType = FilenameUtils.extensionName(data["img"]);
                  addingRows.add({"img": "!BASE64;$fileType;${encodeFileToBase64(data["img"], "images")}"});
                } else if (data["video"] != null) {
                  var fileType = FilenameUtils.extensionName(data["video"]);
                  addingRows.add({"img": "!BASE64;$fileType;${encodeFileToBase64(data["video"], "videos")}"});
                } else {
                  addingRows.add(data);
                }
              }
              tableData.add(addingRows);
            }
          }
          contentData.add({"type": "table", "value": tableData, "style": map["style"]});
          break;
        case "divider":
          contentData.add({"type": "divider"});
          break;
      // TODO: Add support for file
        default:
          contentData.add(map);
          break;
      }
    }
    final jsonData = {
      "created": created.toUtc().millisecondsSinceEpoch,
      "modified": modified.toUtc().millisecondsSinceEpoch,
      "content": contentData,
      "background_color": backgroundColor?.toARGB32(),
      "text_color": textColor?.toARGB32(),
      "text_size": textSize,
      "line_height": lineHeight
    };

    String fileContent = jsonEncode(jsonData);
    return fileContent;
  }

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

  String toMarkdown(String selectedPath, BuildContext context) {
    String markdown = "";

    for (var i = 0 ; i < content.length; i++) {
      final item = content[i];
      var imageCount = 0;
      switch (item["type"]) {
        case "img":
          var parent = Directory(selectedPath);
          var directory = Directory(PathUtils.join(parent.parent.path, "images"));
          if(!directory.existsSync()) {
            directory.createSync();
          }
          var fileExtension = FilenameUtils.extensionName( item["value"]);
          var file = File(PathUtils.join(parent.parent.path, "images", "image$imageCount.$fileExtension"));

          var originalFile = File(noteImagePath(id, item["value"]));
          file.create();
          file.writeAsBytesSync(originalFile.readAsBytesSync());
          markdown += """![image](images/image$imageCount.$fileExtension)""";
          imageCount++;
          break;
        // case "img":
        //   var fileExtension = FilenameUtils.extensionName(value);
        //   markdown += """<br><img src="data:image/$fileExtension;base64,${encodeFileToBase64(value, "images")}"><br>""";
        //   break;
        // case "video":
        //   var fileExtension = FilenameUtils.extensionName(value);
        //   markdown += """<br><video src="data:image/$fileExtension;base64,${encodeFileToBase64(value, "videos")}"><br>""";
        //   break;
        // case "audio":
        //   var fileExtension = FilenameUtils.extensionName(value);
        //   markdown += """<br><audio src="data:image/$fileExtension;base64,${encodeFileToBase64(value, "audio")}"><br>""";
        //   break;
        case "table":
          markdown += tableBlockToMarkdown(item, context);
          break;
        case "divider":
          markdown += "---";
          break;
        case "text":
          markdown += textBlockToMarkdown(item);
          break;
      }
    }

    return markdown;
  }

  Future<PDF.Document> toPDF(BuildContext context) async {
    final pdf = PDF.Document();
    List<PDF.Widget> list = [];
    final koreanFont = PDF.Font.ttf(await rootBundle.load("assets/NotoSansKR-Regular.ttf").then((f) => f.buffer.asByteData()));
    for(var item in content) {
      final value = item["value"];
      switch(item["type"]) {
        case "img":
          var file = File(noteImagePath(id, value));
          list.add(
              PDF.Image(
                PDF.MemoryImage(
                  await file.readAsBytes()
                ),
              ));
        case "text":
          final style = item["style"];
          final textSize = double.tryParse(style?["size"] ?? "");
          final textStyle = PDF.TextStyle(
            fontFallback: [koreanFont],
            fontSize: textSize
          );
              list.add(
                  PDF.Text(value,
                style: textStyle
              ));
          break;
      }
    }



    pdf.addPage(
      PDF.MultiPage(
        build: (context) => list,
      ),
    );

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

String textBlockToMarkdown(Map<String, dynamic> item) {
  String text = item["value"];
  var markdown = text;
  item["style"]?.forEach((key, value) {
    switch (key) {
      case "header":
        if(text.replaceAll("\n", "").isNotEmpty) {
          switch(value) {
            case 2:
              markdown = "## $text";
              break;
            case 3:
              markdown = "### $text";
              break;
            case 4:
              markdown = "#### $text";
              break;
            case 5:
              markdown = "##### $text";
              break;
            case 6:
              markdown = "###### $text";
              break;
            default:
              markdown = "# $text";
              break;
          }
        }
      case "bold":
        markdown = "**$text**";
        break;
      case "size":
        var size = double.tryParse(value);
        if(size != null) {
          if (size >= 28) {
            markdown = '# $text';
          } else if (size >= 22) {
            markdown = '## $text';
          } else if (size >= 18) {
            markdown = '### $text';
          } else if (size >= 16) {
            markdown = '#### $text';
          }
        }
        break;
      case "italic":
        markdown = "*$text*";
        break;
      case "quote":
        markdown = "> $text";
      case "list":
        switch (value) {
          case "bullet":
            markdown = "- $text";
            break;
          case "ordered":
            markdown = "- $text";
            break;
          case "checked":
            // markdown += "- [x] $text";
            break;
          case "unchecked":
            // markdown += "- [] $text";
            break;
        }
        break;
      case "underline":
        markdown = "<u>$text</u>";
        break;
      case "link":
        markdown = "[$text]($value)";
      case "strike":
        markdown = "~~$text~~";
      case "code-block":
        markdown = "`$text`";
      default:
        markdown = text;
        break;
    }
  });

  return markdown;
}

String tableBlockToMarkdown(Map<String, dynamic> item, BuildContext context) {
  var markdown = "\n";

  final value = item["value"];

  for (var i = 0; i < value.length; i++) {
    final rows = value[i];
    for (Map<String, dynamic> data in rows) {
      if (data.containsKey("text")) {
        markdown += "| ${data["text"]} ";
      } else if (data.containsKey("date")) {
        markdown += "| ${DateTime.fromMillisecondsSinceEpoch(data["date"]).toLocal().toLocalizedString(context)} ";
      }
      else {
        markdown += "| ";
      }
    }
    markdown += "|\n";

    if(i == 0) {
      for (var _ in rows) {
        markdown += "|------";
      }
      markdown += "|\n";
    }

  }
  markdown += "\n";

  return markdown;
}

extension RgbExtension on Color {
  String toRgbaString() {
    return "rgba( ${(r * 255.0).round()}, ${(g * 255.0).round()} , ${(b * 255.0).round()} , ${a})";
  }
}
