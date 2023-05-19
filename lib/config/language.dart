import 'package:shared_preferences/shared_preferences.dart';

List language = [
  {
    "language": "English",
    "code": "en",
    "Favorite": true,
  },
  {
    "language": "ગુજરાતી",
    "code": "gu",
    "Favorite": true,
  },
  {
    "language": "हिन्दी",
    "code": "hi",
    "Favorite": true,
  },
  {
    "language": "Русский",
    "code": "ru",
    "Favorite": false,
  },
  {
    "language": "Français",
    "code": "fr",
    "Favorite": false,
  },
  {
    "language": "Deutsch",
    "code": "de",
    "Favorite": false,
  },
  {
    "language": "中國人",
    "code": "zh",
    "Favorite": false,
  },
];


List fevList = [];
List remainList = [];

void languageData() {
  fevList = language.where(
        (element) {
      return element['Favorite'] == true;
    },
  ).toList();

  remainList = language.where(
        (element) {
      return element['Favorite'] != true;
    },
  ).toList();
}

String? languageCode;

void getCurrentLanguage() async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  languageCode = pref.getString("language");
}