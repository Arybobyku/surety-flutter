import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:surety/helper/color_palette.dart';
import 'package:surety/provider/auth.dart';
import 'package:surety/provider/form_provider.dart';
import 'package:surety/ui/user/diary/user_diary_page.dart';
import 'package:surety/ui/user/expert/user_expert_page.dart';
import 'package:surety/ui/user/home/user_home_page.dart';
import 'package:surety/ui/user/profile/user_profile_page.dart';

import 'community/user_community_page.dart';

class MainMenuPage extends StatefulWidget {
  const MainMenuPage({Key? key}) : super(key: key);

  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  int _selectedIndex = 2;
  bool getData = true;
  bool first = true;

  @override
  void initState() {
    if (getData) {
      context
          .read<FormProvider>()
          .getFormById(
            context.read<AuthProvider>().user,
          )
          .then((value) => Future.delayed(Duration(seconds: 1)).then(
                (value) {
                  Alert(
                    context: context,
                    type: AlertType.none,
                    content: Column(
                      children: [
                        Image.asset(
                          "images/cup.png",
                          height: 80,
                          width: 80,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Congratulation you get 1 point from daily login",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 18),
                        )
                      ],
                    ),
                    buttons: [
                      DialogButton(
                        child: Text(
                          "Close",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                        color: ColorPalette.generalPrimaryColor,
                        radius: BorderRadius.circular(0.0),
                      ),
                    ],
                  ).show();
                  first = false;
                },
              ));
      getData = false;
    }
    super.initState();
  }

  void _onItemTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static List<Widget> _pageption = <Widget>[
    UserCommunityPage(),
    UserExpertPage(),
    UserHomePage(),
    UserDiaryPage(),
    UserProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer<FormProvider>(builder: (context, stateForm, _) {
      return Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          backgroundColor: _selectedIndex == 2 ? Colors.white : Colors.grey,
          onPressed: () => _onItemTap(2),
          child: Image.asset(
            "images/pauseplay.png",
            height: 45,
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _selectedIndex,
          type: BottomNavigationBarType.fixed,
          backgroundColor: ColorPalette.generalPrimaryColor,
          selectedItemColor: ColorPalette.generalWhite,
          unselectedItemColor: Colors.black,
          onTap: (index) {
            _onItemTap(index);
          },
          items: [
            BottomNavigationBarItem(
              icon: Icon(
                Icons.groups,
              ),
              label: 'Community',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.psychology),
              label: 'Expert',
            ),
            BottomNavigationBarItem(icon: SizedBox(), label: ''),
            BottomNavigationBarItem(
              icon: Icon(Icons.bookmarks_rounded),
              label: 'Diary',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        ),
        body: SafeArea(
          child: _pageption[_selectedIndex],
        ),
      );
    });
  }
}
