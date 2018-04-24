import 'package:flutter/material.dart';
import 'package:todomvc/todoDataContainer.dart';

class StatsScreen extends StatefulWidget {
  @override
  _StatsScreenState createState() => new _StatsScreenState();
}

class _StatsScreenState extends State<StatsScreen> {
  @override
  Widget build(BuildContext context) {
    TodoListContainerState container = TodoListContainer.of(context);

    final String checkedNum = container.getCheckedNum().toString();
    final String uncheckedNum = container.getUncheckedNum().toString();
    return new Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("完了"),
          new Text(checkedNum),
          new Text("未完了"),
          new Text(uncheckedNum),
        ],
      ),
    );
  }
}
