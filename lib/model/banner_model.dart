class BannerModel{
  String? image;
  String? url;

  BannerModel({this.image,this.url});

  factory BannerModel.fromJson(Map<String, dynamic> json)=>BannerModel(
    image: json['image'],
    url: json['url'],
  );

  toJson() => {
    'image': image,
    'url': url,
  };
}