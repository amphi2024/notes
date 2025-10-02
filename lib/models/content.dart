class Content {
  get value => data["value"] ?? "";
  String get type => data["type"] ?? "text";
  Map<String, dynamic>? get style => data["style"];
  Map<String, dynamic> data = {};

  Content(this.data);

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

  Map<String, dynamic> toMap() {
    return {"value": value, "type": type, "style": style};
  }

}