import 'package:flutter/material.dart';
import 'constants.dart';

class CustomDialog extends StatefulWidget {
  final String title, buttonText, itemTitle, hintText;

  CustomDialog({
    Key key, 
    this.title,
    this.buttonText,
    this.itemTitle,
    this.hintText,
  }) : super(key: key);

  @override
  _CustomDialogState createState() => _CustomDialogState();
}

class _CustomDialogState extends State<CustomDialog> {
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
      text: widget.itemTitle != null ? widget.itemTitle : null
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
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),      
      elevation: 0.0,
      backgroundColor: Colors.transparent,
      child: dialogContent(context),
    );
    
  }

  dialogContent(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        top: Consts.padding/2,
        //bottom: Consts.padding,
        left: Consts.padding/2,
        right: Consts.padding/2,
      ),
      //margin: EdgeInsets.only(top: Consts.avatarRadius),
      decoration: new BoxDecoration(
        color: Colors.white,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(Consts.padding),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: const Offset(0.0, 10.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // To make the card compact
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(
              fontSize: 20.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          //SizedBox(height: 16.0),
          TextField(
            cursorColor: Colors.black,
            autofocus: true,
            decoration: new InputDecoration(
              labelText: '', 
              hintText: widget.hintText,
              counterText:  _textFieldController.text.length.toString(),
            ),
            textCapitalization: TextCapitalization.sentences,
            controller: _textFieldController,
            onEditingComplete: _onPressed,
            style: TextStyle(color: Colors.black, fontSize: 16.0),
          ),
          //SizedBox(height: 24.0),
          ButtonBar(
            //mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  Navigator.of(context).pop(); // To close the dialog
                },
                child: Text(
                  'Cancel',
                  style: TextStyle(
                    fontSize: 12.0,
                  )
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0),
                    bottomLeft: Radius.circular(10.0),
                    topRight: Radius.circular(10.0)
                  )
                ),
              ),
              RaisedButton(
                disabledColor: Colors.grey,
                color: Colors.green,
                onPressed: _onPressed,
                child: Text(
                  widget.buttonText,
                  style: TextStyle(
                    fontSize: 12.0,
                  )
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomRight: Radius.circular(10.0),
                    topLeft: Radius.circular(10.0)
                  )
                ),
              ),
            ] 
          ),
        ],
      )
    );
  }

  void save() {
    if(_textFieldController.text.isNotEmpty){
      Navigator.of(context).pop(_textFieldController.text);
    }
  }
}