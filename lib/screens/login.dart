import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pardna/screens/home.dart';
import 'package:pardna/screens/register.dart';
import 'package:pardna/utils/network.dart';
import 'package:pardna/utils/globals.dart';
import 'package:pardna/utils/text_utils.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  bool showPassword = true;
  bool saveCredential = false;

  Future<Response> _signinWithEmail() async {
    final response = await AuthService.loginWithEmail(
      _emailController.text,
      _passwordController.text,
    );

    return response;
  }

  @override
  void initState() {
    super.initState();
    _prefs.then((SharedPreferences prefs) {
      setState(() {
        saveCredential = prefs.getBool('saveCredential') ?? false;
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
      });

      bool showPolicy = prefs.getBool('showPolicy') ?? true;
      print(showPolicy);
      if (showPolicy) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return const PolicyDialog();
            },
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/background.jpg"), fit: BoxFit.fill),
        ),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.only(top: 40),
                child: const TextUtil(
                  text: "Log in",
                  size: 40,
                ),
              ),
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(vertical: 0),
                child: const TextUtil(
                  text: "Access account",
                  size: 13,
                  color: Color.fromARGB(255, 121, 255, 139),
                ),
              ),
              Container(
                height: 400,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaY: 5, sigmaX: 5),
                    child: Padding(
                      padding: const EdgeInsets.all(25),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                              child: TextUtil(
                            text: "Login with one of the following options",
                            color: Colors.green,
                            weight: true,
                            size: 10,
                          )),
                          const Spacer(),
                          const TextUtil(
                            text: "Email",
                            size: 10,
                            color: Colors.green,
                          ),
                          Container(
                            height: 35,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.green),
                              ),
                            ),
                            child: TextFormField(
                              controller: _emailController,
                              style: const TextStyle(color: Colors.black),
                              decoration: const InputDecoration(
                                suffixIcon: Icon(
                                  Icons.mail,
                                  color: Colors.green,
                                ),
                                fillColor: Colors.green,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Spacer(),
                          const TextUtil(
                            text: "Password",
                            size: 10,
                            color: Colors.green,
                          ),
                          Container(
                            height: 35,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: Colors.green),
                              ),
                            ),
                            child: TextFormField(
                              controller: _passwordController,
                              obscureText: showPassword,
                              style: const TextStyle(color: Colors.black),
                              decoration: InputDecoration(
                                suffixIcon: IconButton(
                                  onPressed: () {
                                    setState(() {
                                      showPassword = !showPassword;
                                    });
                                  },
                                  icon: Icon(
                                    showPassword
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: Colors.green,
                                  ),
                                ),
                                fillColor: Colors.green,
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const TextUtil(
                                text: "Forgot password?",
                                size: 13,
                                weight: true,
                                color: Colors.black,
                              ),
                              const Spacer(),
                              Checkbox(
                                value: saveCredential,
                                onChanged: (bool? value) {
                                  setState(() {
                                    saveCredential = value ?? false;
                                  });
                                },
                              ),
                              const TextUtil(
                                text: "Save Password",
                                size: 12,
                                color: Colors.black,
                              ),
                            ],
                          ),
                          const Spacer(),
                          TextButton(
                            child: Container(
                              height: 40,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius: BorderRadius.circular(30),
                              ),
                              alignment: Alignment.center,
                              child: const TextUtil(
                                text: "Log In",
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () async {
                              final response = await _signinWithEmail();
                              if (response.statusCode == 200) {
                                if (saveCredential) {
                                  final SharedPreferences prefs = await _prefs;
                                  await prefs.setBool(
                                      'saveCredential', saveCredential);
                                  await prefs.setString(
                                      'email', _emailController.text);
                                  await prefs.setString(
                                      'password', _passwordController.text);
                                }
                                if (!context.mounted) return;
                                setState(() {
                                  authToken =
                                      jsonDecode(response.body)['authToken'];
                                  userInfo = jsonDecode(response.body);
                                });
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const HomePage(),
                                  ),
                                );
                              } else {
                                print(response.statusCode);
                                final snackBar = SnackBar(
                                  content: Text(
                                    jsonDecode(response.body)['message'],
                                  ),
                                );
                                if (!context.mounted) return;
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            },
                          ),
                          const Spacer(),
                          Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const TextUtil(
                                  text: "Don't have an account? ",
                                  color: Colors.black,
                                  size: 13,
                                  weight: true,
                                ),
                                TextUtil(
                                  text: "Register",
                                  color: Colors.green,
                                  size: 13,
                                  weight: true,
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const Register(),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
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

class PolicyDialog extends StatefulWidget {
  const PolicyDialog({super.key});
  @override
  State<PolicyDialog> createState() => _PolicyDialogState();
}

class _PolicyDialogState extends State<PolicyDialog> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  bool showPolicy = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Policy Terms'),
      content: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '1. data',
              softWrap: true,
            ),
            Text(
              '2. data',
              softWrap: true,
            ),
            Text(
              '3. data',
              softWrap: true,
            ),
            Text(
              '4. data',
              softWrap: true,
            ),
          ],
        ),
      ),
      actions: <Widget>[
        Checkbox(
          value: showPolicy,
          onChanged: (value) {
            setState(() {
              showPolicy = value ?? false;
            });
          },
        ),
        const Text('Don\'t show again'),
        const SizedBox(width: 100),
        TextButton(
          child: const Text('Accept'),
          onPressed: () async {
            final SharedPreferences prefs = await _prefs;
            await prefs.setBool('showPolicy', !showPolicy);

            if (!context.mounted) return;
            Navigator.pop(context, 'Accept');
          },
        ),
      ],
    );
  }
}
