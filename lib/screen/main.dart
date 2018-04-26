import 'package:flutter/material.dart';
import 'package:todomvc/model/data.dart';
import 'package:todomvc/model/todoDataContainer.dart';
import 'package:todomvc/screen/all.dart';

class TodoEntryItem extends StatefulWidget {
  const TodoEntryItem(this.entry);

  final Entry entry;

  @override
  createState() => new TodoEntryItemState();
}

class TodoEntryItemState extends State<TodoEntryItem> {
  final _biggerFont = const TextStyle(fontSize: 18.0);

  @override
  Widget build(BuildContext context) => new ListTile(
        leading: new IconButton(
            icon: new Icon(
              widget.entry.isChecked
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: widget.entry.isChecked ? Colors.red : null,
            ),
            onPressed: () {
              setState(_save);
            }),
        title: new Text(
          widget.entry.title,
          style: _biggerFont,
        ),
        onTap: () {
          Navigator.push(
            context,
            new MaterialPageRoute<Entry>(
              builder: (context) => new DetailScreen(widget.entry),
            ),
          );
        },
      );

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
  List<Entry> filteredTodoList = new List<Entry>();

  @override
  void initState() {
    super.initState();

    // インジケータ開始
    showIndicator(context);
  }

  @override
  Widget build(BuildContext context) {
    TodoListContainerState container = TodoListContainer.of(context);

    // フィルタリングしたい
    switch (container.widget.filterMode) {
      case FilterMode.checked:
        filteredTodoList = container.getCheckedTodoList();
        break;
      case FilterMode.unchecked:
        filteredTodoList = container.getUncheckedTodoList();
        break;
      case FilterMode.none:
      default:
        List<Entry> todoList = container.getTodoList();
        if (todoList != null) {
          filteredTodoList = todoList;
        }
        break;
    }

    // 通信が終わったらインジケータを止めるために教えてもらう
    container.addLoadingEndListener(this);
    print(container.widget.filterMode);
    return new Scaffold(
      body: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: filteredTodoList.length,
          itemBuilder: (context, i) => new TodoEntryItem(filteredTodoList[i])),
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

class _FilterPopupMenu extends StatefulWidget {
  @override
  _FilterPopupMenuState createState() => new _FilterPopupMenuState();
}

class _FilterPopupMenuState extends State<_FilterPopupMenu> {
  @override
  Widget build(BuildContext context) => new PopupMenuButton<RightMenu>(
        icon: new Icon(Icons.filter_list),
        onSelected: (RightMenu result) {
          TodoListContainerState container = TodoListContainer.of(context);
          switch (result) {
            case RightMenu.nonFilter:
              container.updateFilterMode(FilterMode.none);
              break;
            case RightMenu.filterChecked:
              container.updateFilterMode(FilterMode.checked);
              break;
            case RightMenu.filterUnchecked:
              container.updateFilterMode(FilterMode.unchecked);
              break;
            default:
          }
        },
        itemBuilder: (BuildContext context) => <PopupMenuEntry<RightMenu>>[
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
      );
}

class _ActionPopupMenu extends StatefulWidget {
  @override
  _ActionPopupMenuState createState() => new _ActionPopupMenuState();
}

class _ActionPopupMenuState extends State<_ActionPopupMenu> {
  @override
  Widget build(BuildContext context) => new PopupMenuButton<RightMenu>(
        onSelected: _onSelect,
        itemBuilder: (BuildContext context) => <PopupMenuEntry<RightMenu>>[
              const PopupMenuItem<RightMenu>(
                value: RightMenu.checkingAllTodo,
                child: const Text('全てのTODOを完了'),
              ),
              const PopupMenuItem<RightMenu>(
                value: RightMenu.removeAllChecked,
                child: const Text('完了済みのTODOを削除'),
              ),
            ],
      );

  void _onSelect(RightMenu result) {
    TodoListContainerState container = TodoListContainer.of(context);
    switch (result) {
      case RightMenu.checkingAllTodo:
        setState(() {
          container.updateAllEntryStats(true);
        });
        break;
      case RightMenu.removeAllChecked:
        // チェックをいれた項目を削除
        // TODO: ローディング表示スタート
        container
            .removeEntries(container.getCheckedTodoList())
            .then((bool isSucceeded) {
          // ここが呼ばされた時点で、すでにsetState()はコールされている
          //TODO: ローディング表示終了
        });
        break;
      default:
    }
  }
}

class MainScreenState extends State<MainScreen> {
  int index = 0;

  @override
  Widget build(BuildContext context) => new DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text('Todo MVC'),
            actions: <Widget>[
              new _FilterPopupMenu(),
              new _ActionPopupMenu(),
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

  void _addTodo() {
    TodoListContainerState container = TodoListContainer.of(context);

    Navigator
        .push<Entry>(
            context,
            new MaterialPageRoute<Entry>(
                builder: (context) => new AddTodoScreen()))
        .then((value) {
      //TODO: valueが空の場合を考慮する
      setState(() {
        container.addEntry(value);
      });
    });
  }
}

class MainScreen extends StatefulWidget {
  @override
  createState() => new MainScreenState();
}
