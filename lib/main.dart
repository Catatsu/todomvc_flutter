import 'package:flutter/material.dart';

//void main() => runApp(new MyApp());
void main() => runApp(new TabBarDemo());

class TabBarDemoState extends State {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new DefaultTabController(
        length: 2,
        child: new Scaffold(
          appBar: new AppBar(
            title: new Text('Todo MVC'),
            actions: <Widget>[
              new IconButton(icon: new Icon(Icons.airport_shuttle), ),
              new IconButton(icon: new Icon(Icons.screen_lock_landscape), ),
            ],
          ),
          body: new TabBarView(
            children: [
              new Icon(Icons.directions_walk),
              new Icon(Icons.directions_transit),
            ],
          ),
          // TODO BarItemに境界線ほしいよね
          bottomNavigationBar: new BottomNavigationBar(currentIndex: 0, items: [
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
  }
  void _pushSaved() {
  }
}

class TabBarDemo extends StatefulWidget {
  @override
  State createState(){
    return new TabBarDemoState();
  }
}
