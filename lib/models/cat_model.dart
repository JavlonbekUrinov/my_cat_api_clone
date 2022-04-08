import 'dart:convert';

List<Cat> catListFromJson(String str) => List<Cat>.from(json.decode(str).map((x) => Cat.fromJson(x)));

class Cat {
  Cat({
    required this.breeds,
    required this.id,
    required this.url,
    required this.width,
    required this.height,
  });

  List<dynamic> breeds;
  String id;
  String url;
  int width;
  int height;

  factory Cat.fromJson(Map<String, dynamic> json) => Cat(
    breeds: List<dynamic>.from(json["breeds"].map((x) => x
    )),
    id: json["id"],
    url: json["url"],
    width: json["width"],
    height: json["height"],
  );

  Map<String, dynamic> toJson() => {
    "breeds": List<dynamic>.from(breeds.map((x) => x)),
    "id": id,
    "url": url,
    "width": width,
    "height": height,
  };
}
