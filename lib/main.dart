import 'package:flutter/material.dart';
import 'package:todomvc/addTodo.dart';
import 'package:todomvc/data.dart';
import 'package:todomvc/detail.dart';
import 'package:todomvc/stats.dart';
import 'package:todomvc/todoDataContainer.dart';

//void main() => runApp(new MyApp());
void main() => runApp(new TodoListContainer(child: new MyApp()));

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(home: new TabBarDemo());
  }
}

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
    print("TodoEntryItemState build");
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
              return new DetailScreen(widget.entry);
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
  TodoListWidget();

  @override
  createState() => new TodoListWidgetState();
}

class TodoListWidgetState extends State<TodoListWidget>
    with ActivityIndicatorMixin {
  TodoListWidgetState();

  @override
  void initState() {
    super.initState();

    // インジケータ開始
    showIndicator(context);
  }

  @override
  Widget build(BuildContext context) {
    TodoListContainerState container = TodoListContainer.of(context);

    // 通信が終わったらインジケータを止めるために教えてもらう
    container.addLoadingEndListener(this);

    return new Scaffold(
      body: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: container.getTotoListLength(),
          itemBuilder: (context, i) {
            return new TodoEntryItem(container.getEntry(i));
          }),
    );
  }
}

class TabBarDemoState extends State<TabBarDemo> {
  int index = 0;

  TabBarDemoState();

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
                child: new TodoListWidget(),
              ),
            ),
            new Offstage(
              offstage: index != 1,
              child: new TickerMode(
                enabled: index == 1,
                child: new StatsScreen(),
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
    TodoListContainerState container = TodoListContainer.of(context);

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
        container.addEntry(value);
      });
    });
  }
}

class TabBarDemo extends StatefulWidget {
  @override
  createState() => new TabBarDemoState();
}
