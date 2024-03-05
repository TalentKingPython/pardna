import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:http/http.dart';
import 'package:flutter/material.dart';

import 'package:pardna/screens/home.dart';
import 'package:pardna/utils/network.dart';
import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';

import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class AddProject extends StatefulWidget {
  const AddProject({super.key});

  @override
  State<AddProject> createState() => _AddProjectState();
}

class _AddProjectState extends State<AddProject> {
  final ExpansionTileController controller = ExpansionTileController();
  final TextEditingController _nameController = TextEditingController();
  DateTime? _startDate;
  String? duration;
  int numberOfMember = 0;
  double handAmount = 0;

  String durationMode(String? duration) {
    final Map<String, String> durationMap = {
      'Daily': 'days',
      'Weekly': 'weeks',
      'Monthly': 'months',
      'Yearly': 'years',
    };

    return durationMap[duration ?? ''] ?? '-';
  }

  DateTime getEndDate(DateTime start, String? duration, int numberOfMember) {
    switch (duration) {
      case 'Daily':
        return start.add(Duration(days: numberOfMember));
      case 'Weekly':
        return start.add(Duration(days: numberOfMember * 7));
      case 'Monthly':
        return DateTime(start.year, start.month + numberOfMember, start.day);
      case 'Yearly':
        return DateTime(start.year + numberOfMember, start.month, start.day);
      default:
        return start;
    }
  }

  Future<Response> addNewProject() {
    final response = ProjectService.addNewProject(
      _nameController.text,
      handAmount.toString(),
      numberOfMember.toString(),
      _startDate?.toIso8601String(),
      duration,
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
              Container(
                height: 700,
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: TextUtil(
                          text: 'Create New Pardna',
                          size: 25,
                          color: Colors.black,
                          weight: true,
                        ),
                      ),
                      const SizedBox(height: 15),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: TextUtil(
                          text: 'Project name',
                          size: 17,
                          color: Colors.black,
                          weight: true,
                        ),
                      ),
                      Container(
                        height: 48,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          controller: _nameController,
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            hintText: 'Enter name for new pardna...',
                            hintStyle: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.w200,
                            ),
                            fillColor: Colors.black,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: TextUtil(
                          text: 'Hand amount [\$]',
                          size: 17,
                          color: Colors.black,
                          weight: true,
                        ),
                      ),
                      Container(
                        height: 48,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                            style: const TextStyle(color: Colors.black),
                            decoration: const InputDecoration(
                              hintText: 'Enter value of hand amount...',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontWeight: FontWeight.w200,
                              ),
                              fillColor: Colors.black,
                              border: InputBorder.none,
                            ),
                            onChanged: (value) {
                              setState(() {
                                try {
                                  handAmount = double.parse(value);
                                } catch (e) {
                                  handAmount = 0;
                                }
                              });
                            }),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: TextUtil(
                          text: 'Expected Number of members',
                          size: 15,
                          color: Colors.black,
                          weight: true,
                        ),
                      ),
                      Container(
                        height: 48,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextFormField(
                          initialValue: '0',
                          style: const TextStyle(color: Colors.black),
                          decoration: const InputDecoration(
                            fillColor: Colors.black,
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            setState(() {
                              try {
                                numberOfMember = int.parse(value);
                              } catch (e) {
                                numberOfMember = 0;
                              }
                            });
                          },
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: TextUtil(
                          text: 'Period',
                          size: 15,
                          color: Colors.black,
                          weight: true,
                        ),
                      ),
                      Container(
                        height: 48,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: TextButton(
                          onPressed: () {
                            _selectDate(context);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _startDate != null
                                  ? Row(
                                      children: [
                                        Text(
                                          DateFormat('yyyy-MM-dd')
                                              .format(_startDate!),
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        const Text(
                                          '  to  ',
                                          style: TextStyle(
                                            color: Colors.green,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                        Text(
                                          DateFormat('yyyy-MM-dd').format(
                                              getEndDate(_startDate!, duration,
                                                  numberOfMember)),
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        )
                                      ],
                                    )
                                  : const Text(
                                      'Choose Start Date...',
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                              const Icon(
                                Icons.calendar_today,
                                color: Colors.green,
                              ),
                            ],
                          ),
                        ),
                      ),
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: TextUtil(
                          text: 'Payment/Draw Cycle',
                          size: 15,
                          color: Colors.black,
                          weight: true,
                        ),
                      ),
                      Container(
                        height: 48,
                        margin: const EdgeInsets.symmetric(vertical: 10),
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: DropdownButton<String>(
                          selectedItemBuilder: (context) {
                            return <String>[
                              'Daily',
                              'Weekly',
                              'Monthly',
                              'Yearly'
                            ].map<Padding>((String value) {
                              return Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 13),
                                  child: TextUtil(
                                    text: value,
                                    color: Colors.black,
                                  ));
                            }).toList();
                          },
                          value: duration,
                          onChanged: (String? newValue) {
                            setState(() {
                              duration = newValue!;
                            });
                          },
                          hint: const Text(
                            'Choose one of choises...',
                            style: TextStyle(fontWeight: FontWeight.w200),
                          ),
                          items: <String>[
                            'Daily',
                            'Weekly',
                            'Monthly',
                            'Yearly'
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Align(
                                alignment: Alignment.center,
                                child: TextUtil(
                                  text: value,
                                  size: 15,
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                          style: const TextStyle(color: Colors.black),
                          underline: Container(),
                          icon: const Icon(Icons.arrow_drop_down),
                          isExpanded: true,
                        ),
                      ),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          border: Border.all(
                              width: 2, color: Colors.green.withOpacity(0.5)),
                        ),
                        child: Row(
                          children: [
                            const SizedBox(
                              width: 80,
                              height: 80,
                              child:
                                  Icon(Icons.auto_awesome, color: Colors.green),
                            ),
                            SizedBox(
                              width: 360,
                              child: Wrap(
                                spacing: 5,
                                children: [
                                  Text(
                                      'In $numberOfMember ${durationMode(duration)}, with'),
                                  Text(
                                    '$numberOfMember',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const Text('members,'),
                                  Text(
                                    '\$$handAmount',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const Text('will'),
                                  const Text('be'),
                                  const Text('debited'),
                                  const Text('from'),
                                  const Text('every draw, You\'ll earn'),
                                  const Text('a total of'),
                                  Text(
                                    '\$${(handAmount * numberOfMember).toStringAsFixed(2)} ',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green,
                                    ),
                                  ),
                                  const Text('by '),
                                  const Text('the end '),
                                  const Text('of this Pardna.'),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        child: Container(
                          height: 55,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          alignment: Alignment.center,
                          child: const TextUtil(
                            text: "CREATE",
                            size: 17,
                            color: Colors.white,
                            weight: true,
                          ),
                        ),
                        onTap: () async {
                          final response = await addNewProject();
                          if (!context.mounted) return;
                          if (response.statusCode == 200) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const HomePage(pageIndex: 1),
                              ),
                            );
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
                        },
                      ),
                    ],
                  ),
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
        shape: const CircleBorder(),
        child: const Icon(
          Icons.task,
          size: 40,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final today = DateTime.now();
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(today.year, today.month, today.day),
      lastDate: DateTime(2100),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            primaryColor: Colors.green,
            colorScheme: const ColorScheme.light(primary: Colors.green),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null && pickedDate != _startDate) {
      setState(() {
        _startDate = pickedDate;
      });
    }
  }
}
