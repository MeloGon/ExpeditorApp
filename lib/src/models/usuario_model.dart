// To parse this JSON data, do
//
//     final usuario = usuarioFromJson(jsonString);

import 'dart:convert';

Usuario usuarioFromJson(String str) => Usuario.fromJson(json.decode(str));

String usuarioToJson(Usuario data) => json.encode(data.toJson());

class Usuario {
  Usuario({
    this.id,
    this.nombre,
    this.apellido,
    this.usuario,
    this.image,
    this.usuarioTipoId,
    this.empresasId,
    this.areaId,
    this.updatedAt,
  });

  int id;
  String nombre;
  String apellido;
  String usuario;
  dynamic image;
  int usuarioTipoId;
  int empresasId;
  dynamic areaId;
  DateTime updatedAt;

  factory Usuario.fromJson(Map<String, dynamic> json) => Usuario(
        id: json["id"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        usuario: json["usuario"],
        image: json["image"],
        usuarioTipoId: json["usuario_tipo_id"],
        empresasId: json["empresas_id"],
        areaId: json["area_id"],
        updatedAt: DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellido": apellido,
        "usuario": usuario,
        "image": image,
        "usuario_tipo_id": usuarioTipoId,
        "empresas_id": empresasId,
        "area_id": areaId,
        "updated_at": updatedAt.toIso8601String(),
      };
}
