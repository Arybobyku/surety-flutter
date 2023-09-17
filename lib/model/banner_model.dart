class BannerModel{
  String? image;
  String? url;
  String? text;
  String? buttonText;

  BannerModel({this.image,this.url, this.text, this.buttonText});

  factory BannerModel.fromJson(Map<String, dynamic> json)=>BannerModel(
    image: json['image'],
    url: json['url'],
    text: json['text'],
    buttonText: json['buttonText'],
  );

  toJson() => {
    'image': image,
    'url': url,
    'text': text,
    'buttonText': buttonText,
  };
}