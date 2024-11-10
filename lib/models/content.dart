

class Content {
  dynamic value = "";
  String type = "text";
  Map<String, dynamic>? style = {};

  Content({this.value = "", this.type = "text", this.style = const {} });

  @override
  String toString() {
    return """
    {
      value: $value,
      type: $type,
      style: $style
      }
    """;
  }

  static Content fromMap(Map<String, dynamic> map) {
    switch (map["type"]) {
      case "img":
        return Content(value: map["value"], type: "img");
      case "video":
        return Content(value: map["value"], type: "video");
      case "table":
        return Content(value: map["value"], type: "data", style: map["style"]);
      case "data":
        return Content(value: map["value"], type: "data", style: map["style"]);
      case "note":
        return Content(value: map["value"], type: "note");
      case "divider":
        return Content(style: map["style"], type: "divider");
      default:
       // return Content(value: map["value"], type: "text", style: styleFromData(map));
         return Content(value: map["value"], type: "text", style: map["style"]);

        // String styleString = map["style"];
        // if (styleString.isNotEmpty) {
        //   List<String> split = styleString.split(";");
        //   for (String string in split) {
        //     List<String> styleSplit = string.split(":");
        //     style.add(ContentStyle(
        //       type: styleSplit[0],
        //       value: styleSplit[1],
        //     ));
        //   }
        // }

    }
  }

  Map<String, dynamic> toMap() {
    return {"value": value, "type": type, "style": style};
  }
}