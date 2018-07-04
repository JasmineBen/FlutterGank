import 'package:gank/data/GankDataType.dart';

class GankUtils{

  static String parseGankDataType(GankDataType type){
         switch(type){
        case GankDataType.DATA_TYPE_ALL:
          return 'all';
        case GankDataType.DATA_TYPE_ANDROID:
          return 'Android';
        case GankDataType.DATA_TYPE_IOS:
          return 'iOS';
        case GankDataType.DATA_TYPE_BREAK_VIDEO:
          return '休息视频';
          case GankDataType.DATA_TYPE_EXPAND_RESOURCE:
          return '拓展资源';
        case GankDataType.DATA_TYPE_FRONT:
          return '前端';
        case GankDataType.DATA_TYPE_WELFARE:
          return '福利';
     }
     return null;
  }

  static int getPageIndex(int count,int pageSize){
    if(count <= 0){
      return 1;
    }
    return (count/pageSize).floor() + 1;
  }
}