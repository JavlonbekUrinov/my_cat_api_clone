import 'package:flutter/material.dart';
import 'package:my_cat_api_clone/pages/control_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      home: ControlPage(),
      routes: {ControlPage.id: (context) => ControlPage()},
    );
  }
}
