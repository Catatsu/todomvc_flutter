import 'package:flutter/material.dart';
import 'package:todomvc/data.dart';
import 'package:todomvc/todoDataContainer.dart';

class EditTodoScreenState extends State<EditTodoScreen> {
  TextEditingController titleController;
  TextEditingController descController;
  bool _isButtonDisabled = true;

  BuildContext _context;

  @override
  void initState() {
    super.initState();
    titleController = new TextEditingController(text: widget.entry.title);
    descController = new TextEditingController(text: widget.entry.description);
  }

  @override
  Widget build(BuildContext context) {
    _context = context;
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('EditTodo'),
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
    TodoListContainerState container = TodoListContainer.of(context);
    container.updateEntry(
        widget.entry, titleController.text, descController.text);
    Navigator.pop(_context);
  }

  String _editing(String a) {
    if (titleController.text.length > 0 &&
        descController.text.length > 0 &&
        (titleController.text != widget.entry.title ||
            descController.text != widget.entry.description)) {
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

class EditTodoScreen extends StatefulWidget {
  final Entry entry;

  EditTodoScreen(
    this.entry,
  );

  @override
  createState() => new EditTodoScreenState();
}
