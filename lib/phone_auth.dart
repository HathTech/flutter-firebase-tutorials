import 'package:firebase_tutorials/otp_screen.dart';
import 'package:flutter/material.dart';

class PhoneLogin extends StatefulWidget {
  PhoneLogin({Key key}) : super(key: key);

  @override
  _PhoneLoginState createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  final TextEditingController _phoneNumberController = TextEditingController();

  bool isValid = false;

  Future<Null> validate(StateSetter updateState) async {
    print("in validate : ${_phoneNumberController.text.length}");
    if (_phoneNumberController.text.length == 10) {
      updateState(() {
        isValid = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      padding: EdgeInsets.only(left: 8.0, top: 30),
      alignment: Alignment.center,
      child: new RaisedButton(
        shape: new RoundedRectangleBorder(
          borderRadius: new BorderRadius.circular(30.0),
        ),
        color: Colors.green,
        onPressed: () => {},
        child: new Container(
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Expanded(
                child: new FlatButton(
                  onPressed: () {
                    print("pressed");
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        builder: (BuildContext bc) {
                          print("VALID CC: $isValid");

                          return StatefulBuilder(builder:
                              (BuildContext context, StateSetter state) {
                            return Container(
                              padding: EdgeInsets.all(16),
                              height: MediaQuery.of(context).size.height * 0.7,
                              child: new Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    'LOGIN',
                                    style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black),
                                  ),
                                  Text(
                                    'Login/Create Account quickly to manage orders',
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.normal,
                                        color: Colors.black),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: _phoneNumberController,
                                      autofocus: true,
                                      onChanged: (text) {
                                        validate(state);
                                      },
                                      decoration: InputDecoration(
                                        labelText: "10 digit mobile number",
                                        prefix: Container(
                                          padding: EdgeInsets.all(4.0),
                                          child: Text(
                                            "+91",
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      autovalidate: true,
                                      autocorrect: false,
                                      maxLengthEnforced: true,
                                      validator: (value) {
                                        return !isValid
                                            ? 'Please provide a valid 10 digit phone number'
                                            : null;
                                      },
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.all(16),
                                    child: Center(
                                      child: SizedBox(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.85,
                                        child: RaisedButton(
                                          color: !isValid
                                              ? Theme.of(context)
                                                  .primaryColor
                                                  .withOpacity(0.5)
                                              : Theme.of(context).primaryColor,
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(0.0)),
                                          child: Text(
                                            !isValid
                                                ? "ENTER PHONE NUMBER"
                                                : "CONTINUE",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 18.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          onPressed: () {
                                            if (isValid) {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        OTPScreen(
                                                      mobileNumber:
                                                          _phoneNumberController
                                                              .text,
                                                    ),
                                                  ));
                                            } else {
                                              validate(state);
                                            }
                                          },
                                          padding: EdgeInsets.all(16.0),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          });
                        });
                  },
                  padding: EdgeInsets.only(
                    top: 20.0,
                    bottom: 20.0,
                  ),
                  child: new Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        "Phone",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
