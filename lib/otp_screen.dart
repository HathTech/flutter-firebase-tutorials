import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_tutorials/home.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import './otp_input.dart';

class OTPScreen extends StatefulWidget {
  final String mobileNumber;
  OTPScreen({
    Key key,
    @required this.mobileNumber,
  })  : assert(mobileNumber != null),
        super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Control the input text field.
  TextEditingController _pinEditingController = TextEditingController();

  /// Decorate the outside of the Pin.
  PinDecoration _pinDecoration =
      UnderlineDecoration(enteredColor: Colors.black, hintText: '333333');

  bool isCodeSent = false;
  String _verificationId;

  @override
  void initState() {
    super.initState();
    _onVerifyCode();
  }

  @override
  Widget build(BuildContext context) {
    print("isValid - $isCodeSent");
    print("mobiel ${widget.mobileNumber}");
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        bottom: PreferredSize(
          child: Container(
            padding: EdgeInsets.only(left: 16.0, bottom: 16, top: 4),
            color: Colors.white,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Verify Details",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Text(
                      "OTP sent to ${widget.mobileNumber}",
                      style: TextStyle(
                          fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ],
            ),
          ),
          preferredSize: Size.fromHeight(100),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: PinInputTextField(
                pinLength: 6,
                decoration: _pinDecoration,
                controller: _pinEditingController,
                autoFocus: true,
                textInputAction: TextInputAction.done,
                onSubmit: (pin) {
                  if (pin.length == 6) {
                    _onFormSubmitted();
                  } else {
                    showToast("Invalid OTP", Colors.red);
                  }
                },
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(0.0)),
                    child: Text(
                      "ENTER OTP",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      if (_pinEditingController.text.length == 6) {
                        _onFormSubmitted();
                      } else {
                        showToast("Invalid OTP", Colors.red);
                      }
                    },
                    padding: EdgeInsets.all(16.0),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showToast(message, Color color) {
    print(message);
    Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: color,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  void _onVerifyCode() async {
    setState(() {
      isCodeSent = true;
    });
    final PhoneVerificationCompleted verificationCompleted =
        (AuthCredential phoneAuthCredential) {
      _firebaseAuth
          .signInWithCredential(phoneAuthCredential)
          .then((AuthResult value) {
        if (value.user != null) {
          // Handle loogged in state
          print(value.user.phoneNumber);
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  user: value.user,
                ),
              ),
              (Route<dynamic> route) => false);
        } else {
          showToast("Error validating OTP, try again", Colors.red);
        }
      }).catchError((error) {
        showToast("Try again in sometime", Colors.red);
      });
    };
    final PhoneVerificationFailed verificationFailed =
        (AuthException authException) {
      showToast(authException.message, Colors.red);
      setState(() {
        isCodeSent = false;
      });
    };

    final PhoneCodeSent codeSent =
        (String verificationId, [int forceResendingToken]) async {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };
    final PhoneCodeAutoRetrievalTimeout codeAutoRetrievalTimeout =
        (String verificationId) {
      _verificationId = verificationId;
      setState(() {
        _verificationId = verificationId;
      });
    };

    // TODO: Change country code

    await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: "+91${widget.mobileNumber}",
        timeout: const Duration(seconds: 60),
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout);
  }

  void _onFormSubmitted() async {
    AuthCredential _authCredential = PhoneAuthProvider.getCredential(
        verificationId: _verificationId, smsCode: _pinEditingController.text);

    _firebaseAuth
        .signInWithCredential(_authCredential)
        .then((AuthResult value) {
      if (value.user != null) {
        // Handle loogged in state
        print(value.user.phoneNumber);
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => HomePage(
                user: value.user,
              ),
            ),
            (Route<dynamic> route) => false);
      } else {
        showToast("Error validating OTP, try again", Colors.red);
      }
    }).catchError((error) {
      showToast("Something went wrong", Colors.red);
    });
  }
}
