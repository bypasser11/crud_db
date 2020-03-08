import 'package:crud_db/app/home/account/account_page.dart';
import 'package:crud_db/app/home/cupertino_home_scaffold.dart';
import 'package:crud_db/app/home/entries/entries_page.dart';
import 'package:crud_db/app/home/jobs/jobs_page.dart';
import 'package:crud_db/app/home/tab_item.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs : GlobalKey<NavigatorState>(),
    TabItem.entries : GlobalKey<NavigatorState>(),
    TabItem.account : GlobalKey<NavigatorState>(),
  };

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async => !await navigatorKeys[_currentTab].currentState.maybePop(),
          child: CupertinoHomeScaffold(
        navigatorKeys: navigatorKeys,
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
      ),
    );
  }


  //Rebuild page when new tab is selected
  void _select(TabItem tabItem) {
    if(tabItem == _currentTab){
      //pop to first route
      navigatorKeys[tabItem].currentState.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

//Maps of pages for the build widget in cupertino home scaffold
    Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs : (_) => JobsPage(),
      TabItem.entries : (context) => EntriesPage.create(context),
      TabItem.account : (_) => AccountPage(),
    };
  }
}
