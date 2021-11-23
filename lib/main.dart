import 'package:dark_reminder/provider/event_provider.dart';
import 'package:dark_reminder/utils.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:dark_reminder/screens/main_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => EventProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData.dark().copyWith(
          textSelectionTheme: TextSelectionThemeData(
              cursorColor: kPurpleColor, selectionHandleColor: kPurpleColor),
          primaryColor: kPrimaryColor,
          scaffoldBackgroundColor: Colors.transparent,
          dividerTheme: DividerThemeData(
            space: 26.0,
            thickness: 2.0,
            color: Colors.grey,
            indent: 34.0,
          ),
        ),
        home: MainScreen(),
      ),
    );
  }
}
