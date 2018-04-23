import 'package:flutter/material.dart';
import 'package:todomvc/addTodo.dart';
import 'package:todomvc/data.dart';
import 'package:todomvc/detail.dart';

//void main() => runApp(new MyApp());
void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new TabBarDemo());
  }
}

List<Entry> initialTodoList = <Entry>[
  new Entry(title: 'Chapter A', isChecked: true, description: ""),
  new Entry(title: 'Chapter B', isChecked: false),
  new Entry(title: 'Chapter C'),
];

class TodoEntryItem extends StatefulWidget {
  const TodoEntryItem(this.entry);

  final Entry entry;

  @override
  createState() => new TodoEntryItemState();
}

class TodoEntryItemState extends State<TodoEntryItem> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) {
    return new ListTile(
      leading: new IconButton(
          icon: new Icon(
            widget.entry.isChecked
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            color: widget.entry.isChecked ? Colors.red : null,
          ),
          onPressed: () {
            setState(() {
              widget.entry.isChecked = !widget.entry.isChecked;
            });
          }),
      title: new Text(
        widget.entry.title,
        style: _biggerFont,
      ),
      onTap: () {
        Navigator.push(
          context,
          new MaterialPageRoute<Entry>(
            builder: (context) {
              return new DetailScreen(widget.entry.title);
            },
          ),
        );
      },
    );
  }
}

class StatsWidget extends StatefulWidget {
  @override
  createState() => new StatsWidgetState();
}

class StatsWidgetState extends State<StatsWidget> {
  @override
  Widget build(BuildContext context) {
    return new Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          new Text("完了"),
          new Text("0"),
          new Text("未完了"),
          new Text("1"),
        ],
      ),
    );
  }
}

class TodoListWidget extends StatefulWidget {
  final List<Entry> todoList;

  TodoListWidget(this.todoList);

  @override
  createState() => new TodoListWidgetState(this.todoList);
}

class TodoListWidgetState extends State<TodoListWidget> {
  final List<Entry> todoList;

  TodoListWidgetState(this.todoList);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: this.todoList.length,
          itemBuilder: (context, i) {
            return new TodoEntryItem(this.todoList[i]);
          }),
    );
  }
}

class TabBarDemoState extends State<TabBarDemo> {
  int index = 0;

  final List<Entry> todoList;

  TabBarDemoState({this.todoList});

  @override
  Widget build(BuildContext context) {
    return new DefaultTabController(
      length: 2,
      child: new Scaffold(
        appBar: new AppBar(
          title: new Text('Todo MVC'),
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.filter_list),
              onPressed: null,
            ),
            new IconButton(
              icon: new Icon(Icons.linear_scale),
              onPressed: null,
            ),
          ],
        ),
        body: new Stack(
          children: <Widget>[
            new Offstage(
              offstage: index != 0,
              child: new TickerMode(
                enabled: index == 0,
                child: new TodoListWidget(this.todoList),
//                  child: new Row(
//                    children: <Widget>[
//                      new Checkbox(value: false, onChanged: null),
//                      new Text(
//                          "aasfdadsfafdsafafdasfasdfasd"),
//                    ],
//                  ),
              ),
            ),
            new Offstage(
              offstage: index != 1,
              child: new TickerMode(
                enabled: index == 1,
                child: new StatsWidget(),
              ),
            ),
          ],
        ),
        // TODO BarItemに境界線ほしいよね
        bottomNavigationBar: new BottomNavigationBar(
            currentIndex: index,
            onTap: (int index) {
              print("onTap start");
              setState(() {
                print("state changed");
                this.index = index;
              });
              print("onTap end");
            },
            items: [
              new BottomNavigationBarItem(
                icon: new Icon(Icons.featured_play_list),
                title: new Text("Todos"),
              ),
              new BottomNavigationBarItem(
                icon: new Icon(Icons.show_chart),
                title: new Text("Stats"),
              ),
            ]),
        floatingActionButton: new FloatingActionButton(
          tooltip: 'Increment',
          child: new Icon(Icons.add),
          onPressed: _addTodo,
        ), // This trailing comma makes auto-formatting nicer for build methods.
      ),
    );
  }

  void _addTodo() {
    Navigator.push<Entry>(
      context,
      new MaterialPageRoute<Entry>(
        builder: (context) {
          return new AddTodoScreen();
        },
      ),
    ).then((value) {
      //TODO: valueが空の場合を考慮する
      setState(() {
        print(value);
        //todoList.add(new Entry(title: "test", description: "AAA"));
        todoList.add(value);
      });
    });
  }
}

class TabBarDemo extends StatefulWidget {
  @override
  createState() => new TabBarDemoState(todoList: initialTodoList);
}
