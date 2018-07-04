import 'package:flutter/material.dart';
import 'package:gank/pages/WelfarePage.dart';
import 'package:gank/pages/MainTabPage.dart';
import 'package:gank/data/GankDataType.dart';

class HomePage extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return new _HomeState();
  }
}

class _HomeState extends State<HomePage> with SingleTickerProviderStateMixin{
  var _whiteTextStyle = new TextStyle(color: Colors.white);
  var _tabBarTitles = ['Android', '  iOS  ', '拓展资源', '  前端  ', '休息视频'];
  TabBar _tabBar;
  TabBarView _tabBarView;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _initData();
  }

  UserAccountsDrawerHeader _getDrawerHeader() {
    return new UserAccountsDrawerHeader(
      accountName: new Text('pyzhou', style: _whiteTextStyle),
      accountEmail: new Text('zhoupeiyuan8@gmail.com', style: _whiteTextStyle),
      currentAccountPicture: new CircleAvatar(
          backgroundImage: AssetImage('images/navigation_header.jpg')),
      decoration: new BoxDecoration(
          image: new DecorationImage(
              fit: BoxFit.fill, image: new AssetImage('images/lake.jpg'))),
    );
  }

  ListTile _getDrawerWelfareItem() {
    return new ListTile(
        title: new Text('福利图片'),
        onTap: () {
          Navigator.of(context).pop();
          Navigator.of(context).push(new MaterialPageRoute(builder: (context) {
            return new WelfarePage();
          }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('FlutterGank',style: _whiteTextStyle),
        bottom: _tabBar,
        iconTheme: IconThemeData(color: Colors.white)    
      ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget>[_getDrawerHeader(), _getDrawerWelfareItem()],
        )
      ),
      body: _tabBarView,
    );
  }

  void _initData() {
    print('initData');

    if(_tabController == null){
      _tabController = new TabController(
        vsync: this, //动画效果异步处理
        length: this._tabBarTitles.length //tab个数
      );
    }

    if (_tabBar == null) {//标签标题
      List<Tab> tabs = new List();
      for(int i = 0;i<_tabBarTitles.length;i++){
       tabs.add(new Tab(
         child: new Text(_tabBarTitles[i],style: new TextStyle(color: Colors.white,fontSize: 16.0))
       ));
      }
      _tabBar = new TabBar(
        controller: _tabController,
        tabs: tabs,
        isScrollable: true,
        indicatorColor: const Color(0xFFFF5252),
      );
    }

    if(_tabBarView == null){
      _tabBarView = new TabBarView(
        controller: _tabController,
        children: <Widget>[
          new MainTabPage(GankDataType.DATA_TYPE_ANDROID),
          new MainTabPage(GankDataType.DATA_TYPE_IOS),
          new MainTabPage(GankDataType.DATA_TYPE_EXPAND_RESOURCE),
          new MainTabPage(GankDataType.DATA_TYPE_FRONT),
          new MainTabPage(GankDataType.DATA_TYPE_BREAK_VIDEO),
        ],
      );
    }
    
  }

  @override
  void dispose() {
    if(_tabController != null){
      _tabController.dispose();
    }
    super.dispose();
  }
}
