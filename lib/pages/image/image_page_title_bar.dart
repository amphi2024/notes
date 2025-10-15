import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'image_page.dart';

class ImagePageTitleBar extends ConsumerWidget {

  const ImagePageTitleBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    return Container(
      height: imagePageTitleBarHeight + MediaQuery
          .of(context)
          .padding
          .top,
      color: Theme
          .of(context)
          .appBarTheme
          .backgroundColor,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(onPressed: () {
              Navigator.pop(context);
            }, icon: const Icon(
              Icons.arrow_back_ios_new,
              size: 25,
            ))
          ],
        ),
      ),
    );
  }
}