import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomBar extends StatefulWidget {
  Function onTap;

  BottomBar({Key? key, required this.onTap}) : super(key: key);

  @override
  _BottomBarState createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  int currentPageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      backgroundColor: Color.fromRGBO(255, 255, 255, 0.95),
      onDestinationSelected: (int index) {
        setState(() => currentPageIndex = index);
        widget.onTap(index);
      },
      selectedIndex: currentPageIndex,
      destinations: const <Widget>[
        NavigationDestination(
          icon: Icon(Icons.article_outlined),
          selectedIcon: Icon(Icons.article),
          label: "动态",
        ),
        NavigationDestination(
          icon: Icon(Icons.topic_outlined),
          selectedIcon: Icon(Icons.topic),
          label: "话题",
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: "我",
        )
      ],
    );
  }
}
