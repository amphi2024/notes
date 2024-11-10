import 'package:flutter/material.dart';

class FloatingSearchBar extends StatelessWidget {

  final bool showing;
  final FocusNode focusNode;
  final TextEditingController textEditingController;
  const FloatingSearchBar({super.key, required this.showing, required this.focusNode, required this.textEditingController});

  @override
  Widget build(BuildContext context) {
    return  AnimatedPositioned(
      duration: Duration(milliseconds: showing ? 1000 : 1250),
      curve: Curves.easeOutQuint,
      left: showing ? 20 : -235,
      bottom: 140,
      child: Container(
        width: 200,
        height: 50,
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
        child: Padding(
          padding: const EdgeInsets.only(right: 10.0),
          child: TextField(
            focusNode: focusNode,
            controller: textEditingController,
            decoration: InputDecoration(
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                prefixIcon: Icon(
                  Icons.search,
                  color: Theme.of(context).colorScheme.primary,
                )
            ),
          ),
        ),
      ),
    );
  }
}