import 'package:flutter/material.dart';
import 'package:gank/data/GankDataType.dart';
import 'package:gank/entity/GankList.dart';
import 'package:gank/entity/GankEntity.dart';
import 'package:gank/utils/GankUtils.dart';
import 'package:gank/data/GankContainer.dart';
import 'package:gank/data/RemoteDataSource.dart';
import 'dart:async';
import 'GridPhotoViewer.dart';

class WelfarePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WelfareState();
  }
}

class WelfareState extends State<WelfarePage> {

  GankList _gankList;
  ScrollController _controller;
  static const int PAGE_SIZE = 16;
  bool hasMore = true;

  WelfareState(){
    GankContainer container = new GankContainer();
    _gankList = container.getGankList(GankDataType.DATA_TYPE_WELFARE);
    _controller = new ScrollController();
    _controller.addListener((){
      var maxScroll = _controller.position.maxScrollExtent;
      var pixels = _controller.position.pixels;
      // print('maxScroll:$maxScroll');
      // print('pixels:$pixels');
      if (maxScroll == pixels && hasMore){
        _loadData(false);
      }
    });
  }

  @override
    void initState() {
      super.initState();
      _loadData(true);
    }

  @override
  Widget build(BuildContext context) {
    AppBar appBar = new AppBar(title: new Text('福利图片',
          style: new TextStyle(color: Colors.white)),
          iconTheme: IconThemeData(color: Colors.white) 
    );
    if(_gankList.size() == 0){
      return new Scaffold(
        appBar: appBar,
        body: new Center(
          child: new CircularProgressIndicator()
        ),
      );
    }else{
      return new Scaffold(
        appBar: appBar,
        body: new RefreshIndicator(child: _buildGrid(),onRefresh: _pullToRefresh)
      );
    }  
  }

  Widget _buildGrid() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return new Column(
            children: <Widget>[
             new Expanded(
               child: new SafeArea(
                top: false,
                bottom: false,
                child: new GridView.count(
                  controller: _controller,
                  crossAxisCount: (orientation == Orientation.portrait) ? 2 : 3,
                  mainAxisSpacing: 4.0,
                  crossAxisSpacing: 4.0,
                  padding: const EdgeInsets.all(4.0),
                  childAspectRatio: (orientation == Orientation.portrait) ? 1.0 : 1.3,
                  children: _gankList.results.map((GankEntity entity) {
                  return new GridItemWidget(entity);
                }).toList(),
              ),
            ),
          ),
        ],
      );
  }

  Future<Null> _pullToRefresh() async{
    _loadData(true);
    return null;
  }

  void _loadData(bool bRefresh){
    print('loadData bRefresh=$bRefresh');
    StringBuffer baseUrl = new StringBuffer(RemoteDataSource.BASE_URL);
    baseUrl.write('data/');
    baseUrl.write(GankUtils.parseGankDataType(GankDataType.DATA_TYPE_WELFARE) + '/');
    baseUrl.write(PAGE_SIZE);
    baseUrl.write('/');
    if(bRefresh){//刷新第一页
      baseUrl.write('1');
    }else{//加载更多
      baseUrl.write(GankUtils.getPageIndex(_gankList.size(), PAGE_SIZE));
    }
    RemoteDataSource.get(baseUrl.toString(), (response){
      if(response != null){
        int added = _gankList.parseAndAddResult(response,bRefresh);
        print('welfare added:$added');
        setState(() {
           if(added < PAGE_SIZE){
             hasMore = false;
           }else{
             hasMore = true;
           }
        });
      }
    },errorCallback: (e){
      print('loadData error $e');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

}

class GridItemWidget extends StatelessWidget{
  final GankEntity entity;

  GridItemWidget(this.entity);

  @override
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: (){_showDetail(context);},
      child: new Image.network(entity.url,fit: BoxFit.cover),
    );
  }

  void _showDetail(BuildContext context){
    Navigator.push(context, new MaterialPageRoute<void>(
      builder: (BuildContext context) {
        return new Scaffold(
          appBar: new AppBar(
            title: new Text(entity.source,style: TextStyle(color: Colors.white)),
            iconTheme: IconThemeData(color: Colors.white)
          ),
          body: new SizedBox.expand(
            child: new Hero(
              tag: entity.url,
              child: new GridPhotoViewer(photo: entity),
            ),
          ),
        );
      }
    ));
  }

}
