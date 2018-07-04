import 'package:flutter/material.dart';
import 'package:gank/data/GankDataType.dart';
import 'package:gank/entity/GankList.dart';
import 'package:gank/entity/GankEntity.dart';
import 'package:gank/data/GankContainer.dart';
import 'package:gank/utils/GankUtils.dart';
import 'package:gank/data/RemoteDataSource.dart';
import 'dart:async';
import 'package:flutter/services.dart';


class MainTabPage extends StatefulWidget {
  GankDataType _dataType;

  MainTabPage(this._dataType);

  @override
  State<StatefulWidget> createState() {
    return new _MainTabState(this._dataType);
  }
}

class _MainTabState extends State<MainTabPage> {
  TextStyle _titleTextStyle = new TextStyle(fontSize: 15.0);
  TextStyle _subtitleStyle = new TextStyle(color: const Color(0xFFB5BDC0), fontSize: 12.0);
  GankDataType _dataType;
  String _dataTypeString;
  GankList _gankList;
  ScrollController _controller;
  static const int PAGE_SIZE = 15;
  bool hasMore = true;
  static const _platform = const MethodChannel('app.channel.openbrowser');

  _MainTabState(GankDataType type){
    this._dataType = type;
    _dataTypeString = GankUtils.parseGankDataType(type);
    GankContainer container = new GankContainer();
    _gankList = container.getGankList(_dataType);
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
  void dispose() {
    _controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    if(_gankList.size() == 0){
      return new Center(
       child: new CircularProgressIndicator()
      );
    }else{
      List<GankEntity> result = _gankList.results;
      Widget listView = new ListView.builder(
        itemCount: result.length,
        itemBuilder: (context,i)=>renderRow(result[i]),
        controller: _controller,
      );
      return new RefreshIndicator(child: listView,onRefresh: _pullToRefresh);
    }
  }

  Widget renderRow(GankEntity entity){
    var titleRow = _buildTitleWidget(entity);
    var subTitleRow = _buildSubTitleWidget(entity);
    var imageRow = _buildImageWidget(entity);     
    List<Widget> childs = [_buildFirstColumn(titleRow, subTitleRow)];
    
    if(imageRow != null){
      var imageView = new Padding(
          padding: const EdgeInsets.all(6.0),
          child:imageRow
        );
      childs.add(imageView);
    }
    var item = new Row(
      children: childs
    );

    return new Card(
      child: new InkWell(
         child: item,
         onTap: (){
            _showDetail(entity);
         }
      )
    );
  }

  Widget _buildTitleWidget(GankEntity entity){
    return new Row(
      children: <Widget>[
        new Expanded(
          child: new Text(entity.desc,style: _titleTextStyle),
        )
      ],
    );
  }

  Widget _buildSubTitleWidget(GankEntity entity){
    return new Row(
      children: <Widget>[
        new Expanded(
          flex: 1,
          child: new Text('来自：'+entity.who,style: _subtitleStyle),
        ),
        new Text(entity.publishedAt.substring(0,10),style: _subtitleStyle)
      ],
    );
  }

  Widget _buildImageWidget(GankEntity entity){
    var thumb = null;
    if(entity.images != null){
      List images = entity.images;
      if(images != null && images.length > 0){
        thumb = images[0];
      }
    }
    if(thumb != null){
     return new Image.network(
        thumb,
        width: 72.0,
        height: 72.0
      );
    }
    return null;
  }

  Widget _buildFirstColumn(Widget title,Widget subTitle){
    return new Expanded(
          flex: 1,
          child: new Padding(
            padding: const EdgeInsets.all(10.0),
            child: new Column(
              children: <Widget>[
                title,
                new Padding(
                  padding: const EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 0.0),
                  child: subTitle,
                )
              ],
            ),
          ),
        );
  }

  void _showDetail(GankEntity entity) async{
    print('_showDetail');
    Map argument = new Map();
    argument['url'] = entity.url;
    var result = _platform.invokeMethod('openBrowser',argument);
    print('_showDetail result:$result');
  }

  Future<Null> _pullToRefresh() async{
    _loadData(true);
    return null;
  }

  _loadData(bool bRefresh){
    print('loadData bRefresh=$bRefresh');
    StringBuffer baseUrl = new StringBuffer(RemoteDataSource.BASE_URL);
    baseUrl.write('data/');
    baseUrl.write(_dataTypeString + '/');
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
}
