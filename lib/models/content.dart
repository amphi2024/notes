


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
        return Content(value: map["value"], type: "table", style: map["style"]);
      case "note":
        return Content(value: map["value"], type: "note");
      case "divider":
        return Content(style: map["style"], type: "divider");
      case "view-pager":
        return Content(value: map["value"] , style: map["style"], type: "view-pager");
      case "file":
        return Content(value: map["value"] , type: "file");
      default:
         return Content(value: map["value"], type: "text", style: map["style"]);
    }
  }

  Map<String, dynamic> toMap() {
    return {"value": value, "type": type, "style": style};
  }

}