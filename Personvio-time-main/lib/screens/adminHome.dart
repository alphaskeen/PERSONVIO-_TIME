import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:flutter/material.dart';
import 'package:canteen_food_ordering_app/models/food.dart';
import 'package:provider/provider.dart';

class AdminHomePage extends StatefulWidget {
  @override
  _AdminHomePageState createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeyEdit = GlobalKey<FormState>();
  List<Food> _foodItems = new List<Food>();
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
        backgroundColor: Color.fromRGBO(255, 255, 255, 1),
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
            ? Center(
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 100,
                    ),
                    Image(
                      image: NetworkImage(
                          'https://mir-s3-cdn-cf.behance.net/project_modules/disp/0845c232253239.56766f2d063c9.gif'),
                      height: 400,
                      width: 400,
                    ),
                    Container(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: Text(
                            "Thanks for registration. Our team will get in contact with you soon...",
                            style: TextStyle(
                              fontStyle: FontStyle.italic,
                              fontSize: 20,
                              color: Color.fromRGBO(0, 0, 0, 1),
                            ))),
                  ],
                ),
              )
            : (authNotifier.userDetails.role == 'chef')
                ? Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                        ),
                        Image(
                          image: NetworkImage(
                              'https://mir-s3-cdn-cf.behance.net/project_modules/disp/0845c232253239.56766f2d063c9.gif'),
                          height: 400,
                          width: 400,
                        ),
                        Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            width: MediaQuery.of(context).size.width * 0.8,
                            child: Text(
                                "Thanks for registration. Our team will get in contact with you soon...",
                                style: TextStyle(
                                  fontStyle: FontStyle.italic,
                                  fontSize: 20,
                                  color: Color.fromRGBO(0, 0, 0, 1),
                                ))),
                      ],
                    ),
                  )
                : Center(
                    child: Column(
                      children: <Widget>[
                        SizedBox(
                          height: 100,
                        ),
                        Image(
                          image: NetworkImage(
                              'https://mir-s3-cdn-cf.behance.net/project_modules/disp/0845c232253239.56766f2d063c9.gif'),
                          height: 400,
                          width: 400,
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          width: MediaQuery.of(context).size.width * 0.8,
                          child: Text(
                              "Thanks for registration. Our team will get in contact with you soon...",
                              style: TextStyle(
                                fontStyle: FontStyle.italic,
                                fontSize: 20,
                                color: Color.fromRGBO(0, 0, 0, 1),
                              )),
                        )
                      ],
                    ),
                  ));
  }
}
