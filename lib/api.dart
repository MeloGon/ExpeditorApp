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
    if (element.nota == 'null' || element.nota == null) {
      element.nota = "";
    } else if (element.fechaMovilizacion == null) {
      element.fechaMovilizacion = new DateTime.now();
    } else if (element.nroOt == null || element.nroOt == 'null') {
      element.nroOt = "";
    } else if (element.descripcion == null || element.descripcion == 'null') {
      element.descripcion = "";
    } else if (element.criticidad == null || element.criticidad == 'null') {
      element.criticidad = "";
    } else if (element.criticidadColor == null ||
        element.criticidadColor == 'null') {
      element.criticidadColor = "";
    } else if (element.nroReserva == null || element.nroReserva == 'null') {
      element.nroReserva = "";
    } else if (element.cantNecesaria == null) {
      element.cantNecesaria = 0;
    } else if (element.cantEntregada == null) {
      element.cantEntregada = 0;
    } else if (element.cumplimiento == null) {
      element.cumplimiento = 0;
    } else if (element.nota == null) {
      element.nota = "";
    } else if (element.condicion == null) {
      element.condicion = "";
    } else if (element.equipo == null) {
      element.equipo = "";
    } else if (element.area == null) {
      element.area = "";
    } else if (element.empresa == null) {
      element.empresa = "";
    } else if (element.responsableNom == null) {
      element.responsableNom = "";
    } else if (element.responsableApe == null) {
      element.responsableApe = "";
    }
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
