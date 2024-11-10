import 'package:flutter/material.dart';

class FloatingMenu extends StatelessWidget {

  final bool showing;
  final List<Widget> children;
  const FloatingMenu({super.key, required this.showing, required this.children});

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: showing ? 1000 : 1250),
      curve: Curves.easeOutQuint,
      left: 20,
      bottom: showing ? 30 : -90,
      child: Container(
        width: 200,
        height: 70,
        decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Theme.of(context).shadowColor,
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
            color: Theme.of(context).floatingActionButtonTheme.backgroundColor,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: children,
        ),
      ),
    );
  }
}
