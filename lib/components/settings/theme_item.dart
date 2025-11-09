
import 'package:amphi/models/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:notes/models/app_cache_data.dart';
import 'package:notes/models/theme_model.dart';
import 'package:notes/providers/themes_provider.dart';

class ThemeItem extends ConsumerWidget {
  final String id;
  final Brightness brightness;
  const ThemeItem({super.key, required this.id, required this.brightness});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModel = ref
        .watch(themesProvider)
        .themes
        .get(id);
    final themeColors = brightness == Brightness.light ? themeModel.lightColors : themeModel.darkColors;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: App.isWideScreen(context) || App.isDesktop() ? _WideItem(themeColors: themeColors) : _MobileItem(themeColors: themeColors),
        ),
        Text(
          themeModel.title,
        )
      ],
    );
  }
}

class _WideItem extends StatelessWidget {

  final ThemeColors themeColors;

  const _WideItem({required this.themeColors});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Center(
        child: Container(
          width: 100,
          height: 70,
          decoration: BoxDecoration(
            color: themeColors.card,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Theme
                    .of(context)
                    .shadowColor,
                spreadRadius: 3,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 20,
                decoration: BoxDecoration(
                  color: Color.fromARGB((themeColors.background.a * 255).round() & 0xff, (themeColors.background.r * 255).round() & 0xff - 10, (themeColors.background.g * 255).round() & 0xff - 10,
                      (themeColors.background.b * 255).round() & 0xff - 10),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                    topRight: Radius.zero,
                    bottomRight: Radius.zero
                  ),
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(2),
                      child: Divider(
                        color: themeColors.accent.withAlpha(200),
                        thickness: 5,
                        radius: BorderRadius.circular(3),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 20,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2, right: 2, top: 8),
                      child: Divider(
                        color: themeColors.accent.withAlpha(200),
                        thickness: 8,
                        radius: BorderRadius.circular(3),
                      ),
                    )
                  ],
                ),
              ),
              VerticalDivider(
                color: Theme
                    .of(context)
                    .dividerColor,
                width: 1,
              ),
              Expanded(
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 2, right: 15, top: 8),
                      child: Divider(
                        color: themeColors.text,
                        thickness: 1,
                        height: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2, right: 40, top: 5),
                      child: Divider(
                        color: themeColors.text,
                        thickness: 1,
                        height: 3,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 2, right: 30, top: 5),
                      child: Divider(
                        color: themeColors.text,
                        thickness: 1,
                        height: 3,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


class _MobileItem extends StatefulWidget {

  final ThemeColors themeColors;

  const _MobileItem({required this.themeColors});

  @override
  State<_MobileItem> createState() => _MobileItemState();
}

class _MobileItemState extends State<_MobileItem> {

  bool editButtonShowing = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 100,
      decoration: BoxDecoration(
        color: widget.themeColors.background,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Theme
                .of(context)
                .shadowColor,
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
              top: 5,
              bottom: appCacheData.viewMode("") == "linear" ? 70 : 40,
              right: 5,
              left: 5,
              child: Container(
                  decoration: BoxDecoration(
                    color: widget.themeColors.card,
                    borderRadius: BorderRadius.circular(10),
                  ))),
          Positioned( // button on bottom
              right: 5,
              bottom: 5,
              child: _FloatingButton(themeColors: widget.themeColors)),
          AnimatedPositioned(
              duration: Duration(milliseconds: 1000),
              bottom: 35,
              right: editButtonShowing ? 5 : -60,
              curve: Curves.easeOutQuint,
              child: _FloatingButton(themeColors: widget.themeColors))
        ],
      ),
    );
  }
}


class _FloatingButton extends StatelessWidget {

  final ThemeColors themeColors;

  const _FloatingButton({required this.themeColors});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      decoration: BoxDecoration(
        color: themeColors.floatingButtonBackground,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme
                .of(context)
                .shadowColor,
            spreadRadius: 3,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: themeColors.floatingButtonIcon,
            shape: BoxShape.circle,
          ),
        ),
      ),
    );
  }
}
