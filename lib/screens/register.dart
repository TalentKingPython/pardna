import 'dart:convert';
import 'dart:ui';

import 'package:http/http.dart';
import 'package:flutter/material.dart';

import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/network.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  Future<Response> _registerWithEmail() async {
    final response = await AuthService.registerWithEmail(
      _nameController.text,
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 100,
                padding: const EdgeInsets.only(top: 40),
                child: const TextUtil(
                  text: "Register",
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
                height: 500,
                width: double.infinity,
                margin: const EdgeInsets.symmetric(horizontal: 30),
                decoration: BoxDecoration(
                  // border: Border.all(color: Colors.white),
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
                              text:
                                  "Register with one of the following options",
                              color: Colors.green,
                              weight: true,
                              size: 10,
                            )),
                            const Spacer(),
                            const TextUtil(
                              text: "Name",
                              size: 10,
                              color: Colors.green,
                            ),
                            Container(
                              height: 35,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.green))),
                              child: SingleChildScrollView(
                                child: TextFormField(
                                  controller: _nameController,
                                  style: const TextStyle(color: Colors.black),
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.person,
                                      color: Colors.green,
                                    ),
                                    fillColor: Colors.green,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
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
                                      bottom: BorderSide(color: Colors.green))),
                              child: SingleChildScrollView(
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
                                      bottom: BorderSide(color: Colors.green))),
                              child: SingleChildScrollView(
                                child: TextFormField(
                                  controller: _passwordController,
                                  style: const TextStyle(color: Colors.black),
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.green,
                                    ),
                                    fillColor: Colors.green,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            const TextUtil(
                              text: "Confirm Password",
                              size: 10,
                              color: Colors.green,
                            ),
                            Container(
                              height: 35,
                              decoration: const BoxDecoration(
                                  border: Border(
                                      bottom: BorderSide(color: Colors.green))),
                              child: SingleChildScrollView(
                                child: TextFormField(
                                  controller: _confirmController,
                                  style: const TextStyle(color: Colors.black),
                                  obscureText: true,
                                  decoration: const InputDecoration(
                                    suffixIcon: Icon(
                                      Icons.lock,
                                      color: Colors.green,
                                    ),
                                    fillColor: Colors.green,
                                    border: InputBorder.none,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            TextButton(
                              child: Container(
                                height: 40,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(30)),
                                alignment: Alignment.center,
                                child: const TextUtil(
                                  text: "Register",
                                  color: Colors.white,
                                ),
                              ),
                              onPressed: () async {
                                if (_passwordController.text !=
                                    _confirmController.text) {
                                  const snackBar = SnackBar(
                                    content: Text(
                                      'Passwords you entered should be sames.',
                                    ),
                                  );

                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBar);
                                } else {
                                  final response = await _registerWithEmail();
                                  print(response.statusCode);
                                  if (!context.mounted) return;
                                  if (response.statusCode == 200) {
                                    const snackBar = SnackBar(
                                      content: Text(
                                        'You have registered your account successfully!',
                                      ),
                                    );

                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackBar);
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
                                }
                              },
                            ),
                            const Spacer(),
                            Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const TextUtil(
                                    text: "Do you have an account? ",
                                    color: Colors.black,
                                    size: 13,
                                    weight: true,
                                  ),
                                  TextUtil(
                                    text: "Login",
                                    color: Colors.green,
                                    size: 13,
                                    weight: true,
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )),
                ),
              ),
              const SizedBox(height: 30)
            ],
          ),
        ),
      ),
    );
  }
}
