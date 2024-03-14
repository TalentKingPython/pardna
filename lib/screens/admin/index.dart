import 'package:flutter/material.dart';
import 'package:pardna/screens/admin/awardedusers/index.dart';
import 'package:pardna/screens/admin/setuserroles.dart';
import 'package:pardna/screens/admin/tieroneusers.dart';
import 'package:pardna/screens/admin/tiertwousers.dart';

import 'package:pardna/screens/home.dart';
import 'package:pardna/screens/admin/adminusers.dart';
import 'package:pardna/utils/text_utils.dart';
import 'package:pardna/utils/headers.dart';
import 'package:pardna/utils/globals.dart';

import 'package:stylish_bottom_bar/model/bar_items.dart';
import 'package:stylish_bottom_bar/stylish_bottom_bar.dart';

class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
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
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: <Widget>[
                      const TextUtil(
                        text: 'Welcome to Admin Page',
                        size: 22,
                        color: Colors.black,
                        weight: true,
                        height: 60,
                      ),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextUtil(
                                text: 'Set Users\' Roles',
                                color: Colors.black,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const SetUserRoles(),
                                  ),
                                ),
                                child: const Icon(
                                  size: 25,
                                  Icons.arrow_forward,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      if (userInfo['roles'].contains('superadmin'))
                        Card(
                          elevation: 0,
                          color: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(12)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 15, horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const TextUtil(
                                  text: 'Admin Users',
                                  color: Colors.black,
                                ),
                                GestureDetector(
                                  onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const AdminUsers(),
                                    ),
                                  ),
                                  child: const Icon(
                                    size: 25,
                                    Icons.arrow_forward,
                                    color: Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextUtil(
                                text: 'Users (Tier2)',
                                color: Colors.black,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Tier2Users(),
                                  ),
                                ),
                                child: const Icon(
                                  size: 25,
                                  Icons.arrow_forward,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextUtil(
                                text: 'Users (Tier1)',
                                color: Colors.black,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Tier1Users(),
                                  ),
                                ),
                                child: const Icon(
                                  size: 25,
                                  Icons.arrow_forward,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Card(
                        elevation: 0,
                        color: Colors.white,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const TextUtil(
                                text: 'Awarded Users',
                                color: Colors.black,
                              ),
                              GestureDetector(
                                onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AwardedUsers(),
                                  ),
                                ),
                                child: const Icon(
                                  size: 25,
                                  Icons.arrow_forward,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
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
            icon: const Icon(Icons.groups),
            backgroundColor: Colors.black,
            title: const TextUtil(
              text: 'Member',
              size: 15,
              color: Colors.black,
              weight: true,
            ),
          ),
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
            icon: const Icon(Icons.task),
            backgroundColor: Colors.black,
            title: const TextUtil(
              text: 'Projects',
              size: 15,
              color: Colors.black,
              weight: true,
            ),
          ),
        ],
        hasNotch: true,
        onTap: (index) {
          switch (index) {
            case 1:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(pageIndex: 0),
                ),
              );
              break;
            case 0:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(pageIndex: 2),
                ),
              );
              break;
            case 2:
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const HomePage(pageIndex: 1),
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
          Icons.home,
          size: 40,
          color: Colors.black,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
