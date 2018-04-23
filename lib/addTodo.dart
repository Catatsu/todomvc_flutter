import 'package:flutter/material.dart';
import 'package:todomvc/data.dart';

class AddTodoScreenState extends State<AddTodoScreen> {
  final titleController = new TextEditingController();
  final descController = new TextEditingController();
  bool _isButtonDisabled = true;

  BuildContext _context;

  @override
  Widget build(BuildContext context) {
    _context = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('AddTodo'),
        actions: <Widget>[
          new FlatButton(
              onPressed: _isButtonDisabled ? null : _save,
              disabledTextColor: new Color(0x55FFFFFF),
              textColor: new Color(0xFFFFFFFF),
              child: new Text('保存', style: new TextStyle(fontSize: 20.1)))
        ],
      ),
      body: new Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          new Text('タイトル'),
          new TextField(
            controller: titleController,
            onChanged: _editing,
          ),
          new Text('詳細'),
          new TextField(
            controller: descController,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            onChanged: _editing,
          ),
        ],
      ),
      //body: new Text('title'));
    );
  }

  void _save() {
    Entry entry = new Entry(
        title: titleController.text, description: descController.text);
    //todoList.add(entry);
    Navigator.pop(_context, entry);
    //Navigator.of(_context).pop<Entry>(entry);
  }

  String _editing(String a) {
    if (titleController.text.length > 0 && descController.text.length > 0) {
      setState(() {
        _isButtonDisabled = false;
      });
    } else {
      setState(() {
        _isButtonDisabled = true;
      });
    }
    return a;
  }
}

class AddTodoScreen extends StatefulWidget {
  @override
  createState() => new AddTodoScreenState();
}
