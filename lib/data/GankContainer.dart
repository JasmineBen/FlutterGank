import 'package:gank/entity/GankList.dart';
import 'package:gank/data/GankDataType.dart';

class GankContainer{
    GankList all = new GankList(GankDataType.DATA_TYPE_ALL);//全部
    GankList android = new GankList(GankDataType.DATA_TYPE_ANDROID);//android
    GankList ios = new GankList(GankDataType.DATA_TYPE_IOS);//ios
    GankList welfare = new GankList(GankDataType.DATA_TYPE_WELFARE);//福利
    GankList breakVideo = new GankList(GankDataType.DATA_TYPE_BREAK_VIDEO);//休息视频
    GankList expandResource = new GankList(GankDataType.DATA_TYPE_EXPAND_RESOURCE);//拓展资源
    GankList front = new GankList(GankDataType.DATA_TYPE_FRONT);//前端

    GankList getGankList(GankDataType type) {
     switch(type){
        case GankDataType.DATA_TYPE_ALL:
          return all;
        case GankDataType.DATA_TYPE_ANDROID:
          return android;
        case GankDataType.DATA_TYPE_IOS:
          return ios;
        case GankDataType.DATA_TYPE_BREAK_VIDEO:
          return breakVideo;
          case GankDataType.DATA_TYPE_EXPAND_RESOURCE:
          return expandResource;
        case GankDataType.DATA_TYPE_FRONT:
          return front;
        case GankDataType.DATA_TYPE_WELFARE:
          return welfare;
     }
     return null;
    }
}