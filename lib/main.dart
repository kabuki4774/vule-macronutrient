import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'src/models/food.dart';
import 'src/services/global_bloc.dart';
import 'src/ui/homepage/homepage.dart';

List<Food> Foods = [];
late SharedPreferences preferenceInstance;

void saveFoods() {
  preferenceInstance.setString("foods", jsonEncode(Foods));
}

void main() async {
  runApp(const MyApp());
  preferenceInstance = await SharedPreferences.getInstance();
  String? foodsJson = preferenceInstance.getString("foods");
  Foods = <Food>[];
  if (foodsJson != null) {
    Iterable l = json.decode(foodsJson);
    Foods = List<Food>.from(l.map((model) => Food.fromJson(model)));
  } else {
    Foods = [];
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  late GlobalBloc globalBloc;

  void initState() {
    globalBloc = GlobalBloc();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.amber[900],
    ));
    return Provider<GlobalBloc>.value(
      value: globalBloc,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.green,
          brightness: Brightness.light,
        ),
        //home: MainWidget(),
        home: HomePage(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
