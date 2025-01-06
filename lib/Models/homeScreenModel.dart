import 'dart:convert';

HomeScreenModel homeScreenModelFromJson(String str) =>
    HomeScreenModel.fromJson(json.decode(str));

String homeScreenModelToJson(HomeScreenModel data) =>
    json.encode(data.toJson());

class HomeScreenModel {
  String id;
  String title;
  String titleAr;
  String kilometers;
  String price;
  String year;
  String photo;

  HomeScreenModel({
    required this.id,
    required this.title,
    required this.titleAr,
    required this.kilometers,
    required this.price,
    required this.year,
    required this.photo,
  });

  factory HomeScreenModel.fromJson(Map<String, dynamic> json) =>
      HomeScreenModel(
        id: json["id"] ?? 'N/A',
        title: json["title"] ?? 'N/A',
        titleAr: json["title_ar"] ?? 'N/A',
        kilometers: json["kilometers"] ?? 'N/A',
        price: json["price"] ?? 'N/A',
        year: json["year"] ?? 'N/A',
        photo: json["photo"] ?? 'N/A',
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "title_ar": titleAr,
        "kilometers": kilometers,
        "price": price,
        "year": year,
        "photo": photo,
      };
}
