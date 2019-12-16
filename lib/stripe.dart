import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/material.dart';
import 'package:stripe_payment/stripe_payment.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StripePaymentMethod extends StatefulWidget {
  final double amount;

  StripePaymentMethod({Key key, @required this.amount}) : super(key: key);

  @override
  _StripePaymentMethodState createState() => _StripePaymentMethodState();
}

class _StripePaymentMethodState extends State<StripePaymentMethod> {
  @override
  initState() {
    super.initState();

    StripePayment.setOptions(StripeOptions(
        publishableKey: "pk_test_BPshyoidS9yNHQ95JbPq1ozJ00ovD2VZcR",
        merchantId: "Test",
        androidPayMode: "test"));

    Future.delayed(Duration.zero, () {
      StripePayment.paymentRequestWithCardForm(CardFormPaymentRequest(
        requiredBillingAddressFields: "",
      )).then((paymentMethod) async {
        print(paymentMethod.id);

        final HttpsCallable callable = CloudFunctions.instance.getHttpsCallable(
          functionName: 'createStripeCharge',
        );

        try {
          final HttpsCallableResult resp =
              await callable.call(<String, dynamic>{'fees': 900});

          print("RESP DATA ${resp.data}");
          StripePayment.confirmPaymentIntent(PaymentIntent(
            clientSecret: resp.data['client_secret'],
            paymentMethodId: paymentMethod.id,
          )).then((data) {
            print("Status ${data.status}");
          }).catchError(setError);
        } catch (e) {
          print(e.message);

          setError(e);
        }
      }).catchError(setError);
    });
  }

  void setError(dynamic error) {
    print("SWR $error");
    Fluttertoast.showToast(
        msg: "${error.message.toString()}",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 2,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: Theme.of(context).colorScheme.background,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0.0,
      ),
      body: Container(
          child: Center(
        child: CircularProgressIndicator(),
      )),
    );
  }
}
