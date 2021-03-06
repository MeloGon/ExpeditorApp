import 'dart:io';

import 'package:dio/dio.dart';
import 'package:expeditor_app/src/models/cumplimientoad_model.dart';
import 'package:expeditor_app/src/models/grafico_model.dart';
import 'package:expeditor_app/src/models/imagenes_model.dart';
import 'package:expeditor_app/src/models/incidencia_model.dart';
import 'package:expeditor_app/src/models/materiales_model.dart';
import 'package:expeditor_app/src/models/orden_model.dart';
import 'package:expeditor_app/src/models/usuario_model.dart';
import 'package:http/http.dart' as http;

import 'dart:convert';

//para pruebas cambiar el url por apiExpeditorPruebas en ves de apiExpeditor

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
      'https://innovadis.net.pe/apiExpeditor/public/orden_trabajo/' + nroot;
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

Future actualizarDetalles(String token, String nroot) async {
  String url =
      'https://innovadis.net.pe/apiExpeditor/public/orden_trabajo/' + nroot;
  final response = await http.get(
    url,
    headers: {
      "Accept": "application/json",
      "Content-type": "application/x-www-form-urlencoded",
      "Authorization": token,
    },
  );
  List<String> detalles = new List();
  //OrdenModel orden = OrdenModel.fromJson(json.decode(response.body)['data']);
  OrdenModel receivedJson =
      OrdenModel.fromJson(json.decode(response.body)['data']);
  detalles.add(receivedJson.cantNecesaria.toString());
  detalles.add(receivedJson.cantEntregada.toString());
  detalles.add(receivedJson.cumplimiento.toString());

  return detalles;
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

Future<List<String>> numeroMateriales(String token, String nroot) async {
  String url =
      'https://innovadis.net.pe/apiExpeditor/public/orden_trabajo/' + nroot;
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-type": "application/x-www-form-urlencoded",
    "Authorization": token,
  });
  //print(response.body);
  final List<String> retorno = new List();
  var receivedJson = json.decode(response.body);
  List materiales = receivedJson['data']['materiales'] as List;
  List imagenes = receivedJson['data']['imagenes'] as List;

  retorno.add(materiales.length.toString());
  retorno.add(imagenes.length.toString());

  return retorno;
}

// Future<String> numeroFotos(String token, String nroot) async {
//   String url =
//       'https://innovadis.net.pe/apiExpeditorPruebas/public/orden_trabajo/' +
//           nroot;
//   final response = await http.get(url, headers: {
//     "Accept": "application/json",
//     "Content-type": "application/x-www-form-urlencoded",
//     "Authorization": token,
//   });
//   var receivedJson = json.decode(response.body);
//   List imagens = receivedJson['data']['imagenes'] as List;
//   return (imagens.length.toString());
// }

Future porcentajeCumpli(String token, int tipo) async {
  String url = 'https://innovadis.net.pe/apiExpeditor/public/graficos/';
  int totalCantNecesaria = 0;
  int totalCantEntregadas = 0;
  double cumplimiento = 0;
  final response = await http.get(url, headers: {
    "Accept": "application/json",
    "Content-type": "application/x-www-form-urlencoded",
    "Authorization": token,
  });

  if (tipo == 1 || tipo == 2 || tipo == 3 || tipo == 4) {
    var receivedJson = json.decode(response.body);
    (receivedJson['data'] as List)
        .map((p) => Grafico.fromJson(p))
        .toList()
        .forEach((element) {
      totalCantNecesaria = totalCantNecesaria + element.cantNecesaria;
      totalCantEntregadas = totalCantEntregadas + element.cantEntregada;
    });
    cumplimiento = (totalCantEntregadas / totalCantNecesaria) * 100;
    return cumplimiento;
  } else {
    var receivedJson = json.decode(response.body);
    List<String> empresas = [];
    List<String> lempresas = [];
    List<double> cumplimientos = [];
    List<int> cantidadesEntregadas = [];

    (receivedJson['data'] as List)
        .map((p) => Grafico.fromJson(p))
        .toList()
        .forEach((element) {
      empresas.add(element.empresa);
    });

    lempresas = empresas.toSet().toList();
    print(lempresas);
    List<int> cantidadesNecesarias = [];
    cantidadesNecesarias = List.filled(lempresas.length, 0);
    cantidadesEntregadas = List.filled(lempresas.length, 0);
    for (var i = 0; i < lempresas.length; i++) {
      (receivedJson['data'] as List)
          .map((p) => Grafico.fromJson(p))
          .toList()
          .forEach((element) {
        if (element.empresa == lempresas[i]) {
          cantidadesNecesarias[i] += element.cantNecesaria;
          cantidadesEntregadas[i] += element.cantEntregada;
        }
      });
    }

    for (var i = 0; i < lempresas.length; i++) {
      cumplimientos.add(cantidadesEntregadas[i] / cantidadesNecesarias[i]);
    }

    Map<String, double> map = {
      for (var i = 0; i < lempresas.length; i++)
        lempresas[i]: (cumplimientos[i] * 100).roundToDouble()
    };

    return map;
  }
}

Future tipoUsuario(String email, String password) async {
  String url = 'https://innovadis.net.pe/apiExpeditor/public/usuarios/login';

  final response = await http.post(url, headers: {
    "Accept": "application/json",
    "Content-Type": "application/x-www-form-urlencoded"
  }, body: {
    'json': '{"usuario":"' +
        email +
        '","contrasena":"' +
        password +
        '","gettoken":false}',
  });
  //var convertedDatatoJson = jsonDecode(response.body);
  Usuario user = Usuario.fromJson(json.decode(response.body)['message']);
  return (user.usuarioTipoId);
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
      'https://innovadis.net.pe/apiExpeditor/public/orden_trabajo/' + nroot;
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
      'https://innovadis.net.pe/apiExpeditor/public/materiales/subirImagen/' +
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
      'https://innovadis.net.pe/apiExpeditor/public/materiales/editarImagen';

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
      "https://innovadis.net.pe/apiExpeditor/public/materiales/eliminarImagen/" +
          id.toString();

  Dio dio = new Dio();
  dio.options.headers['content-Type'] = 'application/json';
  dio.options.headers["authorization"] = token;
  final response = await dio.delete(url);
  return response;
}

Future<List<IncidenciaModel>> getfiltros(String token) async {
  // String url = 'https://innovadis.net.pe/apiExpeditor/public/datos_filtros';
  String url = 'https://innovadis.net.pe/apiExpeditor/public/datos_filtros';

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
