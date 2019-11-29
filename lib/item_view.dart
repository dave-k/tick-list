import 'package:flutter/material.dart';

import 'item.dart';

class ItemView extends StatefulWidget {
  final Item item;

  ItemView({Key key, this.item}) : super(key: key);

  @override
  _ItemViewState createState() => _ItemViewState();
}

class _ItemViewState extends State<ItemView> {
  TextEditingController _textFieldController;
  VoidCallback _onPressed;

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    _textFieldController = TextEditingController(
      text: widget.item != null ? widget.item.title : null
    );
    // Enable/Disable Save button
    _textFieldController.addListener((){
      setState(() {
        _onPressed = _textFieldController.text.isNotEmpty ? () => save() : null;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: Text(
           widget.item != null ? 'Edit Item' : 'Add Item',
           key: Key('item-view-title'),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              cursorColor: Colors.black,
              autofocus: true,
              textCapitalization: TextCapitalization.sentences,
              controller: _textFieldController,
              onEditingComplete: _onPressed,
              style: TextStyle(color: Colors.black, fontSize: 20.0),
            ),
            RaisedButton(
              elevation: 3.0,
              color: Theme.of(context).accentColor,
              textColor: Colors.white,
              disabledColor: Colors.grey,
              disabledTextColor: Colors.black,
              padding: EdgeInsets.all(8.0),
              splashColor: Colors.yellowAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0)
                )
              ),
              onPressed: _onPressed,
              child: Text(
                'Save',
                style: TextStyle(color: Colors.black, fontSize: 20.0)
              )
            )
          ],
        ),
      )
    );
  }

  void save() {
    if(_textFieldController.text.isNotEmpty){
      Navigator.of(context).pop(_textFieldController.text);
    }
  }
}