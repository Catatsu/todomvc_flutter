import 'dart:async';

import 'package:flutter/material.dart';
import 'package:todomvc/data.dart';
import 'package:todomvc/editTodo.dart';
import 'package:todomvc/todoDataContainer.dart';

class DetailScreen extends StatefulWidget {
  final Entry entry;

  DetailScreen(
    this.entry,
  );
//  final String title;
//  DetailScreen(
//    this.title,
//  );

  @override
  createState() => new _DetailScreenState();
}

enum Department {
  treasury,
  state,
}

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Detail'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.delete_forever),
            onPressed: _deleteTodo,
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              new IconButton(
                  icon: new Icon(
                    widget.entry.isChecked
                        ? Icons.check_box
                        : Icons.check_box_outline_blank,
                    color: widget.entry.isChecked ? Colors.red : null,
                  ),
                  onPressed: () {
                    setState(() {
                      _save();
                    });
                  }),
              new Text(widget.entry.title),
            ],
          ),
          new Text(widget.entry.description ?? ''),
        ],
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Increment',
        child: new Icon(Icons.edit),
        onPressed: _editTodo,
      ),
    );
  }

  void _save() {
    TodoListContainerState container = TodoListContainer.of(context);
    container.updateEntryStats(widget.entry, !widget.entry.isChecked);
  }

  Future<Department> _askedToLead() async {
    var completer = new Completer<Department>();
    switch (await showDialog<Department>(
        context: context,
        builder: (BuildContext context) {
          return new SimpleDialog(
            title: const Text('本当に削除しますか？'),
            children: <Widget>[
              new SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Department.treasury);
                },
                child: const Text('削除する'),
              ),
              new SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Department.state);
                },
                child: const Text('キャンセル'),
              ),
            ],
          );
        })) {
      case Department.treasury:
        completer.complete(Department.treasury);
        break;
      case Department.state:
        completer.complete(Department.state);
        break;
    }
    return completer.future;
  }

  void _deleteTodo() {
    //TODO: 本当に削除してよいか？確認を入れる
    _askedToLead().then((value) {
      print("Owari");
      print(value);
      TodoListContainerState container = TodoListContainer.of(context);
      container.removeEntry(widget.entry);

      Navigator.pop(context);
    });
    print("_deleteTodo end");
  }

  void _editTodo() {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) {
          return new EditTodoScreen(widget.entry);
        },
      ),
    );
  }
}
