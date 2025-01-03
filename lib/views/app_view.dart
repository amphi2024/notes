import 'package:flutter/cupertino.dart';

class AppView extends StatefulWidget {

  final bool canPopPage;
  final Widget child;
  final void Function(bool, dynamic)? onPopInvoked;
  const AppView({super.key, this.canPopPage = true, required this.child, this.onPopInvoked});

  @override
  State<AppView> createState() => _AppViewState();
}

class _AppViewState extends State<AppView> {

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
