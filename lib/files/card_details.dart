import 'dart:convert';

import 'package:flutter/material.dart';
import 'cardd.dart';
import "package:rflutter_alert/rflutter_alert.dart";
import 'package:http/http.dart'  as http;

class ShowDetails extends StatefulWidget {

  final UserCard usercardd;

  ShowDetails({Key key, @required this.usercardd}): super(key: key);

  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {

  final _busController = new TextEditingController();
  bool _validateBus = false;
  final _emailController = new TextEditingController();
  bool _validateEmail = false;
  final _latController = new TextEditingController();
  bool _validateLat = false;
  final _longController = new TextEditingController();
  bool _validateLong = false;
  final _refController = new TextEditingController();

  final FocusNode _businessFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _latFocus = FocusNode();
  final FocusNode _longFocus = FocusNode();
  final FocusNode _refFocus = FocusNode();

  bool bUpdatePressed = false;
  bool bStatus = true;
  bool bError = false;
  String sError, sStatus = "active";
  
  @override
  void initState() {
    _busController.text = widget.usercardd.businessname;
    _emailController.text = widget.usercardd.useremail;
    _latController.text = widget.usercardd.latitude;
    _longController.text = widget.usercardd.longitude;
    _refController.text = widget.usercardd.referenceNo;
    bStatus = true;
    super.initState();
  }

  @override
  void dispose() {
    _busController.dispose();
    _emailController.dispose();
    _latController.dispose();
    _longController.dispose();
    _refController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          leading: new IconButton(
               icon: new Icon(Icons.arrow_back, color: Colors.white),
               onPressed: () => Navigator.of(context).pop(),
              ), 
          backgroundColor: Color.fromRGBO(51, 120, 180, 1),
          title: Center(child:Image.asset('Fotos/logo.png', fit: BoxFit.cover)),
          elevation: 0.0,
        ),
        body: FormUI()
    );
  }

  Widget FormUI() {
    return new Container(
      padding: EdgeInsets.only(left: 25.0, right: 25.0),
      child: ListView(
      children: <Widget>[
        new TextField(
          style: new TextStyle(color: Colors.white),
          decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white,),
              labelText: 'Bussiness name',
              errorText: _validateBus
                  ? 'Restaurant must be more than 1 charater'
                  : null),
          keyboardType: TextInputType.text,
          maxLength: 100,
          controller: _busController,
          focusNode: _businessFocus,
          onSubmitted: (term) {
            _businessFocus.unfocus();
            FocusScope.of(context).requestFocus(_emailFocus);
          },
        ),
        new TextField(
          style: new TextStyle(color: Colors.white),
          decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white,),
              labelText: 'Email',
              errorText:
                  _validateEmail ? 'Email not valid' : null),
          keyboardType: TextInputType.text,
          maxLength: 50,
          controller: _emailController,
          focusNode: _emailFocus,
          onSubmitted: (term) {
            _emailFocus.unfocus();
          },
        ),
        new Row(
          children: <Widget>[
            Text(
              "Status active?",
              style: TextStyle(color: Colors.white,),
            ),
            Checkbox(
              value: bStatus, 
              onChanged: (bool newValue) {
                setState(() {
                  bStatus = newValue;
                  bStatus 
                  ? sStatus = "active": sStatus = "disabled";
                  print(bStatus);
                });
              },
            ),
          ],
        ),
        new TextField(
          style: new TextStyle(color: Colors.white),
          decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white,),
              labelText: 'Latitude',
              errorText: _validateLat
                  ? 'Latitude is not valid'
                  : null),
          keyboardType: TextInputType.emailAddress,
          controller: _latController,
          maxLength: 20,
          focusNode: _latFocus,
          onSubmitted: (term) {
            _latFocus.unfocus();
            FocusScope.of(context).requestFocus(_longFocus);
          },
        ),
        new TextField(
          style: new TextStyle(color: Colors.white),
          decoration: InputDecoration(
              labelStyle: TextStyle(color: Colors.white,),
              labelText: 'Longitude',
              errorText: _validateLong
                  ? 'Longitude is not valid'
                  : null),
          keyboardType: TextInputType.text,
          controller: _longController,
          maxLength: 20,
          focusNode: _longFocus,
          onSubmitted: (term) {
            _longFocus.unfocus();
            FocusScope.of(context).requestFocus(_refFocus);
          },
        ),
        new TextField(
          style: new TextStyle(color: Colors.white),
          decoration: InputDecoration(labelText: 'Reference code',labelStyle: TextStyle(color: Colors.white,),),
          keyboardType: TextInputType.text,
          maxLength: 10,
          focusNode: _refFocus,
          onSubmitted: (term) {
            _longFocus.unfocus();
          },
        ),
        new SizedBox(
          height: 10.0,
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 5.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () {
              setState(() {
                _validateEmail = validateEmail(_emailController.text);
                _validateBus = validateText(_busController.text);
                _validateLat = validateText(_latController.text);
                _validateLong = validateText(_longController.text);
                if(_validateEmail==false && _validateBus==false && _validateLat==false && _validateLong==false) {
                  print('Updating');
                  post();
                }

              });
              
            },
            padding: EdgeInsets.fromLTRB(100, 10, 100, 10),
            color: Colors.redAccent,
            child: Text('Update',
                style: TextStyle(color: Colors.white, fontSize: 25)),
          ),
        ),
      ],
      )
    );
  }

  bool validateText(String value) {
    if (value.length < 2)
      return true;
    else
      return false;
  }


  bool validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (regex.hasMatch(value))
      return false;
    else
      return true;
  }

  void post() async {
    var result = await http.post(
        "http://specials-fest.com/PHP/updateUser.php",
        body: {
          "value": "I am cool!",
          "userid": widget.usercardd.userid,
          "useremail": _emailController.text,
          "status": sStatus,
          "businessname": _busController.text,
          "latitude": _latController.text,
          "longitude": _longController.text,
          "referenceNo": _refController.text,
        }
    );
    print(_emailController.text);
    print(result.body);
    if (result.body == "Failed") {
      _emailController.clear();
      Alert(
        context: context,
        type: AlertType.error,
        title: "ERROR",
        desc: "This email is already registered!",
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
    else if (result.body == "Success"){
      Alert(
        context: context,
        type: AlertType.success,
        title: "Updated!",
        desc: "You have succesfully updated this record!",
        buttons: [
          DialogButton(
            child: Text(
              "Close",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: (){Navigator.pop(context);
            Navigator.pop(context);},
            width: 120,
          )
        ],
      ).show();
    }
  }

}