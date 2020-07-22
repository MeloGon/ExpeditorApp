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
    this.unidad,
    this.chequeoSap,
    this.cantNecesaria,
    this.cantRetirada,
    this.cantEntregada,
    this.puntoAcopio,
    this.notas,
    this.incidencia,
    this.incidenciaColor,
    this.estadoMaterial,
    this.estadoMaterialColor,
  });

  int id;
  String codigo;
  String descripcion;
  String lugar;
  String ubicacion;
  String unidad;
  int chequeoSap;
  int cantNecesaria;
  int cantRetirada;
  int cantEntregada;
  dynamic puntoAcopio;
  String notas;
  String incidencia;
  String incidenciaColor;
  String estadoMaterial;
  String estadoMaterialColor;

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    if (json['codigo'] == null || json['codigo'] == 'null') {
      json['codigo'] = "";
    } else if (json['descripcion'] == null || json['descripcion'] == 'null') {
      json['descripcion'] = "";
    } else if (json['lugar'] == null || json['lugar'] == 'null') {
      json['lugar'] = "";
    } else if (json['ubicacion'] == null || json['ubicacion'] == 'null') {
      json['ubicacion'] = "";
    } else if (json['unidad'] == null || json['unidad'] == 'null') {
      json['unidad'] = "";
    } else if (json['cant_necesaria'] == null ||
        json['cant_necesaria'] == 'null') {
      json['cant_necesaria'] = 0;
    } else if (json['cant_retirada'] == null ||
        json['cant_retirada'] == 'null') {
      json['cant_reteirada'] = 0;
    } else if (json['cant_entregada'] == null ||
        json['cant_entregada'] == 'null') {
      json['cant_entregada'] = 0;
    } else if (json['punto_acopio'] == null || json['punto_acopio'] == 'null') {
      json['punto_acopio'] = "";
    } else if (json['notas'] == null || json['notas'] == 'null') {
      json['notas'] = "";
    } else if (json['chequeo_sap'] == null || json['chequeo_sap'] == 'null') {
      json['chequeo_sap'] = "";
    } else if (json['estado'] == null || json['estado'] == 'null') {
      json['estado'] = "";
    } else if (json['incidencia'] == null || json['incidencia'] == 'null') {
      json['incidencia'] = "";
    } else if (json['incidencia_color'] == null ||
        json['incidencia_color'] == 'null') {
      json['incidencia_color'] = "";
    } else if (json['estado_material'] == null ||
        json['estado_material'] == 'null') {
      json['estado_material'] = "";
    } else if (json['estado_material_color'] == null ||
        json['estado_material_color'] == 'null') {
      json['estado_material_color'] = "";
    }

    return MaterialModel(
        id: json["id"],
        codigo: json["codigo"],
        descripcion: json["descripcion"],
        lugar: json["lugar"],
        ubicacion: json["ubicacion"],
        unidad: json["unidad"],
        chequeoSap: json["chequeo_sap"],
        cantNecesaria: json["cant_necesaria"],
        cantRetirada: json["cant_reteirada"],
        cantEntregada: json["cant_entregada"],
        puntoAcopio: json["punto_acopio"],
        notas: json["notas"],
        incidencia: json["incidencia"],
        incidenciaColor: json["incidencia_color"],
        estadoMaterial: json["estado_material"],
        estadoMaterialColor: json["estado_material_color"]);
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "codigo": codigo,
        "descripcion": descripcion,
        "lugar": lugar,
        "ubicacion": ubicacion,
        "unidad": unidad,
        "chequeo_sap": chequeoSap,
        "cant_necesaria": cantNecesaria,
        "cant_retirada": cantRetirada,
        "cant_entregada": cantEntregada,
        "punto_acopio": puntoAcopio,
        "notas": notas,
        "incidencia": incidencia,
        "incidencia_color": incidenciaColor,
        "estado_material": estadoMaterial,
        "estado_material_color": estadoMaterialColor,
      };
}
