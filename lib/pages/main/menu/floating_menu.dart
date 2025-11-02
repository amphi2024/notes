import 'package:amphi/widgets/account/account_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../channels/app_method_channel.dart';
import '../../../channels/app_web_channel.dart';
import '../../../models/app_cache_data.dart';
import '../../../models/app_storage.dart';
import '../../../icons/icons.dart';
import '../../settings_page.dart';
import '../../trash/trash_page.dart';
import '../../../providers/providers.dart';
import '../../../providers/selected_notes_provider.dart';
import '../../../utils/account_utils.dart';
import 'floating_menu_divider.dart';

class FloatingMenu extends ConsumerWidget {

  const FloatingMenu({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    var bottomPadding = MediaQuery.of(context).padding.bottom;
    if(bottomPadding == 0) {
      bottomPadding = 15;
    }
    final selectingNotes = ref.watch(selectedNotesProvider) != null;
    final buttonRotated = ref.watch(floatingButtonStateProvider);

    return AnimatedPositioned(
      duration: Duration(milliseconds: !selectingNotes && buttonRotated ? 1000 : 1250),
      curve: Curves.easeOutQuint,
      left: 20,
      bottom: !selectingNotes && buttonRotated
          ? (bottomPadding + 15)
          : -(bottomPadding + 75),
      child: Container(
        width: 200,
        height: 70,
        decoration: BoxDecoration(
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
            color: Theme
                .of(context)
                .floatingActionButtonTheme
                .backgroundColor,
            borderRadius: BorderRadius.circular(15)
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            AccountButton(onLoggedIn: ({required id, required token, required username}) {
              onLoggedIn(id: id,
                  token: token,
                  username: username,
                  context: context,
                  ref: ref);
            },
                iconSize: 30,
                profileIconSize: 15,
                wideScreenIconSize: 25,
                wideScreenProfileIconSize: 15,
                appWebChannel: appWebChannel,
                appStorage: appStorage,
                appCacheData: appCacheData,
                onUserRemoved: () {
                  onUserRemoved(ref);
                },
                onUserAdded: () {
                  onUserAdded(ref);
                },
                onUsernameChanged: () {
                  onUsernameChanged(ref);
                },
                onSelectedUserChanged: (user) {
                  onSelectedUserChanged(user, ref);
                },
                setAndroidNavigationBarColor: () {
                  appMethodChannel.setNavigationBarColor(Theme
                      .of(context)
                      .scaffoldBackgroundColor);
                }),
            const FloatingMenuDivider(),
            _FloatingMenuButton(
                icon: AppIcons.trash,
                onPressed: () {
                  Navigator.push(
                      context,
                      CupertinoPageRoute(
                          barrierDismissible: true,
                          builder: (context) {
                            return const TrashPage();
                          }));
                }),
            const FloatingMenuDivider(),
            _FloatingMenuButton(
                icon: AppIcons.settings,
                onPressed: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) {
                    return const SettingsPage();
                  }));
                })
          ],
        ),
      ),
    );
  }
}

class _FloatingMenuButton extends StatelessWidget {

  final IconData icon;
  final VoidCallback onPressed;
  const _FloatingMenuButton({required this.onPressed, required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconButton(
        onPressed: onPressed,
        icon: Icon(
            icon,
            size: 30));
  }
}