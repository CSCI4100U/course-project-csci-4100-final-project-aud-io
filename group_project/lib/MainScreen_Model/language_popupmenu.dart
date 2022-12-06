import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class LanguageMenu extends StatefulWidget {
  const LanguageMenu({Key? key}) : super(key: key);

  @override
  State<LanguageMenu> createState() => _LanguageMenuState();
}

class _LanguageMenuState extends State<LanguageMenu> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 37,
      child: PopupMenuButton(
        itemBuilder: (context) => [
          //TODO: Translate these texts as well
          PopupMenuItem(
              value: 1,
              child: Text(FlutterI18n.translate(context, "forms.languages.english"))
          ),
          PopupMenuItem(
              value: 2,
              child: Text(FlutterI18n.translate(context, "forms.languages.french"))
          ),
          PopupMenuItem(
              value: 3,
              child: Text(FlutterI18n.translate(context, "forms.languages.spanish"))
          ),
        ],
        onSelected: (value) {
          if (value == 1){
            print('Swapping to English');
            Locale newLocale = const Locale('en');
            setState(() {
              FlutterI18n.refresh(context, newLocale);
            });
          } else if (value == 2){
            print('Swapping to French');
            Locale newLocale = const Locale('fr');
            setState(() {
              FlutterI18n.refresh(context, newLocale);
            });
          } else if (value == 3) {
            print('Swapping to Spanish');
            Locale newLocale = const Locale('es');
            setState(() {
              FlutterI18n.refresh(context, newLocale);
            });                }
        },
      ),
    );
  }
}

