import 'dart:convert';
import 'package:expeditor_app/api.dart';
import 'package:expeditor_app/src/models/materiales_model.dart';
import 'package:expeditor_app/src/models/orden_model.dart';
import 'package:expeditor_app/src/pages/detallemat_page.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class DetallesOT extends StatefulWidget {
  final String token;
  final String nroot;
  DetallesOT({this.token, this.nroot});
  @override
  _DetallesOTState createState() => _DetallesOTState();
}

class _DetallesOTState extends State<DetallesOT>
    with AutomaticKeepAliveClientMixin<DetallesOT> {
  bool isExpanded = false;
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
  int lineaMats = 0;

  @override
  void initState() {
    loading = true;
    ids = [];
    _loadImageIds();
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
    return Scaffold(
      body: DefaultTabController(
        length: 2,
        child: NestedScrollView(
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
                        Tab(text: "Foto"),
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
    return FutureBuilder(
        future: getDetalles(widget.token, widget.nroot),
        builder: (BuildContext context, snapshot) {
          final orden = snapshot.data;
          if (snapshot.hasData) {
            return _detalles(orden);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

//ARREGLAR LO DE LOS SCROLLS VER TAMBIEN LO DE LAS UN Y PASAR A LA SIGUIENTE PANTALLA
  Widget _detalles(OrdenModel orden) {
    return SafeArea(
      child: Container(
          padding: EdgeInsets.only(left: 20, right: 20, top: 10),
          margin: EdgeInsets.only(top: 55),
          color: Colors.white,
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            children: <Widget>[
              Text(
                '${orden.descripcion}',
                style: estiloOrden,
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                'No. Orden ${orden.nroOt}',
                style: estiloNro,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                'Criticidad: ${orden.criticidad}',
                style: estiloMore,
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                'Area: ${orden.area}',
                style: estiloMore,
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                'No. Reserva: ${orden.nroReserva}',
                style: estiloMore,
              ),
              SizedBox(
                height: 7,
              ),
              Text(
                'Fecha Movilización: ${orden.fechaMovilizacion}',
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
                '${orden.cantEntregada} EA',
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
                '${orden.cantEntregada} EA',
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
                '${orden.cumplimiento}%',
                style: estiloCant,
              ),
            ],
          )),
    );
  }

  Widget crearMaterial() {
    return FutureBuilder(
        future: cargarMateriales(widget.token, widget.nroot),
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            final materiales = snapshot.data;
            return ListView.builder(
              shrinkWrap: true,
              itemCount: materiales.length,
              scrollDirection: Axis.vertical,
              itemBuilder: (context, index) {
                return listMats(materiales[index]);
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget listMats(MaterialModel material) {
    return ListTile(
      onTap: () async {
        await Navigator.push(context, MaterialPageRoute(builder: (context) {
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
                  'Lineas de Materiales $lineaMats',
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 15),
      child: GridView.builder(
        gridDelegate:
            SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
        itemBuilder: (context, index) {
          return GridTile(
            child: Container(
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ImagePage(ids[index]);
                      },
                    ),
                  );
                },
                child: Image.network(
                    'https://picsum.photos/id/${ids[index]}/300/300'),
              ),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.transparent, width: 10)),
            ),
          );
        },
        itemCount: ids.length,
      ),
    );
  }
}

class ImagePage extends StatelessWidget {
  final String id;
  ImagePage(this.id);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(backgroundColor: Colors.black),
      body:
          Center(child: Image.network('https://picsum.photos/id/$id/600/600')),
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
