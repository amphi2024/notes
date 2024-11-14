import 'package:amphi/models/app_localizations.dart';
import 'package:flutter/material.dart';

class EditViewPagerStyle extends StatefulWidget {

  final Map<String, dynamic> style;
  final void Function(String, dynamic) onStyleChanged;
  const EditViewPagerStyle({super.key, required this.style, required this.onStyleChanged});

  @override
  State<EditViewPagerStyle> createState() => _EditViewPagerStyleState();
}

class _EditViewPagerStyleState extends State<EditViewPagerStyle> {

  late TextEditingController heightController = TextEditingController(
    text: (widget.style["height"] ?? 250.0 ).toString()
  );
  @override
  void dispose() {
    heightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      height: 75,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Theme.of(context).cardColor
      ),
      child: Padding(
        padding: const EdgeInsets.all(7.5),
        child: Column(
          children: [
            Row(
              children: [
                Text(AppLocalizations.of(context).get("@editor_view_pager_height")),
                SizedBox(
                  width: 70,
                  height: 50,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: heightController,
                      keyboardType: TextInputType.number,
                      onChanged: (text) {
                        widget.onStyleChanged("height", double.parse(text));
                      },
                    ),
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
