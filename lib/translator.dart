import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translator/translator.dart';
final translator = GoogleTranslator();
Future textTranslate({input}) async {
  dynamic res;
  String lCode = await getLang();
  String languageCode = lCode;
  if (lCode == "en") {
    res = input.toString();
  } else {
    await translator
        .translate(input, to: languageCode, from: "en")
        .then((result) {
      res = result;
    });
  }
  return res;
}
textToTrans({
  required String? input,
  required style,
  TextOverflow? textOverflow,
  int maxLine = 1,
  bool isCenterText = false,
  double? height,
  double? width,
  bool isCenterSimmer = false,
}) {
  return FutureBuilder(
      future: textTranslate(input: input),
      builder: (_, s) {
        if (s.hasData) {
          return Text(
            "${s.data}",
            style: style,
            maxLines: maxLine,
            textAlign: isCenterText ? TextAlign.center : TextAlign.start,
            overflow: textOverflow ?? TextOverflow.visible,
          );
        } else {
          return /*googleTranslateTextViewShimmerEffect(
            isCenter: isCenterSimmer,
            height: height,
            width: width,
          );*/
          const Text(
            "...",
            style: TextStyle(color: Colors.white),
          );
        }
      });
}
Future<String> getLang() async {
  String defaultLangCode = 'en-Us';
  defaultLangCode = await getLanguageCode() ?? ui.window.locale.languageCode;
  return defaultLangCode;
}
getLanguageCode() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  // return pref.getString(PrefString.languageCode);
  return pref.getString("language");
}