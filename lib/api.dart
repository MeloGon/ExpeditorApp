import 'dart:io';

import 'package:dio/dio.dart';
import 'package:expeditor_app/src/models/imagenes_model.dart';
import 'package:expeditor_app/src/models/incidencia_model.dart';
import 'package:expeditor_app/src/models/materiales_model.dart';
import 'package:expeditor_app/src/models/orden_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//para pruebas cambiar el url por apiExpeditorPruebas en ves de apiExpeditor

Future loginUser(String email, String password) async {
  String url =
      'https://innovadis.net.pe/apiExpeditorPruebas/public/usuarios/login';

  final response = await http.post(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  }, body: {
    'json': '{"usuario":"' +
        email +
        '","contrasena":"' +
        password +
        '","gettoken":"true"}',
  });
  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}

Future<List<OrdenModel>> cargarOrdenes(String token) async {
  String url =
      'https://innovadis.net.pe/apiExpeditorPruebas/public/orden_trabajo';
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": token,
  });
  final List<OrdenModel> ordenes = new List();
  //final decodedData = json.decode(response.body)['data'];
  //final Map<String, dynamic> decodedData = json.decode(response.body)['data'];
  //var receivedJson = json.decode(response.body.toString());

  if (response.body.isNotEmpty) {
    var receivedJson = json.decode(response.body.toString());
    (receivedJson['data'] as List)
        .map((p) => OrdenModel.fromJson(p))
        .toList()
        .forEach((element) {
      ordenes.add(element);
    });
  }

  return ordenes;
}

Future<OrdenModel> getDetalles(String token, String nroot) async {
  String url =
      'https://innovadis.net.pe/apiExpeditorPruebas/public/orden_trabajo/' +
          nroot;
  final response = await http.get(
    url,
    headers: {
      "Accept": "application/json",
      "Content-type": "application/x-www-form-urlencoded",
      "Authorization": token,
    },
  );

  OrdenModel orden = OrdenModel.fromJson(json.decode(response.body)['data']);
  return orden;
}

Future<List<MaterialModel>> cargarMateriales(String token, String nroot) async {
  String url =
      'https://innovadis.net.pe/apiExpeditorPruebas/public/orden_trabajo/' +
          nroot;
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-type": "application/x-www-form-urlencoded",
    "Authorization": token,
  });

  final List<MaterialModel> materiales = new List();
  var receivedJson = json.decode(response.body);
  (receivedJson['data']['materiales'] as List)
      .map((p) => MaterialModel.fromJson(p))
      .toList()
      .forEach((element) {
    materiales.add(element);
  });
  return materiales;
}

Future<String> numeroMateriales(String token, String nroot) async {
  String url =
      'https://innovadis.net.pe/apiExpeditorPruebas/public/orden_trabajo/' +
          nroot;
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-type": "application/x-www-form-urlencoded",
    "Authorization": token,
  });
  List<dynamic> lista = json.decode(response.body)['data']['materiales'];
  print(lista.length);

  final List<MaterialModel> materiales = new List();
  var receivedJson = json.decode(response.body);
  (receivedJson['data']['materiales'] as List)
      .map((p) => MaterialModel.fromJson(p))
      .toList()
      .forEach((element) {
    materiales.add(element);
  });
  return materiales.length.toString();
}

Future porcentajeCumpli(String token) async {
  String url = 'https://innovadis.net.pe/apiExpeditorPruebas/public/graficos/';
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-type": "application/x-www-form-urlencoded",
    "Authorization": token,
  });
  var receivedJson = json.decode(response.body);
  List lista = receivedJson['data']['cant_necesaria'] as List;
  return lista;
  //print(receivedJson['data']['cant_necesaria']);
}

// Future<String> cargarNotas(String token, int idmat) async {
//   String url =
//       'https://innovadis.net.pe/apiExpeditorPruebas/public/orden_trabajo/' +
//           nroot;
//   final response = await http.get(url, headers: {
//     "Accept": "application/json",
//     "Content-type": "application/x-www-form-urlencoded",
//     "Authorization": token,
//   });
//   List<dynamic> lista = json.decode(response.body)['data']['materiales'];
//   print(lista.length);

//   final List<MaterialModel> materiales = new List();
//   var receivedJson = json.decode(response.body);
//   (receivedJson['data']['materiales'] as List)
//       .map((p) => MaterialModel.fromJson(p))
//       .toList()
//       .forEach((element) {
//     materiales.add(element);
//   });
//   return materiales.length.toString();
// }

Future<List<ImagenModel>> cargarFotos(String token, String nroot) async {
  String url =
      'https://innovadis.net.pe/apiExpeditorPruebas/public/orden_trabajo/' +
          nroot;
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-type": "application/x-www-form-urlencoded",
    "Authorization": token,
  });

  final List<ImagenModel> imagenes = new List();
  var receivedJson = json.decode(response.body);
  (receivedJson['data']['imagenes'] as List)
      .map((p) => ImagenModel.fromJson(p))
      .toList()
      .forEach((element) {
    imagenes.add(element);
  });
  return imagenes;
}

Future editarCantidad(
    String token, int idmat, int canten, int inci, String nota) async {
  String url =
      'https://innovadis.net.pe/apiExpeditorPruebas/public/materiales/editar';
  final response = await http.put(url, headers: {
    "Accept": "application/json",
    "Content-type": "application/x-www-form-urlencoded",
    "Authorization": token,
  }, body: {
    'json': '{"id_OT_material":' +
        idmat.toString() +
        ',"cant_entregada":' +
        canten.toString() +
        ',"incidencia_id":' +
        inci.toString() +
        ',"notas":"' +
        nota +
        '"}',
  });

  var convertedJson = jsonDecode(response.body);
  return convertedJson;
}

Future subirFoto(File imagen, String token, String id) async {
  String url =
      'https://innovadis.net.pe/apiExpeditorPruebas/public/materiales/subirImagen/' +
          id;
  FormData formData = new FormData.fromMap(
      {"file0": await MultipartFile.fromFile(imagen.path)});

  Dio dio = new Dio();
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers["authorization"] = token;
  final response = await dio.post(url, data: formData);

  return response;
}

Future editarDescri(String token, int id, String descrinueva) async {
  String url =
      'https://innovadis.net.pe/apiExpeditorPruebas/public/materiales/editarImagen';

  final response = await http.post(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": token,
  }, body: {
    'json': '{"id":' + id.toString() + ',"descripcion":"' + descrinueva + '"}',
  });
  var convertedDatatoJson = jsonDecode(response.body);
  return convertedDatatoJson;
}

Future eliminarPic(String token, int id) async {
  String url =
      "https://innovadis.net.pe/apiExpeditorPruebas/public/materiales/eliminarImagen/" +
          id.toString();

  Dio dio = new Dio();
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers["authorization"] = token;
  final response = await dio.delete(url);
  return response;
}

Future<List<IncidenciaModel>> getfiltros(String token) async {
  // String url = 'https://innovadis.net.pe/apiExpeditor/public/datos_filtros';
  String url =
      'https://innovadis.net.pe/apiExpeditorPruebas/public/datos_filtros';

  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": token,
  });

  final List<IncidenciaModel> incidencias = new List();
  var receivedJson = json.decode(response.body);
  (receivedJson['incidencias'] as List)
      .map((p) => IncidenciaModel.fromJson(p))
      .toList()
      .forEach((element) {
    incidencias.add(element);
  });
  return incidencias;
}
