import 'package:flutter/material.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:pardna/.env.dart';
import 'package:flutter/services.dart';
import 'package:pardna/screens/login.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  Stripe.publishableKey = stripePublishableKey;
  Stripe.merchantIdentifier = 'merchant.flutter.stripe.test';
  Stripe.urlScheme = 'flutterstripe';
  await Stripe.instance.applySettings();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(const MyApp());
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: exampleAppTheme,
      debugShowCheckedModeBanner: false,
      home: const Login(),
    );
  }
}

final exampleAppTheme = ThemeData(
  colorScheme: const ColorScheme.light(
    primary: Colors.green,
    secondary: Colors.green,
  ),
  primaryColor: Colors.white,
  useMaterial3: false,
  appBarTheme: const AppBarTheme(elevation: 1),
);
