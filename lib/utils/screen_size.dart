import 'dart:io';

import 'package:flutter/material.dart';

bool isTablet(context) {
  return MediaQuery.of(context).size.width > 600;
}

bool isDesktop() {
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}

bool isDesktopOrTablet(context) {
  return isDesktop() || isTablet(context);
}

bool isMobile() {
  return Platform.isAndroid || Platform.isIOS;
}