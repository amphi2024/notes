import 'dart:io';
import 'dart:math';

String generatedFileName(String type, String path) {
  int length = Random().nextInt(9) + 1;

  const String chars = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';

  String result = '';
  for (int i = 0; i < length; i++) {
    result += chars[Random().nextInt(chars.length)];
  }
  result += ".$type";

  if(File("$path/$result").existsSync()) {
    return generatedFileName(type, path);
  }
  else {
    return result;
  }

}