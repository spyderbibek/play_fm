import 'dart:convert';

List<RadioModel> radioModelFromJson(String str) =>
    List<RadioModel>.from(json.decode(str).map((x) => RadioModel.fromJson(x)));

String radioModelToJson(List<RadioModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class RadioModel {
  String name;
  String link;
  String image;

  RadioModel({
    this.name,
    this.link,
    this.image,
  });

  factory RadioModel.fromJson(Map<String, dynamic> json) => RadioModel(
        name: json["name"],
        link: json["link"],
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "link": link,
        "image": image,
      };
}
