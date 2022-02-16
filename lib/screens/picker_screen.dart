import 'package:reorderableitemsview/reorderableitemsview.dart';
import 'package:flutter/material.dart';

class PickerScreen extends StatelessWidget {
  const PickerScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
          appBar: AppBar(
            title: const Text('نماذج من خبرة العمل'),
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => ListPageView()));
                  },
                  child: const Text("صور عن أعمال العامل"),
                ),
                const SizedBox(
                  height: 16.0,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => GridPageView()));
                  },
                  child: const Text("مقاطع فيديو عن أعمال العامل"),
                ),
              ],
            ),
          )),
    );
  }
}

class GridPageView extends StatefulWidget {
  @override
  _GridPageViewState createState() => _GridPageViewState();
}

class _GridPageViewState extends State<GridPageView> {
  List<StaggeredTileExtended> _listStaggeredTileExtended =
      <StaggeredTileExtended>[
    StaggeredTileExtended.count(2, 2),
    StaggeredTileExtended.count(2, 1),
    StaggeredTileExtended.count(1, 2),
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(2, 2),
    StaggeredTileExtended.count(1, 2),
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(3, 1),
    StaggeredTileExtended.count(1, 1),
    StaggeredTileExtended.count(4, 1),
  ];

  List<Widget> _tiles = <Widget>[
    _Example01Tile(Key("a"), Colors.green, Icons.widgets),
    _Example01Tile(Key("b"), Colors.lightBlue, Icons.wifi),
    _Example01Tile(Key("c"), Colors.amber, Icons.panorama_wide_angle),
    _Example01Tile(Key("d"), Colors.brown, Icons.map),
    _Example01Tile(Key("e"), Colors.deepOrange, Icons.send),
    _Example01Tile(Key("f"), Colors.indigo, Icons.airline_seat_flat),
    _Example01Tile(Key("g"), Colors.red, Icons.bluetooth),
    _Example01Tile(Key("h"), Colors.pink, Icons.battery_alert),
    _Example01Tile(Key("i"), Colors.purple, Icons.desktop_windows),
    _Example01Tile(Key("j"), Colors.blue, Icons.radio),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Demo"),
      ),
      body: ReorderableItemsView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            _tiles.insert(newIndex, _tiles.removeAt(oldIndex));
          });
        },
        children: _tiles,
        crossAxisCount: 4,
        isGrid: true,
        staggeredTiles: _listStaggeredTileExtended,
        longPressToDrag: false,
      ),
    );
  }
}

class _Example01Tile extends StatelessWidget {
  _Example01Tile(Key key, this.backgroundColor, this.iconData)
      : super(key: key);

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: backgroundColor,
      child: InkWell(
        onTap: () {},
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Icon(
              iconData,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

class ListPageView extends StatefulWidget {
  @override
  _ListPageViewState createState() => _ListPageViewState();
}

class _ListPageViewState extends State<ListPageView> {
  List<Widget> _tiles = <Widget>[
    _Example01Tile(Key("a"), Colors.green, Icons.widgets),
    _Example01Tile(Key("b"), Colors.lightBlue, Icons.wifi),
    _Example01Tile(Key("c"), Colors.amber, Icons.panorama_wide_angle),
    _Example01Tile(Key("d"), Colors.brown, Icons.map),
    _Example01Tile(Key("e"), Colors.deepOrange, Icons.send),
    _Example01Tile(Key("f"), Colors.indigo, Icons.airline_seat_flat),
    _Example01Tile(Key("g"), Colors.red, Icons.bluetooth),
    _Example01Tile(Key("h"), Colors.pink, Icons.battery_alert),
    _Example01Tile(Key("i"), Colors.purple, Icons.desktop_windows),
    _Example01Tile(Key("j"), Colors.blue, Icons.radio),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List Demo"),
      ),
      body: ReorderableItemsView(
        onReorder: (int oldIndex, int newIndex) {
          setState(() {
            _tiles.insert(newIndex, _tiles.removeAt(oldIndex));
          });
        },
        feedBackWidgetBuilder: (context, index, child) {
          return Container(
            child: child,
          );
        },
        children: _tiles,
        longPressToDrag: false,
      ),
    );
  }
}

class _Example02Tile extends StatelessWidget {
  _Example02Tile(Key key, this.backgroundColor, this.iconData)
      : super(key: key);

  final Color backgroundColor;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: backgroundColor,
      child: new InkWell(
        onTap: () {},
        child: new Center(
          child: new Padding(
            padding: EdgeInsets.all(4.0),
            child: new Icon(
              iconData,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
