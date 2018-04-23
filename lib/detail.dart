import 'package:flutter/material.dart';
import 'package:todomvc/data.dart';
import 'package:todomvc/editTodo.dart';

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

class _DetailScreenState extends State<DetailScreen> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Detail'),
        actions: <Widget>[
          new IconButton(
            icon: new Icon(Icons.delete_forever),
            onPressed: null,
          ),
        ],
      ),
      body: new Text(widget.entry.title),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Increment',
        child: new Icon(Icons.edit),
        onPressed: _editTodo,
      ),
    );
  }

  void _editTodo() {
    Navigator.push(
      context,
      new MaterialPageRoute(
        builder: (context) {
          return new EditTodoScreen();
        },
      ),
    );
  }
}
