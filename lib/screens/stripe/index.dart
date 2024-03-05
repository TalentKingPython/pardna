import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:http/http.dart' as http;
import 'package:pardna/screens/home.dart';
import 'package:pardna/utils/loading_button.dart';
import 'package:pardna/utils/globals.dart';
import 'package:pardna/utils/network.dart';

class StripeService extends StatefulWidget {
  const StripeService({super.key});

  @override
  State<StripeService> createState() => _StripeServiceState();
}

class _StripeServiceState extends State<StripeService> {
  int step = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Verification'),
      ),
      body: Stepper(
        controlsBuilder: emptyControlBuilder,
        currentStep: step,
        steps: [
          Step(
            title: const Text('Init payment'),
            content: LoadingButton(
              onPressed: initPaymentSheet,
              text: 'Init payment sheet',
            ),
          ),
          Step(
            title: const Text('Verify payment method'),
            content: LoadingButton(
              onPressed: confirmPayment,
              text: 'Verify',
            ),
          ),
          Step(
            title: const Text('Complete verification!'),
            content: Column(
              children: [
                const Icon(
                  Icons.check_circle,
                  color: Colors.green,
                  size: 100,
                ),
                LoadingButton(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const HomePage(),
                    ),
                  ),
                  text: 'OK',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _createPaymentIntent(paymentMethodId) async {
    final response = await http.post(
      Uri.parse('$baseURL/stripe/create-payment-intent'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'customerId': userInfo['stripe_customer_token'],
        'paymentMethodId': paymentMethodId,
      }),
    );

    final body = json.decode(response.body);
    if (body['error'] != null) {
      throw Exception(body['error']);
    }

    await Stripe.instance.intentCreationCallback(
        IntentCreationCallbackParams(clientSecret: body['clientSecret']));
  }

  Future<void> initPaymentSheet() async {
    try {
      // create some billingdetails
      final billingDetails = BillingDetails(
        name: userInfo['name'],
        email: userInfo['email'],
        phone: userInfo['phone'] ?? '',
      );

      // 2. initialize the payment sheet
      await Stripe.instance.initPaymentSheet(
        paymentSheetParameters: SetupPaymentSheetParameters(
          intentConfiguration: IntentConfiguration(
              mode: const IntentMode(
                currencyCode: 'USD',
                amount: 1500,
              ),
              confirmHandler: (method, saveFuture) {
                _createPaymentIntent(method.id);
              }),
          // Main params
          customerId: userInfo['stripe_customer_token'],
          merchantDisplayName: 'Pardna Stripe',
          // Extra params
          primaryButtonLabel: 'Verify',
          applePay: const PaymentSheetApplePay(
            merchantCountryCode: 'US',
          ),
          googlePay: const PaymentSheetGooglePay(
            merchantCountryCode: 'US',
            testEnv: true,
          ),

          appearance: const PaymentSheetAppearance(
            colors: PaymentSheetAppearanceColors(
              background: Colors.white,
              primary: Colors.white,
              componentBorder: Colors.green,
            ),
            shapes: PaymentSheetShape(
              borderWidth: 4,
              shadow: PaymentSheetShadowParams(color: Colors.grey),
            ),
            primaryButton: PaymentSheetPrimaryButtonAppearance(
              shapes: PaymentSheetPrimaryButtonShape(blurRadius: 8),
              colors: PaymentSheetPrimaryButtonTheme(
                light: PaymentSheetPrimaryButtonThemeColors(
                  background: Colors.green,
                  text: Colors.white,
                  border: Colors.green,
                ),
              ),
            ),
          ),
          billingDetails: billingDetails,
        ),
      );
      setState(() {
        step = 1;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
      rethrow;
    }
  }

  Future<void> confirmPayment() async {
    try {
      await Stripe.instance.presentPaymentSheet();

      setState(() {
        step = 2;
      });

      final response = await AuthService.getProfile();
      if (response.statusCode == 200) {
        print(jsonDecode(response.body));
        setState(() {
          userInfo = jsonDecode(response.body);
        });
      } else {
        print(response.statusCode);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Payment succesfully completed'),
        ),
      );
    } on Exception catch (e) {
      if (e is StripeException) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error from Stripe: ${e.error.localizedMessage}'),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Unforeseen error: $e'),
          ),
        );
      }
    }
  }
}

final ControlsWidgetBuilder emptyControlBuilder = (_, __) => Container();
