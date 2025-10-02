import 'package:flutter/material.dart';

class NoteCalenderEventsPage extends StatefulWidget {

  final List<String> events;
  const NoteCalenderEventsPage({super.key, required this.events});

  @override
  State<NoteCalenderEventsPage> createState() => _NoteCalenderEventsPageState();
}

class _NoteCalenderEventsPageState extends State<NoteCalenderEventsPage> {
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.arrow_back_ios), onPressed: () {
          Navigator.pop(context);
        }),
      ),
      body: Stack(
        children: [
          Positioned(
            left: 15,
            right: 15,
            top: 0,
            bottom: 0,
            child: ListView.builder(
              itemCount: widget.events.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 5),
                    child: Container(
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius: BorderRadius.circular(10)
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(7.5),
                          child: Text(widget.events[index]),
                        )),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
