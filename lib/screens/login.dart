import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart';
import 'package:flutter/material.dart';

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

  bool showPassword = true;

  Future<Response> _signinWithEmail() async {
    final response = await AuthService.loginWithEmail(
      _emailController.text,
      _passwordController.text,
    );

    return response;
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
                        const TextUtil(
                          text: "Forgot password?",
                          size: 13,
                          weight: true,
                          color: Colors.black,
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
                            if (!context.mounted) return;
                            if (response.statusCode == 200) {
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
    );
  }
}
