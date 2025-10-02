import 'package:flutter/cupertino.dart';

class DraggablePage extends StatefulWidget {

  final bool canPopPage;
  final Widget child;
  final void Function(bool, dynamic)? onPopInvoked;
  const DraggablePage({super.key, this.canPopPage = true, required this.child, this.onPopInvoked});

  @override
  State<DraggablePage> createState() => _DraggablePageState();
}

class _DraggablePageState extends State<DraggablePage> {

  late Offset startPosition;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: widget.canPopPage,
        onPopInvokedWithResult: widget.onPopInvoked,
        child: GestureDetector(
          onPanStart: (DragStartDetails d) {
            startPosition = d.globalPosition;
          },
          onPanUpdate: (DragUpdateDetails d) {
            if (startPosition.dx - d.globalPosition.dx < -80 && Navigator.canPop(context)) {
              Navigator.pop(context);
            }
          },
          child: widget.child,
        ));
  }
}
