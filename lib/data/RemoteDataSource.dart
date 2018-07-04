import 'dart:io';
import 'dart:convert';

class RemoteDataSource{

  static final String BASE_URL = 'http://gank.io/api/';

  static void get(String url,Function callback,{Map<String,String> params,Function errorCallback}) async{
    if(params != null && params.isNotEmpty){
      StringBuffer sb = new StringBuffer('?');
      params.forEach((key,value){
        sb.write('$key' + '=' + '$value' + '&');
      });
      String paramStr = sb.toString();
      paramStr = paramStr.substring(0,paramStr.length - 1);
      url += paramStr;
    }

    var exception = null;
    try{
      print("getUrl:"+url);
      var httpClient = new HttpClient();
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if(callback != null){
        if(response.statusCode == HttpStatus.OK){
          var json = await response.transform(UTF8.decoder).join();
          callback(json);
        }else {
          exception = new Exception('getUrl:'+url+' failed');
        }
      } 
    }catch(e){
      exception = e;
    }
    if(exception != null && errorCallback != null){
      errorCallback(exception);
    }
  }
}