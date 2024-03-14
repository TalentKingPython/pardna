import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';
import 'package:pardna/utils/globals.dart';

// import 'package:pardna/screens/member/addcontacts.dart';
import 'package:pardna/utils/network.dart';
import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';

class SetUserRoles extends StatefulWidget {
  const SetUserRoles({super.key});

  @override
  State<SetUserRoles> createState() => _SetUserRolesState();
}

class _SetUserRolesState extends State<SetUserRoles> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    UserService.getAllUsers()
        .then((res) => setState(() {
              users = jsonDecode(res.body)['data'];
            }))
        // .then((res) => print(jsonDecode(res.body)['data']))
        .catchError((error) => print(error));
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
              const SizedBox(height: 30),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const TextUtil(
                          text: "Set Users' Roles",
                          color: Colors.black,
                          weight: true,
                          size: 25,
                        ),
                        for (int i = 0; i < users.length; i++)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Row(
                              children: [
                                const AdvancedAvatar(
                                  size: 50,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: Colors.green),
                                  child: Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 5),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextUtil(
                                      text: users[i]['name'],
                                      size: 13,
                                      weight: true,
                                      color: Colors.black,
                                    ),
                                    TextUtil(
                                      text: users[i]['email'],
                                      size: 12,
                                      color: Colors.black87,
                                    ),
                                    TextUtil(
                                      text: users[i]['phone'] ??
                                          'No phone number',
                                      size: 12,
                                      color: Colors.black87,
                                    ),
                                  ],
                                ),
                                const Spacer(),
                                if (users[i]['roles']?.contains('admin'))
                                  const TextUtil(
                                    text: 'Admin',
                                    color: Colors.black,
                                  )
                                else if (users[i]['roles']?.contains('tier1'))
                                  const TextUtil(
                                    text: 'Tier2',
                                    color: Colors.black,
                                  )
                                else if (users[i]['roles']?.contains('tier2'))
                                  const TextUtil(
                                    text: 'Tier1',
                                    color: Colors.black,
                                  )
                                else
                                  Row(
                                    children: [
                                      if (userInfo['roles']
                                          ?.contains('superadmin'))
                                        GestureDetector(
                                          child: const Icon(
                                            Icons.manage_accounts,
                                            color: Colors.green,
                                            size: 35,
                                          ),
                                          onTap: () {
                                            showDialog<void>(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: const Text(
                                                      'Confirm User\'s Role'),
                                                  content: const Row(
                                                    children: [
                                                      Text(
                                                          'Would you set this user as '),
                                                      TextUtil(
                                                        text: 'Admin',
                                                        color: Colors.green,
                                                        weight: true,
                                                      ),
                                                      Text('?')
                                                    ],
                                                  ),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: const Text('No'),
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: const Text('Yes'),
                                                      onPressed: () async {
                                                        Navigator.of(context)
                                                            .pop();
                                                        final response =
                                                            await UserService
                                                                .setUserRoles(
                                                                    users[i]
                                                                        ['_id'],
                                                                    [
                                                              'admin',
                                                              'tier2',
                                                              'tier1'
                                                            ]);
                                                        if (response
                                                                .statusCode ==
                                                            200) {
                                                          setState(() {
                                                            users[i]
                                                                ['roles'] = [
                                                              'admin',
                                                              'tier2',
                                                              'tier1'
                                                            ];
                                                          });
                                                        } else {
                                                          print(jsonDecode(
                                                                  response
                                                                      .body)[
                                                              'message']);
                                                        }
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        child: const Icon(
                                          Icons.person_add_alt_1,
                                          color: Colors.green,
                                          size: 35,
                                        ),
                                        onTap: () {
                                          showDialog<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Confirm User\'s Role'),
                                                content: const Row(
                                                  children: [
                                                    Text(
                                                        'Would you set this user as '),
                                                    TextUtil(
                                                      text: 'Tier2',
                                                      color: Colors.green,
                                                      weight: true,
                                                    ),
                                                    Text('?')
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      final response =
                                                          await UserService
                                                              .setUserRoles(
                                                                  users[i]
                                                                      ['_id'],
                                                                  [
                                                            'tier2',
                                                            'tier1'
                                                          ]);
                                                      if (response.statusCode ==
                                                          200) {
                                                        setState(() {
                                                          users[i]['roles'] = [
                                                            'tier2',
                                                            'tier1'
                                                          ];
                                                        });
                                                      } else {
                                                        print(jsonDecode(
                                                                response.body)[
                                                            'message']);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                      const SizedBox(width: 10),
                                      GestureDetector(
                                        child: const Icon(
                                          Icons.person_remove_alt_1,
                                          color: Colors.green,
                                          size: 35,
                                        ),
                                        onTap: () {
                                          showDialog<void>(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: const Text(
                                                    'Confirm User\'s Role'),
                                                content: const Row(
                                                  children: [
                                                    Text(
                                                        'Would you set this user as '),
                                                    TextUtil(
                                                      text: 'Tier1',
                                                      color: Colors.green,
                                                      weight: true,
                                                    ),
                                                    Text('?')
                                                  ],
                                                ),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: const Text('No'),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: const Text('Yes'),
                                                    onPressed: () async {
                                                      Navigator.of(context)
                                                          .pop();
                                                      final response =
                                                          await UserService
                                                              .setUserRoles(
                                                                  users[i]
                                                                      ['_id'],
                                                                  ['tier1']);
                                                      if (response.statusCode ==
                                                          200) {
                                                        setState(() {
                                                          users[i]['roles'] = [
                                                            'tier1'
                                                          ];
                                                        });
                                                      } else {
                                                        print(jsonDecode(
                                                                response.body)[
                                                            'message']);
                                                      }
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      )
                                    ],
                                  )
                              ],
                            ),
                          ),
                      ],
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
