import 'package:flutter/material.dart';

import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';

class Member extends StatefulWidget {
  const Member({Key? key}) : super(key: key);

  @override
  State<Member> createState() => _MemberState();
}

class _MemberState extends State<Member> {
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
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      for (int index = 0; index < items.length; index++)
                        const Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 25, // Image radius
                                  backgroundImage: NetworkImage(
                                      'https://app.idonethis.com/api/users/download-avatar/user/124382'),
                                ),
                                SizedBox(width: 15),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextUtil(
                                      height: 25,
                                      text: 'YuryB',
                                      size: 15,
                                      color: Colors.black,
                                    ),
                                    TextUtil(
                                      height: 20,
                                      text: '+15705932206',
                                      size: 13,
                                      color: Colors.grey,
                                    ),
                                    TextUtil(
                                      height: 20,
                                      text: 'lucky.godness.tan@gmail.com',
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
                  text: "Input member details",
                  color: Colors.white,
                  weight: true,
                ),
              ),
              onPressed: () {},
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
              onPressed: () {},
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
