import 'package:flutter/material.dart';

import '../../../src/ui/homepage/food_widget.dart';
import '../../../src/ui/homepage/new_food_widget.dart';
import '../../../src/ui/homepage/today_widget.dart';

class MainWidget extends StatefulWidget {
  const MainWidget({Key? key}) : super(key: key);

  @override
  State<MainWidget> createState() => MainWidgetState();
}

class MainWidgetState extends State<MainWidget> {
  static int bottomBarSelectedIndex = 0;
  static const List<StatefulWidget> widgets = <StatefulWidget>[
    FoodWidget(),
    TodayWidget(),
    NewFoodWidget()
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widgets[bottomBarSelectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int value) => setState(() {
          bottomBarSelectedIndex = value;
        }),
        currentIndex: bottomBarSelectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.food_bank), label: "Foods"),
          BottomNavigationBarItem(icon: Icon(Icons.today), label: "Today"),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: "New Food")
        ],
        selectedItemColor: Colors.amber[900],
      ),
    );
  }
}
