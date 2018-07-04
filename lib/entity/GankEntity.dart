class GankEntity{
  String id;
  String createAt;
  String desc;
  String type;
  String publishedAt;
  String source;
  String url;
  bool used;
  String who;
  List images;

  GankEntity(this.id,this.createAt,this.desc,this.type,this.publishedAt,this.source,this.url,this.used,this.who,this.images);

  static GankEntity parse(var json){
    return new GankEntity(json['id'], json['createAt'], json['desc'], json['type'], 
     json['publishedAt'], json['source'], json['url'], json['used'], json['who'], json['images']);
  }

}