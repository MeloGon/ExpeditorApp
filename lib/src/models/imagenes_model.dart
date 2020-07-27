// To parse this JSON data, do
//
//     final imagenModel = imagenModelFromJson(jsonString);

import 'dart:convert';

ImagenModel imagenModelFromJson(String str) =>
    ImagenModel.fromJson(json.decode(str));

String imagenModelToJson(ImagenModel data) => json.encode(data.toJson());

class ImagenModel {
  ImagenModel({
    this.id,
    this.url,
    this.descripcion,
    this.peso,
    this.ancho,
    this.alto,
  });
  int id;
  String url;
  String descripcion;
  int peso;
  int ancho;
  int alto;

  factory ImagenModel.fromJson(Map<String, dynamic> json) => ImagenModel(
        id: json["id"],
        url: json["url"],
        descripcion: json["descripcion"],
        peso: json["peso"],
        ancho: json["ancho"],
        alto: json["alto"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "descripcion": descripcion,
        "peso": peso,
        "ancho": ancho,
        "alto": alto,
      };
}
