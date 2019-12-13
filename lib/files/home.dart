import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'cardd.dart';
import 'card_details.dart';


class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
    new GlobalKey<RefreshIndicatorState>();

  List<UserCard> data = new List<UserCard>();
  List<UserCard> dataDisplay= new List<UserCard>();

  bool isLoading = false;
  bool bStore = false;

  Future<List<UserCard>> getData() async{
    setState(() {
      isLoading = true;
    });
      if (bStore == false) {
        var url = 'http://specials-fest.com/PHP/getUsers.php';
        final response =
            await http.get(url);
        var users = List<UserCard>();
        if (response.statusCode == 200) {
          var usersJson = json.decode(response.body);
          for (var noteJson in usersJson) {
            users.add(UserCard.fromJson(noteJson));
          }
          setState(() {
            isLoading = false;
          });
          bStore =true;
          print("I did it");
        } else {
          bStore =false;
          throw Exception('Failed to load data');
        }
        return users;
        
      }
  }

  @override
  void initState() {
    super.initState();
    getData().then((value) {
      setState(() {
        data.addAll(value);
        dataDisplay = data;
      });
    });
    getData();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(51, 120, 180, 1),
          title: Center(child:Text("Specials Fest")),
          elevation: 0.0,
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          onRefresh: pullRefresh,
          child: isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ListView.builder(
                itemCount: dataDisplay.length+1,
                itemBuilder: (BuildContext context, int index) {
                  return index == 0 ? _searchBar() : _listItem(index-1);
                })),);
      
  }

   _searchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        style: new TextStyle(color: Colors.white),
        decoration: InputDecoration(
          hintText: 'Search...',
          hintStyle: TextStyle(color: Colors.white),
        ),
        onChanged: (text) {
          text = text.toLowerCase();
          setState(() {
            dataDisplay = data.where((user) {
              var userSearch = user.businessname.toLowerCase();
              return userSearch.contains(text);
            }).toList();
          });
        },
      ),
    );
  }

  _listItem(index) {
    return new GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowDetails(usercardd: dataDisplay[index]),
          ));},
      child: new Card(
        elevation: 8.0,
        margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
        child: Container(
          decoration: BoxDecoration(color: Color.fromRGBO(64, 75, 96, .9)),
          child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        title: Text(
          dataDisplay[index].businessname,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),

        subtitle: Row(
          children: <Widget>[
            Text(dataDisplay[index].useremail, style: TextStyle(color: Colors.white))
          ],
        ),
        trailing:
            Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 25.0))
          ),
      )
    );
  }


   Future<Null> pullRefresh() async {
    setState(() {
      data.clear();
      dataDisplay.clear();
      bStore = false;
      getData().then((value) {
      setState(() {
        data.addAll(value);
        dataDisplay = data;
      });
    });
    });
    await Future.delayed(Duration(seconds: 1));
    return null;
  }

}

