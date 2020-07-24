// To parse this JSON data, do
//
//     final ordenModel = ordenModelFromJson(jsonString);

import 'dart:convert';

OrdenModel ordenModelFromJson(String str) =>
    OrdenModel.fromJson(json.decode(str));

String ordenModelToJson(OrdenModel data) => json.encode(data.toJson());

class OrdenModel {
  OrdenModel({
    this.id,
    this.nroOt,
    this.descripcion,
    this.fechaActualizacion,
    this.criticidad,
    this.criticidadColor,
    this.nroReserva,
    this.cantNecesaria,
    this.cantEntregada,
    this.cumplimiento,
    this.nota,
    this.fechaMovilizacion,
    this.condicion,
    this.equipo,
    this.area,
    this.subsistema,
    this.empresa,
    this.responsableNom,
    this.responsableApe,
  });

  int id;
  String nroOt;
  String descripcion;
  DateTime fechaActualizacion;
  String criticidad;
  String criticidadColor;
  String nroReserva;
  int cantNecesaria;
  int cantEntregada;
  int cumplimiento;
  String nota;
  DateTime fechaMovilizacion;
  String condicion;
  String equipo;
  String area;
  String subsistema;
  String empresa;
  String responsableNom;
  String responsableApe;

  factory OrdenModel.fromJson(Map<String, dynamic> json) {
    if (json['fechaActualizacion'] == null ||
        json['fechaActualizacion'] == 'null') {
      json['fechaActualizacion'] = "${DateTime.now()}";
    }
    if (json['fecha_movilizacion'] == null ||
        json['fecha_movilizacion'] == 'null') {
      json['fecha_movilizacion'] = "${DateTime.now()}";
    }
    if (json['nro_ot'] == null) {
      json['nro_ot'] = "";
    }
    if (json['descripcion'] == null || json['descripcion'] == 'null') {
      json['descripcion'] = "";
    }
    if (json['criticidad'] == null || json['criticidad'] == 'null') {
      json['criticidad'] = "";
    }
    if (json['criticidad_color'] == null ||
        json['criticidad_color'] == 'null') {
      json['criticidad_color'] = "";
    }
    if (json['nro_reserva'] == null || json['nro_reserva'] == 'null') {
      json['nro_reserva'] = "";
    }
    if (json['cant_necesaria'] == null || json['cant_necesaria'] == 'null') {
      json['cant_necesaria'] = 0;
    }
    if (json['cant_entregada'] == null) {
      json['cant_entregada'] = 0;
    }
    if (json['cumplimiento'] == null) {
      json['cumplimiento'] = 0.0;
    }
    if (json['nota'] == null) {
      json['nota'] = "";
    }
    if (json['condicion'] == null) {
      json['condicion'] = "";
    }
    if (json['equipo'] == null) {
      json['equipo'] = "";
    }
    if (json['area'] == null) {
      json['area'] = "";
    }
    if (json['empresa'] == null) {
      json['empresa'] = "";
    }
    if (json['responsable_nom'] == null) {
      json['responsable_nom'] = "";
    }
    if (json['responsable_ape'] == null) {
      json['responsable_ape'] = "";
    }
    if (json['fechaActualizacion'] == null) {
      json['responsable_ape'] = "";
    }
    return OrdenModel(
      id: json["id"],
      nroOt: json["nro_ot"],
      descripcion: json["descripcion"],
      fechaActualizacion: DateTime.parse(json["fechaActualizacion"]),
      criticidad: json["criticidad"],
      criticidadColor: json["criticidad_color"],
      nroReserva: json["nro_reserva"],
      cantNecesaria: json["cant_necesaria"],
      cantEntregada: json["cant_entregada"],
      cumplimiento: json["cumplimiento"],
      nota: json["nota"],
      fechaMovilizacion: DateTime.parse(json["fecha_movilizacion"]),
      condicion: json["condicion"],
      equipo: json["equipo"],
      area: json["area"],
      subsistema: json["subsistema"],
      empresa: json["empresa"],
      responsableNom: json["responsable_nom"],
      responsableApe: json["responsable_ape"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nro_ot": nroOt,
        "descripcion": descripcion,
        "fechaActualizacion": fechaActualizacion.toIso8601String(),
        "criticidad": criticidad,
        "criticidad_color": criticidadColor,
        "nro_reserva": nroReserva,
        "cant_necesaria": cantNecesaria,
        "cant_entregada": cantEntregada,
        "cumplimiento": cumplimiento,
        "nota": nota,
        "fecha_movilizacion": fechaMovilizacion.toIso8601String(),
        "condicion": condicion,
        "equipo": equipo,
        "area": area,
        "subsistema": subsistema,
        "empresa": empresa,
        "responsable_nom": responsableNom,
        "responsable_ape": responsableApe,
      };
}
