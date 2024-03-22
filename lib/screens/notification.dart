import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:pardna/utils/network.dart';
import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';

class NotificationPardna extends StatefulWidget {
  const NotificationPardna({super.key});

  @override
  State<NotificationPardna> createState() => _NotificationPardnaState();
}

class _NotificationPardnaState extends State<NotificationPardna> {
  final ExpansionTileController controller = ExpansionTileController();
  List<dynamic> notifications = [];

  @override
  void initState() {
    super.initState();
    getAllNotifications();
  }

  void getAllNotifications() {
    NotificationService.getAllNotificationsByUserId()
        .then((res) => setState(() {
              notifications = jsonDecode(res.body)['data'];
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
                padding: const EdgeInsets.all(15),
                child: Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 70,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: TextUtil(
                              text: "Notifications",
                              color: Colors.black,
                              weight: true,
                              size: 20,
                            ),
                          ),
                        ),
                        for (int i = 0; i < notifications.length; i++)
                          Column(
                            children: [
                              Card(
                                elevation: 0,
                                color: Colors.white,
                                shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12)),
                                ),
                                child: ExpansionTile(
                                  title: Row(
                                    children: [
                                      const Icon(Icons.notifications,
                                          size: 22, color: Colors.green),
                                      const SizedBox(width: 8),
                                      Text(notifications[i]['title'])
                                    ],
                                  ),
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 20),
                                      child: Text(notifications[i]['content']),
                                    ),
                                    Row(
                                      children: [
                                        const Spacer(),
                                        GestureDetector(
                                          onTap: () {
                                            NotificationService
                                                .checkNotificationById(
                                                    notifications[i]['_id']);
                                          },
                                          child: const Row(
                                            children: [
                                              Icon(
                                                Icons.check,
                                                color: Colors.green,
                                              ),
                                              Text('Checked'),
                                            ],
                                          ),
                                        ),
                                        const SizedBox(width: 20)
                                      ],
                                    ),
                                    const SizedBox(height: 8)
                                  ],
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
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
