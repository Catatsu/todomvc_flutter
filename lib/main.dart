import 'package:flutter/material.dart';
import 'package:english_words/english_words.dart';

//void main() => runApp(new MyApp());
void main() => runApp(new TabBarDemo());

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry({this.title, this.isChecked:false, this.description});
  String title;
  String description;
  bool isChecked;
}

List<Entry> todoList = <Entry>[
  new Entry(title:'Chapter A', isChecked:true, description:""),
  new Entry(title:'Chapter B', isChecked:false),
  new Entry(title:'Chapter C'),
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
    return _buildRow(widget.entry);
  }

  Widget _buildRow(Entry pair) {
    return new ListTile(
      title: new Text(
        pair.title,
        style: _biggerFont,
      ),
      leading: new Icon(
        widget.entry.isChecked ? Icons.check_box : Icons.check_box_outline_blank,
        color: widget.entry.isChecked ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          widget.entry.isChecked = !widget.entry.isChecked;
        });
      },


    );
  }
}

class RandomWords extends StatefulWidget {
  @override
  createState() => new RandomWordsState();
}

class RandomWordsState extends State<RandomWords> {
  final _suggestions = <WordPair>[];

  final _biggerFont = const TextStyle(fontSize: 18.0);

  final _saved = new Set<WordPair>();

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      body: new ListView.builder(
          padding: const EdgeInsets.all(16.0),
          itemCount: todoList.length,
          itemBuilder: (context, i) {
            return new TodoEntryItem(todoList[i]);
          }
      ),
    );
  }

  Widget _buildRow(WordPair pair) {
    final alreadySaved = _saved.contains(pair);

    return new ListTile(
      title: new Text(
        pair.asPascalCase,
        style: _biggerFont,
      ),
      leading: new Icon(
        alreadySaved ? Icons.check_box : Icons.check_box_outline_blank,
        color: alreadySaved ? Colors.red : null,
      ),
      onTap: () {
        setState(() {
          if (alreadySaved) {
            _saved.remove(pair);
          } else {
            _saved.add(pair);
          }
        });
      },


    );
  }

}



class ListDemoState extends State {
  @override
  Widget build(BuildContext context) {

  }
}
class TabBarDemoState extends State {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    print("build start");
    Widget app = new MaterialApp(
      home: new DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text('Todo MVC'),
            actions: <Widget>[
              new IconButton(
                icon: new Icon(Icons.filter_list),
              ),
              new IconButton(
                icon: new Icon(Icons.linear_scale),
              ),
            ],
          ),
          body: new Stack(
            children: <Widget>[
              new Offstage(
                offstage: index != 0,
                child: new TickerMode(
                  enabled: index == 0,
                    child: new RandomWords(),
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
                  child: new Text("stats(まだない!)"),
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
            onPressed: _pushSaved,
          ), // This trailing comma makes auto-formatting nicer for build methods.
        ),
      ),
    );
    print("build end");
    return app;
  }

  void _pushSaved() {}
}

class TabBarDemo extends StatefulWidget {
  @override
  State createState() {
    return new TabBarDemoState();
  }
}
