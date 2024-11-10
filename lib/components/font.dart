import 'package:flutter/cupertino.dart';
import 'package:amphi/models/app_localizations.dart';

class Font extends StatelessWidget {

  final String label;
  final String font;
  const Font(this.label, this.font, {super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: TextStyle(
        fontSize: 20,

        fontFamily: font
      ),
    );
  }
}

List<Font> getAllFonts(BuildContext context) {
  if(Localizations.localeOf(context).languageCode == "ko") {
    return [
      Font(AppLocalizations.of(context).get("@default_font"), ""),
      const Font("나눔고딕", "nanum_gothic"),
      const Font("바탕", "batang"),
      const Font("궁서", "gungseo"),
      const Font("Arial", "arial"),
      const Font("Cursive", "cursive"),
      const Font("Fantasy", "fantasy"),
      const Font("Monospace", "monospace"),
      const Font("Serif", "serif"),
    ];
  }
  else {
    return [
      Font(AppLocalizations.of(context).get("@default_font"), ""),
      const Font("Arial", "arial"),
      const Font("Cursive", "cursive"),
      const Font("Fantasy", "fantasy"),
      const Font("Monospace", "monospace"),
      const Font("Serif", "serif"),
    ];
  }

}

Map<String, String> getAllFontsSex(BuildContext context) {
  if(Localizations.localeOf(context).languageCode == "ko") {
    return {
      AppLocalizations.of(context).get("@default_font") : "",
      "나눔고딕": "nanum_gothic",
      "바탕": "batang",
      "궁서": "gungseo",
      "Arial": "arial",
      "Cursive": "cursive",
      "Fantasy": "fantasy",
      "Monospace": "monospace",
      "Serif": "serif"
    };
  }
  else {
    return {
      AppLocalizations.of(context).get("@default_font") : "",
      "Arial": "arial",
      "Cursive": "cursive",
      "Fantasy": "fantasy",
      "Monospace": "monospace",
      "Serif": "serif"
    };
  }
}