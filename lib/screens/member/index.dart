import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_advanced_avatar/flutter_advanced_avatar.dart';

// import 'package:pardna/screens/member/addcontacts.dart';
import 'package:pardna/screens/member/addmember.dart';
import 'package:pardna/utils/network.dart';
import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';
import 'package:pardna/utils/globals.dart' as globals;

class Member extends StatefulWidget {
  const Member({super.key});

  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
  List<dynamic> members = [];

  @override
  void initState() {
    super.initState();
    UserService.getAllTeamMembers(globals.userInfo['members'])
        // .then((res) => print(jsonDecode(res.body)['data']));
        .then((res) => setState(() {
              members = jsonDecode(res.body)['data'];
            }));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/homebg.jpg"), fit: BoxFit.fill),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 15),
        child: Column(
          children: [
            HomeHeader(
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
            ),
            SizedBox(
              height: 60,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const TextUtil(
                    text: "Pardna Participants",
                    color: Colors.black,
                    weight: true,
                    size: 25,
                  ),
                  TextButton(
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(20)),
                      child: const Icon(
                        Icons.add,
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () => _dialogBuilder(context),
                  ),
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
              child: SizedBox(
                height: 540,
                width: 400,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int index = 0; index < members.length; index++)
                        Column(
                          children: [
                            Row(
                              children: [
                                const AdvancedAvatar(
                                  size: 50,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.green,
                                  ),
                                  child: Icon(
                                    Icons.account_circle,
                                    color: Colors.white,
                                    size: 30,
                                  ),
                                ),
                                const SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextUtil(
                                      height: 25,
                                      text: members[index]['name'],
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                    TextUtil(
                                      height: 20,
                                      text: members[index]['email'],
                                      size: 13,
                                      color: Colors.grey,
                                    ),
                                    TextUtil(
                                      height: 20,
                                      text: members[index]['phone'] ??
                                          'No phone number',
                                      size: 13,
                                      color: Colors.grey,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            Divider(),
                          ],
                        ),
                      TextButton(
                        child: Container(
                          width: 45,
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Icon(
                            Icons.add,
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () => _dialogBuilder(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _dialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const TextUtil(
            text: 'How to you want to add a member?',
            color: Colors.black,
            size: 15,
          ),
          children: [
            TextButton(
              child: Container(
                height: 50,
                margin: const EdgeInsets.symmetric(horizontal: 15),
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(8),
                ),
                alignment: Alignment.center,
                child: const TextUtil(
                  text: "Add users as your members",
                  color: Colors.white,
                  weight: true,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddMember(),
                  ),
                );
              },
            ),
            // TextButton(
            //   child: Container(
            //     height: 50,
            //     margin: const EdgeInsets.symmetric(horizontal: 15),
            //     decoration: BoxDecoration(
            //       color: Colors.green,
            //       borderRadius: BorderRadius.circular(8),
            //     ),
            //     alignment: Alignment.center,
            //     child: const TextUtil(
            //       text: "Add from phone's contacts book",
            //       color: Colors.white,
            //       weight: true,
            //     ),
            //   ),
            //   onPressed: () {
            //     Navigator.pop(context);
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => const AddContacts(),
            //       ),
            //     );
            //   },
            // ),
            const SizedBox(height: 15),
            TextButton(
              child: const TextUtil(
                text: 'Colse',
                size: 15,
                color: Colors.green,
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
