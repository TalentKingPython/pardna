import 'package:flutter/material.dart';
import 'package:pardna/screens/projects/addproject.dart';

import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';

class Project extends StatefulWidget {
  const Project({Key? key}) : super(key: key);

  @override
  State<Project> createState() => _ProjectState();
}

class _ProjectState extends State<Project> {
  final ExpansionTileController controller = ExpansionTileController();
  final List<String> items =
      List<String>.generate(20, (index) => 'Item $index');

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
                  for (int i = 0; i < items.length; i++)
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
                            title: const Row(
                              children: [
                                Icon(Icons.person_outlined,
                                    size: 22, color: Colors.green),
                                SizedBox(width: 8),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextUtil(
                                      text: 'Fab2024',
                                      color: Colors.black,
                                      weight: true,
                                      size: 15,
                                    ),
                                    TextUtil(
                                      text: '0 / 1 Weeks',
                                      color: Colors.green,
                                      size: 12,
                                    ),
                                  ],
                                )
                              ],
                            ),
                            children: [
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 20),
                                child: Column(
                                  children: [
                                    Divider(height: 5),
                                    SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.calendar_today_rounded,
                                            color: Colors.green, size: 15),
                                        TextUtil(
                                          text: '  From ',
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                        TextUtil(
                                          text: '12.02.2024',
                                          weight: true,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                        TextUtil(
                                          text: ' to ',
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                        TextUtil(
                                          text: '12.02.2024',
                                          weight: true,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.groups,
                                            color: Colors.green, size: 15),
                                        TextUtil(
                                          text: '  Has ',
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                        TextUtil(
                                          text: '2',
                                          weight: true,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                        TextUtil(
                                          text: ' members',
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(
                                          size: 15,
                                          Icons.task,
                                          color: Colors.green,
                                        ),
                                        SizedBox(width: 5),
                                        TextUtil(
                                          text: '\$50',
                                          weight: true,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                        TextUtil(
                                          text: ' per participant ',
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                        TextUtil(
                                          text: 'Weekly',
                                          weight: true,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Icon(Icons.web_stories_outlined,
                                            color: Colors.green, size: 15),
                                        TextUtil(
                                          text:
                                              '  Total from pardna per participant ',
                                          size: 14,
                                          color: Colors.black,
                                        ),
                                        TextUtil(
                                          text: '100',
                                          weight: true,
                                          size: 14,
                                          color: Colors.green,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 8),
                                    Divider(height: 5),
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
                                      onPressed: () {},
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
                                      onPressed: () {},
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
