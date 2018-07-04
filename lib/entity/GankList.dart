import 'GankEntity.dart';
import 'package:gank/data/GankDataType.dart';
import 'dart:convert';

class GankList{
  bool error;
  List<GankEntity> results;
  GankDataType type;

  GankList(GankDataType type){
    this.type = type;
    this.results = new List<GankEntity>();
  }

  int size(){
    return results == null ? 0 : results.length;
  }

  int parseAndAddResult(var response,bool bRefresh){
    Map<String, dynamic> map = JSON.decode(response);
    int added = 0;
    if(!map['error'] && map['results'] != null){
      if(bRefresh){
        results.clear();
      }
      List list = map['results'];
      for(int i = 0;i < list.length;i++){
        results.add(GankEntity.parse(list[i]));
        added ++;
      }
    }
    return added;
  }
}