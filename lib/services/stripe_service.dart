// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:fluttertoast/fluttertoast.dart';

class StripePaymentHandle {
  static String PUBLISHABLE_KEY =
      'pk_test_51OuVimP89vVYGJSgiHDxHEhq8Zusa79GhHtCOsENCGr7y6b9MYm5ScDdYt7LmEWX0z9iwLdK0hntxUJa2K0vFqXj0088HDboA5';
  static String STRIPE_SECRET =
      'sk_test_51OuVimP89vVYGJSgHhyQoY43dZvVWWBe1F90ChDn3SL3Lnf6UmKconyGKrig1LcX1J1yGCRVZMqRnYtz9NO6HU6n00bQ9d8Oql';
  static Map<String, dynamic>? paymentIntent;

  static Future<void> stripeMakePayment() async {
    try {
      paymentIntent = await createPaymentIntent('100', 'INR');
      await Stripe.instance
          .initPaymentSheet(
              paymentSheetParameters: SetupPaymentSheetParameters(
                  allowsDelayedPaymentMethods: true,
                  customFlow: true,
                  billingDetails: const BillingDetails(
                      name: 'Name',
                      email: 'YOUREMAIL@gmail.com',
                      phone: 'YOUR NUMBER',
                      address: Address(
                          city: 'YOUR CITY',
                          country: 'YOUR COUNTRY',
                          line1: 'YOUR ADDRESS 1',
                          line2: 'YOUR ADDRESS 2',
                          postalCode: 'YOUR PINCODE',
                          state: 'YOUR STATE')),
                  googlePay: const PaymentSheetGooglePay(
                      amount: '100',
                      //Currency and country code is according to India
                      testEnv: true,
                      currencyCode: "INR",
                      merchantCountryCode: "IN"),
                  paymentIntentClientSecret: paymentIntent!['client_secret'],
                  merchantDisplayName: 'Ikay'))
          .then((value) {});

      //STEP 3: Display Payment Sheet
      displayPaymentSheet();
    } catch (e) {
      log('Error $e');
      print(e.toString());
      Fluttertoast.showToast(msg: e.toString());
    }
  }

  static displayPaymentSheet() async {
    try {
      // 3.display the payment sheet.
      final result = await Stripe.instance.presentPaymentSheet();
    } catch (e) {
      print('Error:$e');
      if (e is StripeException) {
        Fluttertoast.showToast(msg: 'Payment Failed');
      } else {
        Fluttertoast.showToast(msg: 'Unforeseen error: $e');
      }
    }
  }

//create Payment
  static createPaymentIntent(String amount, String currency) async {
    var dio = Dio();
    try {
      //Request body
      Map<String, dynamic> data = {
        'amount': calculateAmount(amount),
        'currency': currency,
      };
      //Make post request to Stripe
      var response = await dio.post(
        'https://api.stripe.com/v1/payment_intents',
        options: Options(
          headers: {
            'Authorization': 'Bearer $STRIPE_SECRET',
            'Content-Type': 'application/x-www-form-urlencoded'
          },
        ),
        data: data,
      );
      return response.data;
    } catch (err) {
      throw Exception(err.toString());
    }
  }

//calculate Amount
  static calculateAmount(String amount) {
    final calculatedAmount = (int.parse(amount)) * 100;
    return calculatedAmount.toString();
  }
}
