import 'dart:convert';

List<RadioModel> radioModelFromJson(String str) =>
    List<RadioModel>.from(json.decode(str).map((x) => RadioModel.fromJson(x)));

String radioModelToJson(List<RadioModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RadioModel {
  String name;
  String image;
  String link;

  RadioModel({
    this.name,
    this.image,
    this.link,
  });

  factory RadioModel.fromJson(Map<String, dynamic> json) => RadioModel(
        name: json["name"],
        image: json["image"],
        link: json["link"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "image": image,
        "link": link,
      };
}
