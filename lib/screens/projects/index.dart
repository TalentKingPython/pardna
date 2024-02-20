import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:pardna/screens/projects/addproject.dart';
import 'package:pardna/screens/projects/details.dart';
import 'package:pardna/utils/network.dart';
import 'package:pardna/utils/globals.dart' as globals;
import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';

class Project extends StatefulWidget {
  const Project({Key? key}) : super(key: key);

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  final ExpansionTileController controller = ExpansionTileController();
  List<dynamic> projects = [];

  @override
  void initState() {
    super.initState();
    getAllProjects();
  }

  void getAllProjects() {
    ProjectService.getAllProjects().then((res) => setState(() {
          projects = jsonDecode(res.body)['data'];
        }));
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

  DateTime getEndDate(DateTime start, String? duration, String numberOfMember) {
    final number = int.parse(numberOfMember);
    switch (duration) {
      case 'Daily':
        return start.add(Duration(days: number));
      case 'Weekly':
        return start.add(Duration(days: number * 7));
      case 'Monthly':
        return DateTime(start.year, start.month + number, start.day);
      case 'Yearly':
        return DateTime(start.year + number, start.month, start.day);
      default:
        return start;
    }
  }

  String getTotal(String amount, String number) {
    double total = double.parse(amount) * int.parse(number);
    return total.toStringAsFixed(2);
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
            const SizedBox(
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextUtil(
                  text: 'Hello',
                  color: Colors.black,
                  size: 25,
                  weight: true,
                ),
              ),
            ),
            SizedBox(
              height: 70,
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const TextUtil(
                      text: "Your projects",
                      color: Colors.black,
                      weight: true,
                      size: 17,
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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const AddProject(),
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: 540,
              child: SingleChildScrollView(
                  child: Column(
                children: [
                  for (int i = 0; i < projects.length; i++)
                    Column(
                      children: [
                        Card(
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            side: BorderSide(
                              color: Colors.white,
                            ),
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: ExpansionTile(
                            title: Row(
                              children: [
                                const Icon(Icons.person_outlined,
                                    size: 22, color: Colors.green),
                                const SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextUtil(
                                      text: projects[i]['name'],
                                      color: Colors.black,
                                      weight: true,
                                      size: 15,
                                    ),
                                    TextUtil(
                                      text:
                                          '0 / ${projects[i]['number']} ${durationMode(projects[i]['duration'])}',
                                      color: Colors.green,
                                      size: 12,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    const Divider(height: 5),
                                    const SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.calendar_today_rounded,
                                            color: Colors.green, size: 15),
                                        const TextUtil(
                                          text: '  From ',
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                        TextUtil(
                                          text: DateFormat('yyyy.MM.dd').format(
                                              DateTime.parse(
                                                  projects[i]['start'])),
                                          weight: true,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                        const TextUtil(
                                          text: ' to ',
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                        TextUtil(
                                          text: DateFormat('yyyy.MM.dd').format(
                                              getEndDate(
                                                  DateTime.parse(
                                                      projects[i]['start']),
                                                  projects[i]['duration'],
                                                  projects[i]['number'])),
                                          weight: true,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.groups,
                                            color: Colors.green, size: 15),
                                        const TextUtil(
                                          text: '  Has ',
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                        TextUtil(
                                          text: projects[i]['number'],
                                          weight: true,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                        const TextUtil(
                                          text: ' members',
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          size: 15,
                                          Icons.task,
                                          color: Colors.green,
                                        ),
                                        const SizedBox(width: 5),
                                        TextUtil(
                                          text: '\$${projects[i]['amount']}',
                                          weight: true,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                        const TextUtil(
                                          text: ' per participant ',
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                        TextUtil(
                                          text: projects[i]['duration'],
                                          weight: true,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.web_stories_outlined,
                                            color: Colors.green, size: 15),
                                        const TextUtil(
                                          text:
                                              '  Total from pardna per participant ',
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                        TextUtil(
                                          text:
                                              '\$${getTotal(projects[i]['amount'], projects[i]['number'])}',
                                          weight: true,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Divider(height: 5),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 12),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    TextButton(
                                      onPressed: () {
                                        setState(() {
                                          globals.projectInfo = projects[i];
                                        });
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const ProjectDetail(),
                                          ),
                                        );
                                      },
                                      child: Container(
                                        height: 40,
                                        width: 180,
                                        alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: const TextUtil(
                                          text: 'Check project',
                                          size: 15,
                                          weight: true,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      color: Colors.red[700],
                                      onPressed: () {
                                        ProjectService.deleteProject(
                                                projects[i]['_id'])
                                            .then((res) => {
                                                  if (res.statusCode == 200)
                                                    getAllProjects()
                                                });
                                      },
                                      icon: const Icon(
                                          Icons.delete_forever_outlined),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        )
                      ],
                    ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }
}
