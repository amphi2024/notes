String formatBytes(int bytes) {
  if (bytes >= 1099511627776) {
    return "${(bytes / 1099511627776).toStringAsFixed(2)} TB";
  } else if (bytes >= 1073741824) {
    return "${(bytes / 1073741824).toStringAsFixed(2)} GB";
  } else if (bytes >= 1048576) {
    return "${(bytes / 1048576).toStringAsFixed(2)} MB";
  } else if (bytes >= 1024) {
    return "${(bytes / 1024).toStringAsFixed(2)} KB";
  } else {
    return "$bytes bytes";
  }
}