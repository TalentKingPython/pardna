import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pardna/screens/admin/index.dart';

import 'package:pardna/screens/landing.dart';
import 'package:pardna/screens/login.dart';
import 'package:pardna/screens/member/index.dart';
import 'package:pardna/screens/notification.dart';
import 'package:pardna/screens/profile/index.dart';
import 'package:pardna/screens/projects/index.dart';
import 'package:pardna/screens/stripe/index.dart';
import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/globals.dart';

import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class HomePage extends StatefulWidget {
  final int? pageIndex;
  const HomePage({super.key, this.pageIndex});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  PageController controller = PageController();

  List<IconData> iconList = <IconData>[
    Icons.home,
    Icons.task,
    Icons.groups,
  ];

  @override
  void initState() {
    super.initState();
    if (widget.pageIndex != null) _selectedIndex = widget.pageIndex!;
    controller = PageController(initialPage: _selectedIndex);
  }

  void _locateByFooter(int index) {
    if (index == 0) {
      _onItemTapped(_selectedIndex == 0 ? 1 : 0);
    } else if (index == 2) {
      _onItemTapped(_selectedIndex == 2 ? 1 : 2);
    }
  }

  void _onItemTapped(int index) {
    controller.jumpToPage(index);
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageView(
              controller: controller,
              children: const [
                Landing(),
                Project(),
                Member(),
              ],
              onPageChanged: (index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
            ),
            if (userInfo['roles'].contains('admin'))
              Positioned(
                bottom: 10,
                right: 10,
                child: GestureDetector(
                  child: const Row(
                    children: [
                      TextUtil(
                        text: 'Go to Admin Page',
                        color: Colors.green,
                      ),
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.green,
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const AdminPage(),
                      ),
                    );
                  },
                ),
              ),
            if (userInfo['payment_method'] != 'verified')
              Positioned(
                top: 90,
                right: 30,
                child: GestureDetector(
                  child: const Icon(
                    Icons.add_card_rounded,
                    color: Colors.green,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const StripeService(),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: StylishBottomBar(
        option: AnimatedBarOptions(iconSize: 40),
        backgroundColor: Colors.green,
        items: [
          BottomBarItem(
            icon: _selectedIndex == 0
                ? const Icon(Icons.task)
                : const Icon(Icons.home),
            backgroundColor: Colors.black,
            title: TextUtil(
              text: _selectedIndex == 0 ? 'Projects' : 'Home',
              size: 15,
              color: Colors.black,
              weight: true,
            ),
          ),
          BottomBarItem(
            icon: const Icon(Icons.home),
            backgroundColor: Colors.black,
            title: TextUtil(
              text: ['Home', 'Projects', 'Member'][_selectedIndex],
              size: 15,
              color: Colors.black,
              weight: true,
            ),
          ),
          BottomBarItem(
            icon: _selectedIndex == 2
                ? const Icon(Icons.task)
                : const Icon(Icons.groups),
            backgroundColor: Colors.black,
            title: TextUtil(
              text: _selectedIndex == 2 ? 'Projects' : 'Member',
              size: 15,
              color: Colors.black,
              weight: true,
            ),
          ),
        ],
        hasNotch: true,
        onTap: (index) {
          _locateByFooter(index);
        },
      ),
      floatingActionButton: FloatingActionButton(
        enableFeedback: false,
        onPressed: () {},
        backgroundColor: Colors.green,
        child: Icon(
          iconList[_selectedIndex],
          size: 40,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      drawer: SafeArea(
        child: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              SizedBox(
                height: 250,
                child: Column(children: [
                  const DrawerHeader(
                    child: CircleAvatar(
                      radius: 70, // Image radius
                      backgroundImage: NetworkImage(
                          'https://app.idonethis.com/api/users/download-avatar/user/124382'),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileDetail(),
                        ),
                      );
                    },
                    child: TextUtil(
                      text: userInfo['name'],
                      size: 28,
                      weight: false,
                      color: Colors.black,
                    ),
                  )
                ]),
              ),
              ListTile(
                title: TextUtil(
                  text: 'Home',
                  size: 24,
                  weight: false,
                  color: _selectedIndex == 0 ? Colors.blue : Colors.black,
                ),
                onTap: () {
                  _onItemTapped(0);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: TextUtil(
                  text: 'Projects',
                  size: 24,
                  color: _selectedIndex == 1 ? Colors.blue : Colors.black,
                ),
                onTap: () {
                  _onItemTapped(1);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: TextUtil(
                  text: 'Member',
                  size: 24,
                  color: _selectedIndex == 2 ? Colors.blue : Colors.black,
                ),
                onTap: () {
                  _onItemTapped(2);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: const TextUtil(
                  text: 'Notifications',
                  size: 24,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NotificationPardna(),
                    ),
                  );
                },
              ),
              ListTile(
                title: const TextUtil(
                  text: 'Sign out',
                  size: 24,
                  color: Colors.black,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const Login()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
