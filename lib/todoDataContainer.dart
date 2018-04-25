import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:todomvc/data.dart';

enum FilterMode {
  non,
  checked,
  unchecked,
}

class TodoListContainer extends StatefulWidget {
  final Widget child;
  final List<Entry> todoList;
  FilterMode filterMode = FilterMode.non;

  TodoListContainer({
    this.child, // required付けると警告でるからいったんはずす
    this.todoList,
  });

  static TodoListContainerState of(BuildContext context) {
    return (context.inheritFromWidgetOfExactType(_InheritedTodoListContainer)
            as _InheritedTodoListContainer)
        .data;
  }

  @override
  TodoListContainerState createState() => new TodoListContainerState();
}

class TodoListContainerState extends State<TodoListContainer> {
  final List<Entry> _todoList = new List<Entry>();

  ActivityIndicatorMixin listener;
  void addLoadingEndListener(ActivityIndicatorMixin mixin) {
    listener = mixin;
  }

  @override
  void initState() {
    super.initState();

    Future<http.Response> future =
        http.get('https://morning-ocean-78789.herokuapp.com/tasks');
    future.then((http.Response response) {
      final List<dynamic> responseJsonList = json.decode(response.body);
      // List responseJsonList = [Map, Map, Map, Map...]
      //       ↓
      //       map
      //       ↓
      // List entries = [Entry, Entry, Entry, Entry...]
      final Iterable<Entry> gotEntries = responseJsonList.map<Entry>((rawMap) {
        String title = rawMap['name'];
        String desc = rawMap['description'];
        bool isChecked = rawMap['status'][0] == 'completed';
        String id = rawMap['_id'];
        Entry entry = new Entry(
            title: title, description: desc, isChecked: isChecked, id: id);
        return entry;
      });
      setState(() {
        _todoList.addAll(gotEntries);
      });
      if (listener != null) {
        listener.onLodingCompleted();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return new _InheritedTodoListContainer(
      data: this,
      child: widget.child,
    );
  }

  int getTotoListLength() => _todoList.length;

  int getCheckedNum() => _todoList.where((entry) => entry.isChecked).length;

  int getUncheckedNum() => _todoList.where((entry) => !entry.isChecked).length;

  Entry getEntry(int index) => _todoList[index];

  void addEntry(Entry newEntry) {
    //postを使用してデータの追加をしたい
    var url = "https://morning-ocean-78789.herokuapp.com/tasks";
    http.post(url, body: {
      "name": newEntry.title,
      "description": newEntry.description,
    }).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        print("Success!");
        final responseBody = json.decode(response.body);
        newEntry.id = responseBody['_id'];
        setState(() => _todoList.add(newEntry));
        print(newEntry.id);
      }
    }).catchError((onError) {
      print(onError.toString());
      print("add: error");
    });
    print(url);
  }

  void removeCheckedAllEntry() {
    _todoList.forEach((entry) {
      if (entry.isChecked) removeEntry(entry);
    });
  }

  void removeEntry(Entry entry) {
    //postを使用してデータの追加をしたい
    var url = "https://morning-ocean-78789.herokuapp.com/tasks/${entry.id}";
    print(url);
    http.delete(url).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      if (response.statusCode == 200) {
        print("Success!");
        setState(() => _todoList.remove(entry));
      }
    }).catchError((onError) {
      print("remove: error");
    });
  }

  void updateAllEntryStats(bool isChecked) {
    _todoList.forEach((entry) {
      updateEntryStats(entry, isChecked);
    });
  }

  void updateEntryStats(Entry entry, bool isChecked) {
    //postを使用してデータの更新をしたい
    var url = "https://morning-ocean-78789.herokuapp.com/tasks/${entry.id}";
    String _status = isChecked ? "completed" : "pending";

    http.put(url, body: {
      "status": _status,
    }).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      setState(() {
        entry.isChecked = isChecked;
      });
    }).catchError((onError) => print("upadate: error"));
    print(url);
  }

  void updateEntryData(Entry entry, String title, String desc) {
    //postを使用してデータの更新をしたい
    var url = "https://morning-ocean-78789.herokuapp.com/tasks/${entry.id}";

    http.put(url, body: {
      "name": title,
      "description": desc,
    }).then((response) {
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      setState(() {
        entry.title = title;
        entry.description = desc;
      });
    }).catchError((onError) => print("upadate: error"));
    print(url);
  }
}

class _InheritedTodoListContainer extends InheritedWidget {
  final TodoListContainerState data;

  const _InheritedTodoListContainer({
    Key key,
    this.data, // required付けると警告でるからいったんはずす
    Widget child, // required付けると警告でるからいったんはずす
  }) : super(key: key, child: child);

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) {
    return true;
  }
}
/*
class StateContainerState extends State<StateContainer> {
  // Whichever properties you wanna pass around your app as state
  User user;

  // You can (and probably will) have methods on your StateContainer
  // These methods are then used through our your app to
  // change state.
  // Using setState() here tells Flutter to repaint all the
  // Widgets in the app that rely on the state you've changed.
  void updateUserInfo({firstName, lastName, email}) {
    if (user == null) {
      user = new User(firstName, lastName, email);
      setState(() {
        user = user;
      });
    } else {
      setState(() {
        user.firstName = firstName ?? user.firstName;
        user.lastName = lastName ?? user.lastName;
        user.email = email ?? user.email;
      });
    }
  }

 */
