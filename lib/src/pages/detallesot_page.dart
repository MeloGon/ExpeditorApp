import 'dart:convert';
import 'dart:io';
import 'package:expeditor_app/api.dart';
import 'package:expeditor_app/src/models/imagenes_model.dart';
import 'package:expeditor_app/src/models/materiales_model.dart';
import 'package:expeditor_app/src/models/orden_model.dart';
import 'package:expeditor_app/src/pages/detallemat_page.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class DetallesOT extends StatefulWidget {
  final String token;
  final String nroot;
  final String idot;
  final String criti,
      descriot,
      areaot,
      critico,
      noreserva,
      cantnece,
      cantreque,
      cumpli,
      fechamovi;
  DetallesOT(
      {this.token,
      this.nroot,
      this.idot,
      this.descriot,
      this.areaot,
      this.criti,
      this.critico,
      this.noreserva,
      this.cantnece,
      this.cantreque,
      this.cumpli,
      this.fechamovi});
  @override
  _DetallesOTState createState() => _DetallesOTState();
}

class _DetallesOTState extends State<DetallesOT>
    with AutomaticKeepAliveClientMixin<DetallesOT> {
  bool isExpanded = false;
  dynamic cantidadMateriales;
  Color _sapColor = Color(0xff354A5F);
  Color colorLabelTab = Color(0xff0854A0);
  TextStyle estiloOrden = TextStyle(fontSize: 24, fontFamily: 'fuente72');
  TextStyle estiloNro = TextStyle(fontSize: 16, fontFamily: 'fuente72');
  TextStyle estiloMore = TextStyle(fontSize: 14, fontFamily: 'fuente72');
  TextStyle estiloMoreRight = TextStyle(
      fontSize: 14, fontFamily: 'fuente72', color: Hexcolor("#32363A"));
  TextStyle estiloCant = TextStyle(fontSize: 24, fontFamily: 'fuente72');
  bool loading;
  List<String> ids = ['0', '10', '1002'];
  String busqueda = "";
  File foto;
  bool editarbol = false;
  ScrollController _scrollController = new ScrollController();
  List<MaterialModel> listaMaterialesToda = new List<MaterialModel>();
  List<MaterialModel> listaMaterialesTodaFiltrada = new List<MaterialModel>();
  String btnText;
  List<int> idfotos = [];
  bool isediting = false;
  String nuevaDescri;

  @override
  void initState() {
    loading = true;
    ids = [];
    _loadImageIds();
    _scrollController = new ScrollController(initialScrollOffset: 300);
    super.initState();
  }

  void _loadImageIds() async {
    final response = await http.get('https://picsum.photos/v2/list');
    final json = jsonDecode(response.body);
    List<String> _ids = [];
    for (var image in json) {
      _ids.add(image['id']);
    }

    setState(() {
      loading = false;
      ids = _ids;
    });
  }

  @override
  Widget build(BuildContext context) {
    cargarMateriales(widget.token, widget.nroot).then((value) {
      setState(() {
        listaMaterialesToda = value;
        listaMaterialesTodaFiltrada = listaMaterialesToda;
        cantidadMateriales = listaMaterialesToda.length;
      });
    });

    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
            controller: _scrollController,
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: _sapColor,
                  title: Text('Detalles OT'),
                  expandedHeight: 450.0,
                  floating: false,
                  pinned: true,
                  bottom: PreferredSize(
                    preferredSize: Size(100.0, 100.0),
                    child: Icon(
                      Icons.arrow_drop_down,
                      color: _sapColor,
                      size: 25,
                    ),
                  ),
                  flexibleSpace: _panelDetalle(),
                  actions: <Widget>[
                    IconButton(icon: Icon(Icons.sync), onPressed: () {})
                  ],
                ),
                SliverPersistentHeader(
                  delegate: _SliverAppBarDelegate(
                    TabBar(
                      labelColor: colorLabelTab,
                      indicatorColor: colorLabelTab,
                      labelStyle: estiloMore,
                      unselectedLabelColor: Colors.grey,
                      tabs: [
                        Tab(
                          text: "Materiales",
                        ),
                        Tab(text: "Fotos"),
                      ],
                    ),
                  ),
                  pinned: true,
                ),
              ];
            },
            body: new Container(
                padding: new EdgeInsets.all(10.0),
                child: new TabBarView(children: <Widget>[
                  ListView(
                    children: <Widget>[
                      panelCabecera(),
                      crearMaterial(),
                      Divider(),
                    ],
                  ),
                  galeriaOT(context),
                ]))),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;

  Widget _panelDetalle() {
    return _detalles();
  }

  Widget _detalles() {
    var formater = new DateFormat('MMM d, yyyy');
    return SafeArea(
      child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          margin: EdgeInsets.only(top: 55),
          color: Colors.white,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Container(
                height: 57,
                child: Text(
                  '${widget.descriot}',
                  style: estiloOrden,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'No. Orden ${widget.nroot}',
                style: estiloNro,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Criticidad: ${widget.criti}',
                style: TextStyle(
                    fontFamily: 'fuente72',
                    fontSize: 14,
                    color: Hexcolor('${widget.critico}')),
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                'Area: ${widget.areaot}',
                style: estiloMore,
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                'No. Reserva: ${widget.noreserva}',
                style: estiloMore,
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                'Fecha Movilización: ' +
                    formater.format(DateTime.parse('${widget.fechamovi}')),
                style: estiloMore,
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                'Cant. Requerida:',
                style: estiloMore,
              ),
              SizedBox(
                height: 10,
              ),
              //aqui abajo era cantidad requerida preguntar que paso
              Text(
                '${widget.cantnece} EA',
                style: estiloCant,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Cant. Entregada:',
                style: estiloMore,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${widget.cantreque} EA',
                style: estiloCant,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Cumplimiento',
                style: estiloMore,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                '${widget.cumpli}%',
                style: TextStyle(
                    fontFamily: 'fuente72',
                    fontSize: 24,
                    color: colorCumplimiento('${widget.cumpli}')),
              ),
            ],
          )),
    );
  }

  Color colorCumplimiento(dynamic cumplimiento) {
    double x = double.parse(cumplimiento);
    if (x > -1 && x < 20) {
      return Colors.red;
    }
    if (x >= 20 && x < 80) {
      return Colors.orange;
    }
    if (x >= 80 && x < 101) {
      return Colors.green;
    }
  }

  Widget crearMaterial() {
    setState(() {});
    return ListView.builder(
      shrinkWrap: true,
      itemCount: listaMaterialesTodaFiltrada.length,
      physics: ScrollPhysics(),
      scrollDirection: Axis.vertical,
      itemBuilder: (context, index) {
        return listMats(listaMaterialesTodaFiltrada[index]);
      },
    );
  }

  Widget listMats(MaterialModel material) {
    return ListTile(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
          print(material.incidencia);
          return DetalleMatPage(
            token: widget.token,
            idmate: '${material.id}',
            codmate: '${material.codigo}',
            descripcion: '${material.descripcion}',
            lugar: '${material.lugar}',
            ubicacion: '${material.ubicacion}',
            cantre: '${material.cantNecesaria}',
            unidad: '${material.unidad}',
            acopio: '${material.puntoAcopio}',
            canten: '${material.cantEntregada}',
            incidencia: '${material.incidencia}',
            nota: '${material.notas}',
          );
          //setState(() {});
        }));
      },
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 9,
          ),
          Text(
            '${material.codigo}',
            style: TextStyle(
                fontFamily: 'fuente72',
                fontSize: 16,
                color: Color(0xff0A6ED1),
                fontWeight: FontWeight.w700),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            '${material.descripcion}',
            style: estiloMore,
          ),
          SizedBox(
            height: 5,
          ),
        ],
      ),
      subtitle: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Text('Estado: '),
              Text(
                '${material.estadoMaterial}',
                style: TextStyle(
                    fontFamily: 'fuente72',
                    fontSize: 14,
                    color: Hexcolor('${material.estadoMaterialColor}')),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Text('Lugar: '),
              Text('${material.lugar}', style: estiloMoreRight),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Text('Ubicación: '),
              Text(
                '${material.ubicacion}',
                style: estiloMoreRight,
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Text('Punto Acopio: '),
              Text(
                '${material.puntoAcopio}',
                style: estiloMoreRight,
              ),
            ],
          ),
        ],
      ),
      trailing: Container(
        width: 52,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text(
                  '${material.cantNecesaria}',
                  style: TextStyle(
                      color: Color(0xff6A6D70),
                      fontSize: 14,
                      fontWeight: FontWeight.w700),
                ),
                Text(
                  ' ' + '${material.unidad}',
                  style: estiloMore,
                )
              ],
            ),
            Text(
              '${material.incidencia ?? "   "}'.substring(0, 2),
              style: TextStyle(
                  color: Hexcolor('${material.incidenciaColor ?? "#6A6D70"}'),
                  fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 15)
          ],
        ),
      ),
    );
  }

  Widget panelCabecera() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 13, horizontal: 15),
      width: double.infinity,
      height: 115.0,
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  'Lineas de Materiales (' + '${cantidadMateriales ?? "0"})',
                  style: TextStyle(fontSize: 18.0, fontFamily: 'fuente72'),
                ),
              ),
            ],
          ),
          ListTile(
            title: _inputBuscar(),
          )
        ],
      ),
    );
  }

  Widget _inputBuscar() {
    return Container(
      height: 60,
      padding: EdgeInsets.only(left: 150, top: 20),
      child: TextField(
        onChanged: (value) {
          setState(() {
            listaMaterialesTodaFiltrada = listaMaterialesToda
                .where((u) => (u.descripcion
                        .toLowerCase()
                        .contains(value.toLowerCase()) ||
                    u.ubicacion.toLowerCase().contains(value.toLowerCase())))
                .toList();
          });
        },
        textAlignVertical: TextAlignVertical.center,
        style: TextStyle(
          fontFamily: 'fuente72',
          fontSize: 14,
        ),
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10),
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(2.0)),
            hintText: 'Buscar',
            suffixIcon: Icon(
              Icons.search,
              color: Color(0xff0854a0),
            )),
      ),
    );
  }

  Widget galeriaOT(BuildContext context) {
    if (loading) {
      return Center(child: CircularProgressIndicator());
    }
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: <Widget>[
              Expanded(child: Text('Fotos')),
              IconButton(
                  icon: Icon(
                    Icons.sync,
                    color: colorLabelTab,
                  ),
                  onPressed: () {
                    setState(() {
                      cargarFotos(widget.token, widget.nroot);
                    });
                  }),
              popupmenu(),
            ],
          ),
        ),
        Flexible(child: fotografias()),
      ],
    );
  }

  Widget popupmenu() {
    return PopupMenuButton<String>(
      icon: Icon(
        Icons.add,
        color: colorLabelTab,
      ),
      itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        PopupMenuItem<String>(
          value: "tomar_foto",
          child: Text(
            "Tomar Fotografia",
            style: TextStyle(fontFamily: 'fuente72'),
          ),
        ),
        PopupMenuItem<String>(
          value: "subir_foto",
          child: Text(
            "Subir una desde la galeria",
            style: TextStyle(fontFamily: 'fuente72'),
          ),
        ),
      ],
      onSelected: (value) {
        if (value == "tomar_foto") {
          tomarFoto();
        } else if (value == "subir_foto") {
          seleccionarFoto();
        }
      },
    );
  }

  seleccionarFoto() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: ImageSource.gallery,
      imageQuality: 78,
      maxHeight: 768,
      maxWidth: 1024,
    );
    try {
      foto = File(pickedFile.path);
    } catch (e) {
      print('$e');
    }

    if (foto != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ImagePage(foto, widget.token, widget.idot);
          },
        ),
      );
    } else {
      print('ruta de imagen nula');
    }
  }

  tomarFoto() async {
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(
      source: ImageSource.camera,
      imageQuality: 78,
      maxHeight: 768,
      maxWidth: 1024,
    );
    try {
      foto = File(pickedFile.path);
    } catch (e) {
      print('$e');
    }

    if (foto != null) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) {
            return ImagePage(foto, widget.token, widget.idot);
          },
        ),
      );
    } else {
      print('ruta de imagen nula');
    }
  }

  Widget fotografias() {
    return FutureBuilder(
        future: cargarFotos(widget.token, widget.nroot),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final fotosot = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: fotosot.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return listFotos(fotosot[index]);
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget listFotos(ImagenModel img) {
    // var x = InputBorder.none;
    return ListTile(
      leading: GestureDetector(
        child: FadeInImage(
          placeholder: AssetImage('assets/jar-loading.gif'),
          image: NetworkImage(
            '${img.url}',
          ),
          width: 70,
          height: 70,
        ),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) {
                return ImagePageNetwork('${img.url}');
              },
            ),
          );
        },
      ),
      // title: txtdescr(img.descripcion),
      title: TextField(
        enabled: isediting,
        decoration: InputDecoration(
            border: InputBorder.none, hintText: img.descripcion),
        style: TextStyle(fontFamily: 'fuente72', fontSize: 14),
        onChanged: (value) {
          setState(() {
            nuevaDescri = value;
          });
        },
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Tamaño: ' + '${img.peso}' + ' KB',
            style: estiloMore,
          ),
          Row(
            children: <Widget>[
              FlatButton(
                  child: Text(
                    btnText == null || !idfotos.contains(img.id)
                        ? 'EDITAR'
                        : btnText,
                    style:
                        TextStyle(color: colorLabelTab, fontFamily: 'fuente72'),
                  ),
                  onPressed: () {
                    setState(() {
                      if (btnText == "ACEPTAR") {
                        isediting = !isediting;
                        Fluttertoast.showToast(
                            msg: "Espere un momento porfavor ..",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.CENTER,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.grey[200],
                            textColor: Colors.black,
                            fontSize: 14.0);
                        editarDescripcion(
                            widget.token, idfotos[0], nuevaDescri);
                        idfotos.clear();
                        btnText = null;
                      } else {
                        isediting = !isediting;
                        btnText = "ACEPTAR";
                        idfotos.add(img.id);
                        nuevaDescri = null;
                      }
                    });
                  }),
              FlatButton(
                child: Text('ELIMINAR',
                    style: TextStyle(
                      color: colorLabelTab,
                      fontFamily: 'fuente72',
                    )),
                onPressed: () {
                  setState(() {
                    Fluttertoast.showToast(
                        msg: "Espere un momento porfavor ..",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                        timeInSecForIosWeb: 1,
                        backgroundColor: Colors.grey[200],
                        textColor: Colors.black,
                        fontSize: 14.0);
                    eliminarFoto(widget.token, img.id);
                  });
                },
              )
              // IconButton(
              //     icon: Icon(
              //       Icons.delete_outline,
              //       color: colorLabelTab,
              //     ),
              //     onPressed: () {})
            ],
          )
        ],
      ),
    );
  }

  editarDescripcion(String token, int idfoto, String descri) async {
    var rsp = await editarDescri(token, idfoto, descri);
    if (rsp['code'] == 200) {
      Fluttertoast.showToast(
          msg: "Descripcion editada exitosamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black,
          fontSize: 14.0);
    }
  }

  eliminarFoto(String token, int idfoto) async {
    var rsp = await eliminarPic(token, idfoto);
    if (rsp['code'] == 200) {
      Fluttertoast.showToast(
          msg: "Fotografia eliminada exitosamente",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.grey[200],
          textColor: Colors.black,
          fontSize: 14.0);
    }
  }
}

class ImagePage extends StatefulWidget {
  final File foto;
  final String token;
  final String idot;
  ImagePage(this.foto, this.token, this.idot);
  _ImagePageState createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          FlatButton(
              child: Text(
                'Guardar',
                style: TextStyle(
                    fontFamily: 'fuente72', color: Colors.white, fontSize: 15),
              ),
              onPressed: () =>
                  guardarFoto(widget.foto, widget.token, widget.idot, context))
        ],
      ),
      body: Center(
        child: Image(
          image: AssetImage(widget.foto.path),
          height: 300.0,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  guardarFoto(
      File foto, String token, String idot, BuildContext context) async {
    Fluttertoast.showToast(
        msg: "Guardando fotografia ...",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 14.0);
    var rsp = await subirFoto(foto, token, idot);
    if (rsp.data['code'] == 200 || rsp.data['code'] == "200") {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => new AlertDialog(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                content: Builder(
                  builder: (context) {
                    return Container(
                      child: Text(
                        'La fotografia ha sido guardada exitosamente. Regresa a la galeria y actualiza para ver los cambios',
                        style: TextStyle(fontFamily: 'fuente72'),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
              ));
      Future.delayed(const Duration(milliseconds: 1100), () {
        setState(() {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      });
    } else {
      print('algo malo paso');
    }
  }
}

class ImagePageNetwork extends StatelessWidget {
  final String foto;
  ImagePageNetwork(this.foto);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Image.network(foto),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return new Container(
      color: Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}
