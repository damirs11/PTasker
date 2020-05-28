import 'package:PTasker/screens/new_design/project/project_list.dart';
import 'package:PTasker/screens/new_design/settings/settings.dart';
import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 1;
  PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavyBar(
        onItemSelected: onTabTapped,
        selectedIndex: _currentIndex,
        showElevation: true,
        items: [
          BottomNavyBarItem(
            icon: new Icon(FontAwesomeIcons.calendarCheck),
            title: new Text("Сданы"),
            activeColor: Colors.green,
          ),
          BottomNavyBarItem(
            icon: new Icon(FontAwesomeIcons.calendar),
            title: new Text("В процессе"),
            activeColor: Colors.amber,
          ),
          BottomNavyBarItem(
            icon: new Icon(FontAwesomeIcons.slidersH),
            title: new Text("Настройки"),
            activeColor: Colors.black,
          )
        ],
      ),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: [
            ProjectList(),
            ProjectList(),
            Settings(),
          ],
        ),
      ),
      // body: _children[_currentIndex],
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: Duration(milliseconds: 300), curve: Curves.easeInQuad);
    });
  }
}
