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
    this.empresa,
    this.responsableNom,
    this.responsableApe,
  });

  int id;
  String nroOt;
  String descripcion;
  String criticidad;
  String criticidadColor;
  String nroReserva;
  int cantNecesaria;
  int cantEntregada;
  dynamic cumplimiento;
  dynamic nota;
  DateTime fechaMovilizacion;
  String condicion;
  String equipo;
  String area;
  String empresa;
  String responsableNom;
  String responsableApe;

  factory OrdenModel.fromJson(Map<String, dynamic> json) {
    if (json['fecha_movilizacion'] == null ||
        json['fecha_movilizacion'] == 'null') {
      json['fecha_movilizacion'] = "${DateTime.now()}";
    } else if (json['nro_ot'] == null) {
      json['nro_ot'] = "";
    } else if (json['descripcion'] == null || json['descripcion'] == 'null') {
      json['descripcion'] = "";
    } else if (json['criticidad'] == null || json['criticidad'] == 'null') {
      json['criticidad'] = "";
    } else if (json['criticidad_color'] == null ||
        json['criticidad_color'] == 'null') {
      json['criticidad_color'] = "";
    } else if (json['nro_reserva'] == null || json['nro_reserva'] == 'null') {
      json['nro_reserva'] = "";
    } else if (json['cant_necesaria'] == null ||
        json['cant_necesaria'] == 'null') {
      json['cant_necesaria'] = 0;
    } else if (json['cant_entregada'] == null) {
      json['cant_entregada'] = 0;
    } else if (json['cumplimiento'] == null) {
      json['cumplimiento'] = 0.0;
    } else if (json['nota'] == null) {
      json['nota'] = "";
    } else if (json['condicion'] == null) {
      json['condicion'] = "";
    } else if (json['equipo'] == null) {
      json['equipo'] = "";
    } else if (json['area'] == null) {
      json['area'] = "";
    } else if (json['empresa'] == null) {
      json['empresa'] = "";
    } else if (json['responsable_nom'] == null) {
      json['responsable_nom'] = "";
    } else if (json['responsable_ape'] == null) {
      json['responsable_ape'] = "";
    }
    return OrdenModel(
      id: json["id"],
      nroOt: json["nro_ot"],
      descripcion: json["descripcion"],
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
      empresa: json["empresa"],
      responsableNom: json["responsable_nom"],
      responsableApe: json["responsable_ape"],
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "nro_ot": nroOt,
        "descripcion": descripcion,
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
        "empresa": empresa,
        "responsable_nom": responsableNom,
        "responsable_ape": responsableApe,
      };
}
