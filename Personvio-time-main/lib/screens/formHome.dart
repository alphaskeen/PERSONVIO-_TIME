import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:canteen_food_ordering_app/models/formm.dart';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FormPage extends StatefulWidget {
  @override
  _FormPageState createState() => _FormPageState();
}

class _FormPageState extends State<FormPage> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final TextEditingController _passwordController = new TextEditingController();

  Formm _formm = new Formm();
  bool isSignedIn = false, showPassword = true, showConfirmPassword = true;

  var S;
  var T;
  var U;

  @override
  void initState() {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    initializeCurrentUser(authNotifier, context);
    super.initState();
  }

  void toast(String data) {
    Fluttertoast.showToast(
        msg: data,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey,
        textColor: Colors.white);
  }

  void _submitForm() {
    if (!_formkey.currentState.validate()) {
      return;
    }
    _formkey.currentState.save();
    RegExp regExp = new RegExp(
        r'^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$');
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    if (_formm.no.length < 1) {
      toast("Number of people must be greater than 0");
    } else if (_formm.date.length != 8) {
      toast("date length must be in ddmmyyyy format");
    } else if (_formm.time.length != 5) {
      toast("Enter time in this format -> hh:mm");
    } else {
      print("Success");
      submitformm(_formm, authNotifier, context);
    }
  }

  Widget _buildSignUPForm() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 60,
        ),
        // User Name Field
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.black,
              )),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (String value) {
              return null;
            },
            onSaved: (String value) {
              _formm.no = value;
            },
            cursorColor: Color.fromRGBO(255, 63, 111, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'No of People',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(50, 50, 50, 0.5),
              ),
              icon: Icon(
                Icons.supervised_user_circle,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        // Email Field
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.black,
              )),
          child: TextFormField(
            validator: (String value) {
              return null;
            },
            onSaved: (String value) {
              _formm.date = value;
            },
            keyboardType: TextInputType.emailAddress,
            cursorColor: Color.fromRGBO(255, 63, 111, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'date (DDMMYYYY)',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(50, 50, 50, 0.5),
              ),
              icon: Icon(
                Icons.calendar_today_rounded,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 20,
        ),
        //Phone Number Field
        Container(
          margin: EdgeInsets.symmetric(horizontal: 40),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(40),
              border: Border.all(
                color: Colors.black,
              )),
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            validator: (String value) {
              return null;
            },
            onSaved: (String value) {
              _formm.time = value;
            },
            cursorColor: Color.fromRGBO(255, 63, 111, 1),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'time (Ex- 6pm as 18:00)',
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                color: Color.fromRGBO(50, 50, 50, 0.5),
              ),
              icon: Icon(
                Icons.timer_rounded,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
            ),
          ),
        ),

        SizedBox(
          height: 25,
        ),
        // Sign Up Button

        Divider(
          color: Colors.black,
          height: 20,
          thickness: 2,
          indent: 10,
          endIndent: 10,
        ),

        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: <Widget>[
              Text(
                "Select your Preference",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'MuseoModerno',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 7,
              ),
              RadioListTile(
                groupValue: S,
                title: Text('veg'),
                value: 'veg',
                onChanged: (val) {
                  setState(() {
                    _formm.preference = val;
                    S = val;
                  });
                },
              ),
              RadioListTile(
                groupValue: S,
                title: Text('non-veg'),
                value: 'non-veg',
                onChanged: (val) {
                  setState(() {
                    _formm.preference = val;
                    S = val;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 15,
        ),
        Divider(
          color: Colors.black,
          height: 20,
          thickness: 2,
          indent: 10,
          endIndent: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: <Widget>[
              Text(
                "Select your meal",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'MuseoModerno',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 7,
              ),
              RadioListTile(
                groupValue: T,
                title: Text('Breakfast'),
                value: 'Breakfast',
                onChanged: (val) {
                  setState(() {
                    _formm.meals = val;
                    T = val;
                  });
                },
              ),
              RadioListTile(
                groupValue: T,
                title: Text('Brunch'),
                value: 'Brunch',
                onChanged: (val) {
                  setState(() {
                    _formm.meals = val;
                    T = val;
                  });
                },
              ),
              RadioListTile(
                groupValue: T,
                title: Text('Lunch'),
                value: 'Lunch',
                onChanged: (val) {
                  setState(() {
                    _formm.meals = val;
                    T = val;
                  });
                },
              ),
              RadioListTile(
                groupValue: T,
                title: Text('Dinner'),
                value: 'Dinner',
                onChanged: (val) {
                  setState(() {
                    _formm.meals = val;
                    T = val;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Divider(
          color: Colors.black,
          height: 20,
          thickness: 2,
          indent: 10,
          endIndent: 10,
        ),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 30),
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(
            children: <Widget>[
              Text(
                "Select your course",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'MuseoModerno',
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 7,
              ),
              RadioListTile(
                groupValue: U,
                title: Text('2-course meal'),
                value: '2-course meal',
                onChanged: (val) {
                  setState(() {
                    _formm.preference = val;
                    U = val;
                  });
                },
              ),
              RadioListTile(
                groupValue: U,
                title: Text('3-course meal'),
                value: '3-course meal',
                onChanged: (val) {
                  setState(() {
                    _formm.preference = val;
                    U = val;
                  });
                },
              ),
            ],
          ),
        ),
        SizedBox(
          height: 20,
        ),
        GestureDetector(
          onTap: () {
            _submitForm();
          },
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: Colors.black,
                )),
            child: Text(
              "Proceed",
              style: TextStyle(
                fontSize: 20,
                color: Color.fromRGBO(255, 63, 111, 1),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 60,
        ),
        // Login Line
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Personvio Time',
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        backgroundColor: Color.fromRGBO(10, 250, 20, 1),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 255, 255, 1),
              Color.fromRGBO(255, 255, 255, 1),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Form(
          key: _formkey,
          autovalidate: true,
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  '',
                  style: TextStyle(
                    fontStyle: FontStyle.italic,
                    fontSize: 17,
                    color: Color.fromRGBO(252, 188, 126, 1),
                  ),
                ),
                _buildSignUPForm()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
