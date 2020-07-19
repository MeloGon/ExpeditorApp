// To parse this JSON data, do
//
//     final materialModel = materialModelFromJson(jsonString);

import 'dart:convert';

MaterialModel materialModelFromJson(String str) =>
    MaterialModel.fromJson(json.decode(str));

String materialModelToJson(MaterialModel data) => json.encode(data.toJson());

class MaterialModel {
  MaterialModel({
    this.id,
    this.codigo,
    this.descripcion,
    this.lugar,
    this.ubicacion,
    this.cantNecesaria,
    this.cantReteirada,
    this.cantEntregada,
    this.puntoAcopio,
    this.notas,
    this.chequeoSa,
    this.estado,
    this.incidencia,
  });

  int id;
  String codigo;
  String descripcion;
  String lugar;
  String ubicacion;
  int cantNecesaria;
  int cantReteirada;
  int cantEntregada;
  String puntoAcopio;
  String notas;
  dynamic chequeoSa;
  Estado estado;
  Estado incidencia;

  factory MaterialModel.fromJson(Map<String, dynamic> json) => MaterialModel(
        id: json["id"],
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        lugar: json["lugar"],
        ubicacion: json["ubicacion"],
        cantNecesaria: json["cant_necesaria"],
        cantReteirada: json["cant_reteirada"],
        cantEntregada: json["cant_entregada"],
        puntoAcopio: json["punto_acopio"],
        notas: json["notas"],
        chequeoSa: json["chequeo_sa"],
        estado: Estado.fromJson(json["estado"]),
        incidencia: Estado.fromJson(json["incidencia"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "codigo": codigo,
        "descripcion": descripcion,
        "lugar": lugar,
        "ubicacion": ubicacion,
        "cant_necesaria": cantNecesaria,
        "cant_reteirada": cantReteirada,
        "cant_entregada": cantEntregada,
        "punto_acopio": puntoAcopio,
        "notas": notas,
        "chequeo_sa": chequeoSa,
        "estado": estado.toJson(),
        "incidencia": incidencia.toJson(),
      };
}

class Estado {
  Estado({
    this.descripcion,
  });

  String descripcion;

  factory Estado.fromJson(Map<String, dynamic> json) => Estado(
        descripcion: json["descripcion"],
      );

  Map<String, dynamic> toJson() => {
        "descripcion": descripcion,
      };
}
