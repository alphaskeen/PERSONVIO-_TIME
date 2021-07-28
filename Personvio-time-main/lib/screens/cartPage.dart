import 'package:canteen_food_ordering_app/apis/foodAPIs.dart';
import 'package:canteen_food_ordering_app/models/cart.dart';
import 'package:canteen_food_ordering_app/notifiers/authNotifier.dart';
import 'package:canteen_food_ordering_app/widgets/customRaisedButton.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  double sum = 0;
  int itemsCount = 0;
  String extra = '';

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
          backgroundColor: Color.fromRGBO(10, 250, 20, 1),
          title: Text('Cart'),
        ),
        // ignore: unrelated_type_equality_checks
        body: (authNotifier.userDetails.uuid == Null)
            ? Container(
                padding: EdgeInsets.symmetric(vertical: 20),
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text("No Items to display"),
              )
            : cartList(context));
  }

  Widget cartList(context) {
    AuthNotifier authNotifier =
        Provider.of<AuthNotifier>(context, listen: false);
    return SingleChildScrollView(
      physics: ScrollPhysics(),
      child: Column(
        children: <Widget>[
          StreamBuilder<QuerySnapshot>(
            stream: Firestore.instance
                .collection('carts')
                .document(authNotifier.userDetails.uuid)
                .collection('items')
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot1) {
              if (snapshot1.hasData && snapshot1.data.documents.length > 0) {
                List<String> foodIds = new List<String>();
                Map<String, int> count = new Map<String, int>();
                snapshot1.data.documents.forEach((item) {
                  foodIds.add(item.documentID);
                  count[item.documentID] = item.data['count'];
                });
                return dataDisplay(
                    context, authNotifier.userDetails.uuid, foodIds, count);
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

  Widget dataDisplay(BuildContext context, String uid, List<String> foodIds,
      Map<String, int> count) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance
          .collection('items')
          .where(FieldPath.documentId, whereIn: foodIds)
          .snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData && snapshot.data.documents.length > 0) {
          List<Cart> _cartItems = new List<Cart>();
          snapshot.data.documents.forEach((item) {
            _cartItems.add(Cart(
                item.documentID,
                count[item.documentID],
                item.data['item_name'],
                item.data['total_qty'],
                item.data['price']));
          });
          if (_cartItems.length > 0) {
            sum = 0;
            itemsCount = 0;
            extra = '';
            _cartItems.forEach((element) {
              if (element.price != null && element.count != null) {
                sum += element.price * element.count;
                itemsCount += element.count;
              }
            });
            return Container(
                margin: EdgeInsets.only(top: 10.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    // User Name Field
                    Container(
                      margin: EdgeInsets.symmetric(horizontal: 40),
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
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
                          extra = value;
                        },
                        cursorColor: Color.fromRGBO(255, 63, 111, 1),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Mention extra ingredients/equipment',
                          hintStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromRGBO(50, 50, 50, 0.5),
                            fontSize: 13,
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
                    ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _cartItems.length,
                        itemBuilder: (context, int i) {
                          return ListTile(
                            title: Text(_cartItems[i].itemName ?? ''),
                            subtitle:
                                Text('cost: ${_cartItems[i].price.toString()}'),
                            trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  (_cartItems[i].count == null ||
                                          _cartItems[i].count <= 1)
                                      ? IconButton(
                                          onPressed: () async {
                                            setState(() {
                                              foodIds
                                                  .remove(_cartItems[i].itemId);
                                            });
                                            await editCartItem(
                                                _cartItems[i].itemId,
                                                0,
                                                context);
                                          },
                                          icon: new Icon(Icons.delete),
                                        )
                                      : IconButton(
                                          onPressed: () async {
                                            await editCartItem(
                                                _cartItems[i].itemId,
                                                (_cartItems[i].count - 1),
                                                context);
                                          },
                                          icon: new Icon(Icons.remove),
                                        ),
                                  Text(
                                    '${_cartItems[i].count ?? 0}',
                                    style: TextStyle(fontSize: 18.0),
                                  ),
                                  IconButton(
                                    icon: new Icon(Icons.add),
                                    onPressed: () async {
                                      await editCartItem(_cartItems[i].itemId,
                                          (_cartItems[i].count + 1), context);
                                    },
                                  )
                                ]),
                          );
                        }),
                    Text("Total ($itemsCount items): $sum INR"),
                    SizedBox(
                      height: 40,
                    ),
                    GestureDetector(
                      onTap: () {
                        showAlertDialog(
                          context,
                          "Total ($itemsCount items): $sum INR",
                        );
                      },
                      child: CustomRaisedButton(buttonText: 'Proceed to buy'),
                    ),
                    SizedBox(
                      height: 70,
                    ),
                  ],
                ));
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
    );
  }

  showAlertDialog(BuildContext context, String data) {
    // set up the buttons
    Widget cancelButton = FlatButton(
      child: Text("Cancel"),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = FlatButton(
      child: Text("Place Order"),
      onPressed: () {
        placeOrder(context, sum, extra);
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Proceed to checkout?"),
      content: Text(data),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
