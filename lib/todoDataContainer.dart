import 'package:flutter/material.dart';
import 'package:todomvc/data.dart';

class TodoListContainer extends StatefulWidget {
  final Widget child;
  final List<Entry> todoList;

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

  @override
  Widget build(BuildContext context) {
    return new _InheritedTodoListContainer(
      data: this,
      child: widget.child,
    );
  }

  int getTotoListLength() {
    return _todoList.length;
  }

  Entry getEntry(int index) {
    return _todoList[index];
  }

  void addEntry(Entry newEntry) {
    setState(() {
      _todoList.add(newEntry);
    });
  }

  void removeEntry(Entry entry) {
    setState(() {
      _todoList.remove(entry);
    });
  }

  @override
  void initState() {
    super.initState();
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
