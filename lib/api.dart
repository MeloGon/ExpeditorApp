import 'package:expeditor_app/src/models/materiales_model.dart';
import 'package:expeditor_app/src/models/orden_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Future loginUser(String email, String password) async {
  String url = 'https://innovadis.net.pe/apiExpeditor/public/usuarios/login';

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

// Future getOts(String token) async {
//   String url = 'https://innovadis.net.pe/apiExpeditor/public/orden_trabajo';
//   final response = await http.get(url, headers: {
//     "Accept": "application/json",
//     "Content-Type": "application/x-www-form-urlencoded",
//     "Authorization": token,
//   });
//   var convertedDatatoJson = jsonDecode(response.body);
//   return convertedDatatoJson;
// }

Future<List<OrdenModel>> cargarOrdenes(String token) async {
  String url = 'https://innovadis.net.pe/apiExpeditor/public/orden_trabajo';
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded",
    "Authorization": token,
  });
  final List<OrdenModel> ordenes = new List();
  //final decodedData = json.decode(response.body)['data'];
  //final Map<String, dynamic> decodedData = json.decode(response.body)['data'];
  var receivedJson = json.decode(response.body);

  (receivedJson['data'] as List)
      .map((p) => OrdenModel.fromJson(p))
      .toList()
      .forEach((element) {
    ordenes.add(element);
  });
  return ordenes;
}

Future<OrdenModel> getDetalles(String token, String nroot) async {
  String url =
      'https://innovadis.net.pe/apiExpeditor/public/orden_trabajo/' + nroot;
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-type": "application/x-www-form-urlencoded",
    "Authorization": token,
  });

  OrdenModel orden = OrdenModel.fromJson(jsonDecode(response.body)['data']);
  return orden;
}

Future<List<MaterialModel>> cargarMateriales(String token, String nroot) async {
  String url =
      'https://innovadis.net.pe/apiExpeditor/public/orden_trabajo/' + nroot;
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

Future editarCantidad(
    String token, int idmat, int canten, int inci, String nota) async {
  int prueba = 2;
  String prueba2 = "holal";
  String url = 'https://innovadis.net.pe/apiExpeditor/public/materiales/editar';
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
        prueba.toString() +
        ',"notas":"' +
        prueba2 +
        '"}',
  });

  var convertedJson = jsonDecode(response.body);
  print(convertedJson);
  return convertedJson;
}
