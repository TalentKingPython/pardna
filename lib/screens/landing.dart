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

  String durationMode(String? duration) {
    final Map<String, String> durationMap = {
      'Daily': 'days',
      'Weekly': 'weeks',
      'Monthly': 'months',
      'Yearly': 'years',
    };

    return durationMap[duration ?? ''] ?? '-';
  }

  int getRunningPeriod(DateTime start, String? duration) {
    final today = DateTime.now();
    switch (duration) {
      case 'Daily':
        return today.difference(start).inDays;
      case 'Weekly':
        return today.difference(start).inDays ~/ 7;
      case 'Monthly':
        if (start.day > today.day) {
          return today.month - start.month - 1;
        } else {
          return today.month - start.month;
        }
      default:
        return 0;
    }
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
                                    if (projects[index]['status'] == 'running')
                                      TextUtil(
                                        text:
                                            '${getRunningPeriod(DateTime.parse(projects[index]['start']), projects[index]['duration'])} / ${projects[index]['number']} ${durationMode(projects[index]['duration'])}',
                                        color: Colors.green,
                                        size: 12,
                                      )
                                    else if (projects[index]['status'] ==
                                        'finished')
                                      const TextUtil(
                                        text: 'Finished',
                                        color: Colors.cyan,
                                        size: 12,
                                      )
                                    else if (projects[index]['status'] ==
                                        'canceled')
                                      const TextUtil(
                                        text: 'Canceled',
                                        color: Colors.red,
                                        size: 12,
                                      )
                                    else if (projects[index]['status'] ==
                                        'preparing')
                                      const TextUtil(
                                        text: 'Preparing',
                                        color: Colors.orange,
                                        size: 12,
                                      )
                                    else
                                      TextUtil(
                                        text:
                                            '${getRunningPeriod(DateTime.parse(projects[index]['start']), projects[index]['duration'])} / ${projects[index]['number']} ${durationMode(projects[index]['duration'])}',
                                        color: Colors.green,
                                        size: 12,
                                      )
                                  ],
                                ),
                                if (projects[index]['status'] == 'running')
                                  TextUtil(
                                    text:
                                        "(${(getRunningPeriod(DateTime.parse(projects[index]['start']), projects[index]['duration']) / int.parse(projects[index]['number'])).toStringAsFixed(2)} %)",
                                    color: Colors.green,
                                    size: 12,
                                  )
                                else if (projects[index]['status'] ==
                                    'finished')
                                  const TextUtil(
                                    text: "(100 %)",
                                    color: Colors.green,
                                    size: 12,
                                  )
                                else
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
