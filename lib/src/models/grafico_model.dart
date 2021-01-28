import 'dart:convert';

Grafico graficoFromJson(String str) => Grafico.fromJson(json.decode(str));

String graficoToJson(Grafico data) => json.encode(data.toJson());

class Grafico {
  Grafico({
    this.id,
    this.fechaActualizacion,
    this.criticidad,
    this.cantNecesaria,
    this.cantEntregada,
    this.cumplimiento,
    this.fechaMovilizacion,
    this.area,
    this.empresa,
  });

  int id;
  DateTime fechaActualizacion;
  String criticidad;
  int cantNecesaria;
  int cantEntregada;
  int cumplimiento;
  dynamic fechaMovilizacion;
  String area;
  String empresa;

  factory Grafico.fromJson(Map<String, dynamic> json) => Grafico(
        id: json["id"],
        fechaActualizacion: DateTime.parse(json["fechaActualizacion"]),
        criticidad: json["criticidad"],
        cantNecesaria: json["cant_necesaria"],
        cantEntregada: json["cant_entregada"],
        cumplimiento: json["cumplimiento"],
        fechaMovilizacion: json["fecha_movilizacion"],
        area: json["area"],
        empresa: json["empresa"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "fechaActualizacion": fechaActualizacion.toIso8601String(),
        "criticidad": criticidad,
        "cant_necesaria": cantNecesaria,
        "cant_entregada": cantEntregada,
        "cumplimiento": cumplimiento,
        "fecha_movilizacion": fechaMovilizacion,
        "area": area,
        "empresa": empresa,
      };
}
