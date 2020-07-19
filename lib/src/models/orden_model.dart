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
    this.nroReserva,
    this.cantRequerida,
    this.cantEntregada,
    this.cumplimiento,
    this.fechaMovilizacion,
    this.nota,
    this.equipo,
    this.area,
    this.empresa,
    this.responsable,
  });

  int id;
  String nroOt;
  String descripcion;
  String criticidad;
  String nroReserva;
  int cantRequerida;
  int cantEntregada;
  int cumplimiento;
  DateTime fechaMovilizacion;
  String nota;
  String equipo;
  String area;
  String empresa;
  String responsable;

  factory OrdenModel.fromJson(Map<String, dynamic> json) => OrdenModel(
        id: json["id"],
        nroOt: json["nro_ot"],
        descripcion: json["descripcion"],
        criticidad: json["criticidad"],
        nroReserva: json["nro_reserva"],
        cantRequerida: json["cant_requerida"],
        cantEntregada: json["cant_entregada"],
        cumplimiento: json["cumplimiento"],
        fechaMovilizacion: DateTime.parse(json["fecha_movilizacion"]),
        nota: json["nota"],
        equipo: json["equipo"],
        area: json["area"],
        empresa: json["empresa"],
        responsable: json["responsable"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nro_ot": nroOt,
        "descripcion": descripcion,
        "criticidad": criticidad,
        "nro_reserva": nroReserva,
        "cant_requerida": cantRequerida,
        "cant_entregada": cantEntregada,
        "cumplimiento": cumplimiento,
        "fecha_movilizacion": fechaMovilizacion.toIso8601String(),
        "nota": nota,
        "equipo": equipo,
        "area": area,
        "empresa": empresa,
        "responsable": responsable,
      };
}
