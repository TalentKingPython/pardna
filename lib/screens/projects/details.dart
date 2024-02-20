import 'package:intl/intl.dart';
import 'package:flutter/material.dart';

import 'package:pardna/screens/home.dart';
import 'package:pardna/screens/member/addcontacts.dart';
import 'package:pardna/screens/member/addmember.dart';
import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';
import 'package:pardna/utils/globals.dart' as globals;

import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class ProjectDetail extends StatefulWidget {
  const ProjectDetail({Key? key}) : super(key: key);

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
                      child: TextUtil(
                        text: 'Pardna ${globals.projectInfo['name']}',
                        size: 25,
                        color: Colors.black,
                        weight: true,
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
                                borderRadius: BorderRadius.circular(20)),
                            child: const Icon(
                              Icons.add,
                              color: Colors.black,
                            ),
                          ),
                          onPressed: () {},
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
                                        const Icon(
                                          Icons.person,
                                          color: Colors.white,
                                          size: 30,
                                        ),
                                        const SizedBox(width: 15),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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
                                    const Divider(),
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
                  builder: (context) => const HomePage(pageIndex: 1),
                ),
              );
              break;
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(pageIndex: 0),
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
                  text: "Add from phone's contacts book",
                  color: Colors.white,
                  weight: true,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AddContacts(),
                  ),
                );
              },
            ),
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
