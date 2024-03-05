import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:pardna/utils/network.dart';
import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';
import 'package:pardna/utils/globals.dart';

class Landing extends StatefulWidget {
  const Landing({super.key});

  @override
  State<Landing> createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  List<dynamic> projects = [];

  @override
  void initState() {
    super.initState();
    getProjectMembers();
  }

  void getProjectMembers() {
    ProjectService.getAllProjects().then((res) => setState(() {
          projects = jsonDecode(res.body)['data'];
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
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextUtil(
                  text: 'Hello, ${userInfo['name']}',
                  color: Colors.black,
                  size: 25,
                  weight: true,
                ),
              ),
            ),
            const SizedBox(
              height: 60,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: TextUtil(
                  text: "YOUR PARDNAS' AT A GLANCE",
                  color: Colors.black,
                  weight: true,
                  size: 17,
                ),
              ),
            ),
            Container(
              constraints: const BoxConstraints(maxHeight: 550),
              width: 500,
              margin: const EdgeInsets.symmetric(vertical: 15),
              padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int index = 0; index < projects.length; index++)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextUtil(
                                      text: projects[index]['name'],
                                      color: Colors.black,
                                      size: 15,
                                      weight: true,
                                    ),
                                    TextUtil(
                                      text:
                                          "0 / ${projects[index]['number']} Weeks",
                                      color: Colors.green,
                                      size: 12,
                                    )
                                  ],
                                ),
                                const TextUtil(
                                  text: "(0 %)",
                                  color: Colors.green,
                                  size: 12,
                                )
                              ],
                            ),
                          ),
                          if (index != projects.length - 1) const Divider(),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
