import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:canteen_food_ordering_app/widgets/customRaisedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:canteen_food_ordering_app/models/food.dart';
import 'package:provider/provider.dart';

import '../models/chef.dart';

class ChefHomePage extends StatefulWidget {
  @override
  _ChefHomePageState createState() => _ChefHomePageState();
}

class _ChefHomePageState extends State<ChefHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyEdit = GlobalKey<FormState>();
  List<Chef> _chefItems = new List<Chef>();
  String name = '';

  signOutUser() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (authNotifier.user != null) {
      signOut(authNotifier, context);
    }
  }

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    getUserDetails(authNotifier);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('Personvio Time')),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.exit_to_app,
              color: Colors.white,
            ),
            onPressed: () {
              signOutUser();
            },
          )
        ],
        backgroundColor: Color.fromRGBO(10, 250, 20, 1),
      ),
      // ignore: unrelated_type_equality_checks
      body: (authNotifier.userDetails == null)
          ? Container(
              padding: EdgeInsets.symmetric(vertical: 20),
              width: MediaQuery.of(context).size.width * 0.6,
              child: Text("No Items to display"),
            )
          : (authNotifier.userDetails.role == 'user')
              ? chefHome(context)
              : Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text("No Items to display"),
                ),
    );
  }

  Widget chefHome(context) {
    // AuthNotifier authNotifier = Provider.of<AuthNotifier>(context, listen: false);
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          Card(
            child: TextField(
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.search), hintText: 'Search...'),
              onChanged: (val) {
                setState(() {
                  name = val;
                });
              },
            ),
          ),
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance.collection('chefs').snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData && snapshot.data.documents.length > 0) {
                _chefItems = new List<Chef>();
                snapshot.data.documents.forEach((item) {
                  _chefItems.add(
                    Chef(item.documentID, item['chefName'], item['age'],
                        item['rating'], item['experience'], item['speciality']),
                  );
                });
                List<Chef> _suggestionList = (name == '' || name == null)
                    ? _chefItems
                    : _chefItems
                        .where((element) => element.chefName
                            .toLowerCase()
                            .contains(name.toLowerCase()))
                        .toList();
                if (_suggestionList.length > 0) {
                  return Container(
                    margin: EdgeInsets.only(top: 10.0),
                    child: ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _suggestionList.length,
                        itemBuilder: (context, int i) {
                          return ListTile(
                            title: Text(_suggestionList[i].chefName ?? ''),
                            subtitle: Text(
                                'age: ${_suggestionList[i].age}  |  experience: ${_suggestionList[i].experience}'),
                            trailing:
                                Text('rating: ${_suggestionList[i].rating}'),
                            isThreeLine: true,
                            onTap: () {
                              print('success');
                              insertedchefpage(context);
                            },
                          );
                        }),
                  );
                } else {
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text("No Items to display"),
                  );
                }
              } else {
                return Container(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text("No Items to display"),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
