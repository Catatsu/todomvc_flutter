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
    //print("TodoEntryItemState build");
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
              _save();
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

  void _save() {
    TodoListContainerState container = TodoListContainer.of(context);
    container.updateEntryStats(widget.entry, !widget.entry.isChecked);
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
    print(container.widget.filterMode);
    return new Scaffold(
      body: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: container.getTotoListLength(),
          itemBuilder: (context, i) {
            Entry entry = container.getEntry(i);
            if (container.widget.filterMode == FilterMode.checked &&
                !entry.isChecked) {
              return null;
            } else if (container.widget.filterMode == FilterMode.unchecked &&
                entry.isChecked) {
              return null;
            }
            return new TodoEntryItem(container.getEntry(i));
          }),
    );
  }
}

enum RightMenu {
  nonFilter,
  filterChecked,
  filterUnchecked,
  checkingAllTodo,
  removeAllChecked
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
            new PopupMenuButton<RightMenu>(
              icon: new Icon(Icons.filter_list),
              onSelected: (RightMenu result) {
                TodoListContainerState container =
                    TodoListContainer.of(context);
                setState(() {
                  switch (result) {
                    case RightMenu.nonFilter:
                      container.widget.filterMode = FilterMode.non;
                      break;
                    case RightMenu.filterChecked:
                      container.widget.filterMode = FilterMode.checked;
                      break;
                    case RightMenu.filterUnchecked:
                      container.widget.filterMode = FilterMode.unchecked;
                      break;
                    default:
                  }
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<RightMenu>>[
                    const PopupMenuItem<RightMenu>(
                      value: RightMenu.nonFilter,
                      child: const Text('全てのTODOを表示'),
                    ),
                    const PopupMenuItem<RightMenu>(
                      value: RightMenu.filterChecked,
                      child: const Text('完了済みのTODOを表示'),
                    ),
                    const PopupMenuItem<RightMenu>(
                      value: RightMenu.filterUnchecked,
                      child: const Text('未完了のTODOを表示'),
                    ),
                  ],
            ),
            new PopupMenuButton<RightMenu>(
              onSelected: (RightMenu result) {
                TodoListContainerState container =
                    TodoListContainer.of(context);
                setState(() {
                  switch (result) {
                    case RightMenu.checkingAllTodo:
                      container.updateAllEntryStats(true);
                      break;
                    case RightMenu.removeAllChecked:
                      container.removeCheckedAllEntry();
                      break;
                    default:
                  }
                });
              },
              itemBuilder: (BuildContext context) =>
                  <PopupMenuEntry<RightMenu>>[
                    const PopupMenuItem<RightMenu>(
                      value: RightMenu.checkingAllTodo,
                      child: const Text('全てのTODOを完了'),
                    ),
                    const PopupMenuItem<RightMenu>(
                      value: RightMenu.removeAllChecked,
                      child: const Text('完了済みのTODOを削除'),
                    ),
                  ],
            )
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
