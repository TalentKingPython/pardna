import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:pardna/screens/home.dart';
import 'package:pardna/utils/network.dart';
import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';
import 'package:pardna/utils/globals.dart';

import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class ProfileDetail extends StatefulWidget {
  const ProfileDetail({super.key});

  @override
  State<ProfileDetail> createState() => _ProfileDetailState();
}

class _ProfileDetailState extends State<ProfileDetail> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _oldController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmController = TextEditingController();

  String error = '';
  String success = '';
  dynamic paymentMethod = {};

  @override
  void initState() {
    super.initState();
    getPaymentMethodByCustomerId().then((res) => {
          setState(() {
            paymentMethod = jsonDecode(res.body);
          })
        });
  }

  Future<http.Response> getPaymentMethodByCustomerId() async {
    final response = await http.get(
      Uri.parse('$baseURL/stripe/${userInfo['stripe_customer_token']}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'x-access-token': authToken,
      },
    );
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          height: double.infinity,
          width: double.infinity,
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("assets/homebg.jpg"), fit: BoxFit.fill),
          ),
          child: Column(
            children: [
              DetailHeader(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: Column(
                  children: [
                    const SizedBox(height: 10),
                    const CircleAvatar(
                      radius: 70, // Image radius
                      backgroundImage: NetworkImage(
                          'https://app.idonethis.com/api/users/download-avatar/user/124382'),
                    ),
                    const SizedBox(height: 10),
                    TextUtil(
                      text: userInfo['name'],
                      size: 25,
                      color: Colors.black,
                      weight: true,
                    ),
                    const SizedBox(height: 30),
                    if (error != '')
                      Card(
                        color: Colors.red[100],
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextUtil(
                            text: error,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    if (success != '')
                      Card(
                        color: Colors.green[100],
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: TextUtil(
                            text: success,
                            color: Colors.green,
                          ),
                        ),
                      ),
                    Card(
                      elevation: 0,
                      color: Colors.white,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 30, vertical: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(
                                  Icons.person_outline,
                                  color: Colors.green,
                                  size: 35,
                                ),
                                const SizedBox(width: 20),
                                TextUtil(
                                  text: userInfo['name'],
                                  size: 20,
                                  color: Colors.black45,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Edit your name'),
                                      content: SingleChildScrollView(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            const TextUtil(
                                              text: "Name",
                                              size: 10,
                                              color: Colors.green,
                                            ),
                                            Container(
                                              height: 35,
                                              decoration: const BoxDecoration(
                                                border: Border(
                                                  bottom: BorderSide(
                                                      color: Colors.green),
                                                ),
                                              ),
                                              child: SingleChildScrollView(
                                                child: TextFormField(
                                                  controller: _nameController,
                                                  style: const TextStyle(
                                                      color: Colors.black),
                                                  decoration:
                                                      const InputDecoration(
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
                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () async {
                                            if (_nameController.text == '') {
                                              setState(() {
                                                error =
                                                    'Please enter your name';
                                              });
                                              Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                setState(() {
                                                  error = '';
                                                });
                                              });
                                              Navigator.pop(context, 'Cancel');
                                              return;
                                            }
                                            final response =
                                                await AuthService.updateProfile(
                                                    _nameController.text,
                                                    null,
                                                    null,
                                                    null);
                                            if (!context.mounted) return;
                                            if (response.statusCode == 200) {
                                              setState(() {
                                                userInfo =
                                                    jsonDecode(response.body);
                                              });
                                              Navigator.pop(context, 'OK');
                                            } else {
                                              setState(() {
                                                error = jsonDecode(
                                                    response.body)['message'];
                                              });
                                              Future.delayed(
                                                  const Duration(seconds: 2),
                                                  () {
                                                setState(() {
                                                  error = '';
                                                });
                                              });
                                              Navigator.pop(context, 'Cancel');
                                              return;
                                            }
                                          },
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: const TextUtil(
                                    text: 'Edit',
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Icon(
                                  Icons.email_outlined,
                                  color: Colors.green,
                                  size: 35,
                                ),
                                const SizedBox(width: 20),
                                TextUtil(
                                  text: userInfo['email'],
                                  size: 20,
                                  color: Colors.black45,
                                ),
                                const Spacer(),
                                GestureDetector(
                                  onTap: () => showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                      title: const Text('Email Verification'),
                                      content: const Text(
                                          'Email Verification is not working yet!'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'Cancel'),
                                          child: const Text('Cancel'),
                                        ),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context, 'OK'),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    ),
                                  ),
                                  child: const TextUtil(
                                    text: 'Verify',
                                    color: Colors.green,
                                  ),
                                )
                              ],
                            ),
                            const Divider(),
                            Row(
                              children: [
                                const Icon(
                                  Icons.phone_outlined,
                                  color: Colors.green,
                                  size: 35,
                                ),
                                const SizedBox(width: 20),
                                TextUtil(
                                  text: userInfo['phone'] ?? 'No phone number',
                                  size: 20,
                                  color: Colors.black45,
                                ),
                                const Spacer(),
                                if (userInfo['verification']?.contains('phone'))
                                  const TextUtil(
                                    text: 'Verified',
                                    color: Colors.green,
                                  )
                                else
                                  GestureDetector(
                                    onTap: () => showDialog<String>(
                                        context: context,
                                        builder: (_) =>
                                            const PhoneVerificationDialog()),
                                    child: const TextUtil(
                                      text: 'Verify',
                                      color: Colors.green,
                                    ),
                                  ),
                              ],
                            ),
                            const Divider(),
                            if (paymentMethod['card'] != null)
                              Row(
                                children: [
                                  const Icon(
                                    Icons.credit_card,
                                    color: Colors.green,
                                    size: 35,
                                  ),
                                  const SizedBox(width: 20),
                                  TextUtil(
                                    text:
                                        '**** **** **** ${paymentMethod['card']['last4']}',
                                    size: 15,
                                    color: Colors.black45,
                                  ),
                                  const Spacer(),
                                  TextUtil(
                                    text:
                                        '${paymentMethod['card']['exp_month']}/${paymentMethod['card']['exp_year']}',
                                    size: 15,
                                    color: Colors.black45,
                                  ),
                                ],
                              ),
                            if (paymentMethod['card'] != null) const Divider(),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerRight,
                              child: GestureDetector(
                                onTap: () => showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      AlertDialog(
                                    title: const Text('Edit your name'),
                                    content: SingleChildScrollView(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          const TextUtil(
                                            text: "Old Password",
                                            size: 10,
                                            color: Colors.green,
                                          ),
                                          Container(
                                            height: 35,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.green),
                                              ),
                                            ),
                                            child: SingleChildScrollView(
                                              child: TextFormField(
                                                obscureText: true,
                                                controller: _oldController,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                decoration:
                                                    const InputDecoration(
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
                                          const TextUtil(
                                            text: "New Password",
                                            size: 10,
                                            color: Colors.green,
                                          ),
                                          Container(
                                            height: 35,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.green),
                                              ),
                                            ),
                                            child: SingleChildScrollView(
                                              child: TextFormField(
                                                obscureText: true,
                                                controller: _passwordController,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                decoration:
                                                    const InputDecoration(
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
                                          const TextUtil(
                                            text: "Confirm New Password",
                                            size: 10,
                                            color: Colors.green,
                                          ),
                                          Container(
                                            height: 35,
                                            decoration: const BoxDecoration(
                                              border: Border(
                                                bottom: BorderSide(
                                                    color: Colors.green),
                                              ),
                                            ),
                                            child: SingleChildScrollView(
                                              child: TextFormField(
                                                obscureText: true,
                                                controller: _confirmController,
                                                style: const TextStyle(
                                                    color: Colors.black),
                                                decoration:
                                                    const InputDecoration(
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
                                        ],
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () =>
                                            Navigator.pop(context, 'Cancel'),
                                        child: const Text('Cancel'),
                                      ),
                                      TextButton(
                                        onPressed: () async {
                                          if (_passwordController.text !=
                                              _confirmController.text) {
                                            setState(() {
                                              error = 'Not matched passwords!';
                                            });
                                            Future.delayed(
                                                const Duration(seconds: 2), () {
                                              setState(() {
                                                error = '';
                                              });
                                            });
                                            Navigator.pop(context, 'Cancel');
                                            return;
                                          }
                                          final response =
                                              await AuthService.updateProfile(
                                                  null,
                                                  null,
                                                  _passwordController.text,
                                                  _oldController.text);
                                          if (!context.mounted) return;
                                          if (response.statusCode == 200) {
                                            setState(() {
                                              success =
                                                  'Password is reset successfully';
                                            });
                                            Future.delayed(
                                                const Duration(seconds: 2), () {
                                              setState(() {
                                                success = '';
                                              });
                                            });
                                            Navigator.pop(context, 'OK');
                                          } else {
                                            setState(() {
                                              error = jsonDecode(
                                                  response.body)['message'];
                                            });
                                            Future.delayed(
                                                const Duration(seconds: 2), () {
                                              setState(() {
                                                error = '';
                                              });
                                            });
                                            Navigator.pop(context, 'Cancel');
                                          }
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  ),
                                ),
                                child: const TextUtil(
                                  text: 'Reset Password',
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () async {
                          final response = await UserService.deleteUser();
                          if (response.statusCode == 200) {
                            setState(() {
                              error = 'Your account is deleted successfully';
                            });
                            Future.delayed(const Duration(seconds: 2), () {
                              setState(() {
                                error = '';
                              });
                            });
                          }
                        },
                        child: Card(
                          color: Colors.red[400],
                          child: const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text('Delete Account'),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(
          iconSize: 40,
        ),
        backgroundColor: Colors.green,
        items: [
          BottomBarItem(
            icon: const Icon(Icons.home),
            backgroundColor: Colors.black,
            title: const TextUtil(
              text: 'Home',
              size: 15,
              color: Colors.black,
              weight: true,
            ),
          ),
          BottomBarItem(
            icon: const Icon(Icons.home),
            backgroundColor: Colors.black,
            title: const TextUtil(
              text: 'Profiles',
              size: 15,
              color: Colors.black,
              weight: true,
            ),
          ),
          BottomBarItem(
            icon: const Icon(Icons.groups),
            backgroundColor: Colors.black,
            title: const TextUtil(
              text: 'Member',
              size: 15,
              color: Colors.black,
              weight: true,
            ),
          ),
        ],
        hasNotch: true,
        onTap: (index) {
          switch (index) {
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(pageIndex: 0),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(pageIndex: 1),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(pageIndex: 2),
                ),
              );
              break;
            default:
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        enableFeedback: false,
        onPressed: () {},
        backgroundColor: Colors.green,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.person,
          size: 40,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class PhoneVerificationDialog extends StatefulWidget {
  const PhoneVerificationDialog({super.key});
  @override
  State<PhoneVerificationDialog> createState() =>
      _PhoneVerificationDialogState();
}

class _PhoneVerificationDialogState extends State<PhoneVerificationDialog> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();

  String verifyId = '';
  String success = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Phone Verification'),
      content: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (success != '')
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.green[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextUtil(
                  text: success,
                  color: Colors.green,
                ),
              ),
            if (error != '')
              Container(
                padding: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                  color: Colors.red[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: TextUtil(
                  text: error,
                  color: Colors.red,
                ),
              ),
            SingleChildScrollView(
              child: TextFormField(
                controller: _phoneController,
                readOnly: (verifyId != ''),
                decoration: const InputDecoration(
                  labelStyle: TextStyle(color: Colors.green, fontSize: 15),
                  border: UnderlineInputBorder(),
                  labelText: 'Enter phone number',
                ),
              ),
            ),
            if (verifyId != '')
              SingleChildScrollView(
                child: TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(
                    labelStyle: TextStyle(color: Colors.green, fontSize: 15),
                    border: UnderlineInputBorder(),
                    labelText: 'Enter verification code',
                  ),
                ),
              ),
          ],
        ),
      ),
      actions: <Widget>[
        if (verifyId == '')
          TextButton(
            onPressed: () async {
              if (_phoneController.text == '') {
                setState(() {
                  error = 'Please enter phone number';
                });
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    error = '';
                  });
                });
              } else {
                final response = await AuthService.sendVerificationCode(
                    _phoneController.text);
                if (response.statusCode == 200) {
                  setState(() {
                    verifyId = jsonDecode(response.body)['id'];
                    success = 'Code is sent to your phone';
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      success = '';
                    });
                  });
                } else {
                  setState(() {
                    error = jsonDecode(response.body)['message'];
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      error = '';
                    });
                  });
                }
              }
            },
            child: const Text('Send Code'),
          )
        else
          TextButton(
            onPressed: () async {
              if (_codeController.text.length != 6) {
                setState(() {
                  error = 'Enter correct verification code';
                });
                Future.delayed(const Duration(seconds: 2), () {
                  setState(() {
                    error = '';
                  });
                });
              } else {
                print(_codeController.text);
                final response = await AuthService.checkVerificationCode(
                    verifyId, _codeController.text);
                if (response.statusCode == 200) {
                  setState(() {
                    success = 'Your phone number is verified';
                    userInfo = jsonDecode(response.body);
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      success = '';
                    });
                  });
                } else {
                  setState(() {
                    error = jsonDecode(response.body)['message'];
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    setState(() {
                      error = '';
                    });
                  });
                }
              }
            },
            child: const Text('Verify'),
          )
      ],
    );
  }
}
