import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';

// import 'package:pardna/screens/member/addcontacts.dart';
import 'package:pardna/utils/network.dart';
import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';
import 'package:pardna/utils/globals.dart';

class Tier1Users extends StatefulWidget {
  const Tier1Users({super.key});

  @override
  State<Tier1Users> createState() => _Tier1UsersState();
}

class _Tier1UsersState extends State<Tier1Users> {
  List<dynamic> users = [];

  @override
  void initState() {
    super.initState();
    UserService.getAllTier1Users()
        .then((res) => setState(() {
              users = jsonDecode(res.body)['data'];
            }))
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
                          text: "Tier1 Users",
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
                                if (userInfo['roles']?.contains('superadmin'))
                                  IconButton(
                                    icon: const Icon(
                                      Icons.person_remove,
                                      color: Colors.green,
                                      size: 30,
                                    ),
                                    onPressed: () async {
                                      final updatedRoles = [];
                                      final response =
                                          await UserService.setUserRoles(
                                        users[i]['_id'],
                                        updatedRoles,
                                      );
                                      if (!context.mounted) return;
                                      if (response.statusCode == 200) {
                                        setState(() {
                                          users = users
                                              .where((element) =>
                                                  element['_id'] !=
                                                  users[i]['_id'])
                                              .toList();
                                        });
                                      }
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
            ],
          ),
        ),
      ),
    );
  }
}
