import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:pardna/screens/home.dart';
import 'package:pardna/screens/projects/addmember.dart';
import 'package:pardna/utils/network.dart';
import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';
import 'package:pardna/utils/globals.dart' as globals;

import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class ProjectDetail extends StatefulWidget {
  const ProjectDetail({super.key});

  @override
  State<ProjectDetail> createState() => _ProjectDetailState();
}

class _ProjectDetailState extends State<ProjectDetail> {
  List members = [];

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

  void addButtonPressed() {
    if (globals.userInfo['_id'] == globals.projectInfo['creator']) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const AddMember(),
        ),
      );
    } else {
      _joinDialogBuilder(context);
    }
  }

  @override
  void initState() {
    super.initState();
    getProjectMembers();
  }

  void getProjectMembers() {
    ProjectService.getAllProjectMembers(globals.projectInfo['_id'])
        .then((res) => setState(() {
              members = jsonDecode(res.body)['data'];
            }));
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
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Row(
                        children: [
                          const TextUtil(
                            text: 'Pardna ',
                            size: 25,
                            color: Colors.black,
                            weight: true,
                          ),
                          TextUtil(
                            text: globals.projectInfo['name'],
                            size: 25,
                            color: Colors.green,
                            weight: true,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    Card(
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Column(
                              children: [
                                const Divider(height: 5),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.calendar_today_rounded,
                                        color: Colors.green, size: 15),
                                    const TextUtil(
                                      text: '  From ',
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                    TextUtil(
                                      text: DateFormat('yyyy.MM.dd').format(
                                          DateTime.parse(
                                              globals.projectInfo['start'])),
                                      weight: true,
                                      size: 15,
                                      color: Colors.green,
                                    ),
                                    const TextUtil(
                                      text: ' to ',
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                    TextUtil(
                                      text: DateFormat('yyyy.MM.dd').format(
                                          getEndDate(
                                              DateTime.parse(
                                                  globals.projectInfo['start']),
                                              globals.projectInfo['duration'],
                                              globals.projectInfo['number'])),
                                      weight: true,
                                      size: 15,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.groups,
                                        color: Colors.green, size: 15),
                                    const TextUtil(
                                      text: '  Has ',
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                    TextUtil(
                                      text: globals.projectInfo['number'],
                                      weight: true,
                                      size: 15,
                                      color: Colors.green,
                                    ),
                                    const TextUtil(
                                      text: ' members',
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      size: 15,
                                      Icons.task,
                                      color: Colors.green,
                                    ),
                                    const SizedBox(width: 5),
                                    TextUtil(
                                      text:
                                          '\$${globals.projectInfo['amount']}',
                                      weight: true,
                                      size: 15,
                                      color: Colors.green,
                                    ),
                                    const TextUtil(
                                      text: ' per participant ',
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                    TextUtil(
                                      text: globals.projectInfo['duration'],
                                      weight: true,
                                      size: 15,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(Icons.web_stories_outlined,
                                        color: Colors.green, size: 15),
                                    const TextUtil(
                                      text:
                                          '  Total from pardna per participant ',
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                    TextUtil(
                                      text:
                                          '\$${getTotal(globals.projectInfo['amount'], globals.projectInfo['number'])}',
                                      weight: true,
                                      size: 15,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                const Divider(height: 5),
                                const SizedBox(height: 8),
                                const Row(
                                  children: [
                                    TextUtil(
                                      text: 'Total paid: ',
                                      size: 15,
                                      weight: true,
                                      color: Colors.black,
                                    ),
                                    TextUtil(
                                      text: '\$0',
                                      size: 15,
                                      weight: true,
                                      color: Colors.green,
                                    ),
                                  ],
                                ),
                                const Row(
                                  children: [
                                    TextUtil(
                                      text: 'Total due: ',
                                      size: 15,
                                      weight: true,
                                      color: Colors.black,
                                    ),
                                    TextUtil(
                                      text: '\$0',
                                      size: 15,
                                      weight: true,
                                      color: Colors.red,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    const TextUtil(
                                      text: 'Total payments till end project: ',
                                      size: 15,
                                      weight: true,
                                      color: Colors.black,
                                    ),
                                    TextUtil(
                                      text:
                                          '\$${getTotal(getTotal(globals.projectInfo['amount'], globals.projectInfo['number']), globals.projectInfo['number'])}',
                                      size: 15,
                                      weight: true,
                                      color: Colors.cyan,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const TextUtil(
                          text: 'Pardna Participants',
                          size: 17,
                          weight: true,
                          color: Colors.black,
                        ),
                        TextButton(
                          child: Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {
                            addButtonPressed();
                          },
                        )
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 25, vertical: 15),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.white,
                      ),
                      child: SizedBox(
                        height: 300,
                        width: 400,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              for (int index = 0;
                                  index < members.length;
                                  index++)
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        const SizedBox(width: 10),
                                        const Icon(
                                          Icons.person,
                                          color: Colors.green,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 10),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            TextUtil(
                                              text: members[index]['name'],
                                              size: 13,
                                              color: Colors.black,
                                            ),
                                            TextUtil(
                                              text: members[index]['email'],
                                              size: 12,
                                              color: Colors.grey,
                                            ),
                                            TextUtil(
                                              text: members[index]['phone'] ??
                                                  'No phone number',
                                              size: 12,
                                              color: Colors.grey,
                                            ),
                                          ],
                                        ),
                                        const Spacer(),
                                        if (members[index]['status'] ==
                                            'joining')
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (globals.userInfo['_id'] ==
                                                      globals.projectInfo[
                                                          'creator']) {
                                                    ProjectService
                                                            .updateProjectMember(
                                                                globals.projectInfo[
                                                                    '_id'],
                                                                members[index]
                                                                    ['_id'],
                                                                'active')
                                                        .then((res) => {
                                                              if (res.statusCode ==
                                                                  200)
                                                                setState(() {
                                                                  members[index]
                                                                          [
                                                                          'status'] =
                                                                      'active';
                                                                })
                                                            });
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.check_circle,
                                                  color: Colors.green,
                                                ),
                                              ),
                                              GestureDetector(
                                                onTap: () {
                                                  if (globals.userInfo['_id'] ==
                                                      globals.projectInfo[
                                                          'creator']) {
                                                    ProjectService
                                                            .updateProjectMember(
                                                                globals.projectInfo[
                                                                    '_id'],
                                                                members[index]
                                                                    ['_id'],
                                                                'denied')
                                                        .then((res) => {
                                                              if (res.statusCode ==
                                                                  200)
                                                                setState(() {
                                                                  members[index]
                                                                          [
                                                                          'status'] =
                                                                      'denied';
                                                                })
                                                            });
                                                  }
                                                },
                                                child: const Icon(
                                                  Icons.highlight_off,
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ],
                                          ),
                                        if (members[index]['status'] ==
                                            'inviting')
                                          GestureDetector(
                                            onTap: () {
                                              if (members[index]['_id'] ==
                                                  globals.userInfo['_id']) {
                                                _acceptDialogBuilder(
                                                    context, index);
                                              }
                                            },
                                            child: const Icon(
                                              Icons.pending,
                                              color: Colors.orange,
                                            ),
                                          ),
                                        if (members[index]['status'] ==
                                            'active')
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          ),
                                        if (members[index]['status'] ==
                                            'denied')
                                          const Icon(
                                            Icons.highlight_off,
                                            color: Colors.red,
                                          ),
                                      ],
                                    ),
                                    const Divider(height: 10),
                                  ],
                                ),
                              TextButton(
                                child: Container(
                                  width: 40,
                                  height: 40,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(25),
                                  ),
                                  child: const Icon(
                                    Icons.add,
                                    color: Colors.black,
                                  ),
                                ),
                                onPressed: () {
                                  addButtonPressed();
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
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
              text: 'Projects',
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
        child: const Icon(
          Icons.task,
          size: 40,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _joinDialogBuilder(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const TextUtil(
            text: 'Would you like to join into this pardna?',
            color: Colors.black,
            size: 15,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Yes'),
              onPressed: () {
                ProjectService.addProjectMember(globals.userInfo['_id'],
                        globals.projectInfo['_id'], 'joining')
                    .then((res) =>
                        {if (res.statusCode == 200) getProjectMembers()});
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _acceptDialogBuilder(BuildContext context, int index) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          title: const TextUtil(
            text:
                'This pardna\'s owner has invited you.\nWould you like to accept this invitation?',
            color: Colors.black,
            size: 15,
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Deny'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Accept'),
              onPressed: () {
                ProjectService.updateProjectMember(globals.projectInfo['_id'],
                        members[index]['_id'], 'active')
                    .then((res) => {
                          if (res.statusCode == 200)
                            setState(() {
                              members[index]['status'] = 'active';
                            })
                        });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
