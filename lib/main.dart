import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'item.dart';
import 'draggable_card.dart';
import 'custom_dialog.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tick List',
      theme: ThemeData(
        
        primarySwatch: Colors.yellow,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);

  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  List<Item> list = List<Item>();

  @override
  void initState() {
    super.initState();
    loadData();
  }

  GlobalKey<ScaffoldState> _key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    //Color c = const Color(0xff4CAF50); // green
    return Scaffold(
      key: _key,
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check, color: Colors.green),
            Text(
              'Tick List',
              key: Key('main-app-title'),
            )
          ],
        ),
      ),
      body: list.isNotEmpty ? buildBody() : buildEmptyBody(),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => showItemDialog(),
      ),
    );
  }

  Widget buildBody() {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        return buildItem(list[index], index);
      },
    );
  }

  Widget buildEmptyBody() {
    return 
      DraggableCard(
        child: Image.asset(
          'assets/images/icon.png',
          width: 128,
        ),
      );
  }

  Widget buildItem(Item item, int index) {
    return Dismissible(
      key: Key(item.hashCode.toString()),
      onDismissed: (direction) {
        setState(() {
          removeItem(item);
        });

        _key.currentState..removeCurrentSnackBar()..showSnackBar(
          SnackBar(
            content: Text("Deleted: ${item.title}"),
            action: SnackBarAction(
              label: "UNDO",
              onPressed: () => setState(() => addItem(item, index: index)),
            ),
          ),
        );
      },
      direction: DismissDirection.startToEnd,
      background: Container(
        color: Colors.white,
        child: Icon(Icons.delete, color: Colors.red),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 12.0)
      ),
      child: buildListTile(item, index),
    );
  }

  Widget buildListTile(Item item, int index) {
    return ListTile(
      leading: 
        item.done 
          ? Icon(Icons.check, color: Colors.green, key: Key('done-icon-$index'))
          : Icon(Icons.remove, color: Colors.black, key: Key('done-icon-$index')),
      title: Text(
        item.title,
        key: Key('item-$index'),
        style: TextStyle(
          color: item.done ? Colors.grey : Colors.black, 
          fontSize: 20.0,
          decoration: item.done ? TextDecoration.lineThrough : null
        ),
      ),
      onTap: () {
        setState(() {
          setDone(item);
        });
      },
      onLongPress: () => showItemDialog(item: item),
    );
  }

  void showItemDialog({ Item item }) async {
    final String title = await asyncInputDialog(context, item != null ? item.title : null);
    if (title != null) {
      setState(() => 
        item != null 
          ? editItem(item, title) 
          : addItem(Item(title: title)));
    }
  }

  Future<String> asyncInputDialog(BuildContext context, String itemTitle) async {
    return showDialog<String>(
      context: context,
      barrierDismissible: false, // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) => CustomDialog(
        title: itemTitle != null ? 'Edit Item' : 'Add Item',
        buttonText: 'Save',
        itemTitle: itemTitle,
        hintText: 'e.g. Shopping.'
      ),
    );
  }

  void setDone(Item item) {
    item.done = !item.done;
    saveData();
  }
  void removeItem(Item item) {
    list.remove(item);
    saveData();
  }

  void addItem(Item item, { int index = 0 }) {
    list.insert(index, item);
    saveData();
  }

  void editItem(Item item, String title) {
    item.title = title;
    saveData();
  }

  void saveData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    List<String> sharedList = list.map(
      (item) => json.encode(item.toMap())
    ).toList();

    sharedPreferences.setStringList('list', sharedList);
  }

  void loadData() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    
    List<String> sharedList = sharedPreferences.getStringList('list');

    if(sharedList != null) {
      list = sharedList.map(
        (item) => Item.fromMap(json.decode(item))
      ).toList();
      setState(() {});
    }
  }
}
