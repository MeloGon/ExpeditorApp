// To parse this JSON data, do
//
//     final incidenciaModel = incidenciaModelFromJson(jsonString);

import 'dart:convert';

IncidenciaModel incidenciaModelFromJson(String str) =>
    IncidenciaModel.fromJson(json.decode(str));

String incidenciaModelToJson(IncidenciaModel data) =>
    json.encode(data.toJson());

class IncidenciaModel {
  IncidenciaModel({
    this.id,
    this.descripcion,
    this.color,
  });

  int id;
  String descripcion;
  String color;

  factory IncidenciaModel.fromJson(Map<String, dynamic> json) =>
      IncidenciaModel(
        id: json["id"],
        descripcion: json["descripcion"],
        color: json["color"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "descripcion": descripcion,
        "color": color,
      };
}
