// To parse this JSON data, do
//
//     final cumplimientoAdmin = cumplimientoAdminFromJson(jsonString);

import 'dart:convert';

CumplimientoAdmin cumplimientoAdminFromJson(String str) =>
    CumplimientoAdmin.fromJson(json.decode(str));

String cumplimientoAdminToJson(CumplimientoAdmin data) =>
    json.encode(data.toJson());

class CumplimientoAdmin {
  CumplimientoAdmin({
    this.empresa,
    this.cumplimiento,
  });

  String empresa;
  int cumplimiento;

  factory CumplimientoAdmin.fromJson(Map<String, dynamic> json) =>
      CumplimientoAdmin(
        empresa: json["empresa"],
        cumplimiento: json["cumplimiento"],
      );

  Map<String, dynamic> toJson() => {
        "empresa": empresa,
        "cumplimiento": cumplimiento,
      };
}
