import 'package:expeditor_app/my_flutter_app_icons.dart';
import 'package:expeditor_app/src/models/orden_model.dart';
import 'package:expeditor_app/src/pages/detallesot_page.dart';
import 'package:expeditor_app/src/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:expeditor_app/api.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:intl/intl.dart';

class OrdenesPage extends StatefulWidget {
  final String token;
  OrdenesPage({this.token});
  @override
  _OrdenesPageState createState() => _OrdenesPageState();
}

class Item {
  Item({
    this.expandedValue,
    this.headerValue,
    this.isExpanded = false,
  });

  String expandedValue;
  String headerValue;
  bool isExpanded;
}

List<Item> generateItems(int numberOfItems) {
  return List.generate(numberOfItems, (int index) {
    return Item(
      headerValue: 'Panel $index',
      expandedValue: 'This is item number $index',
    );
  });
}

// ...

List<Item> _data = generateItems(1);

class _OrdenesPageState extends State<OrdenesPage> {
  dynamic cantidadOrdenes;
  Color _sapColor = Color(0xff354A5F);
  Color _colorBlue = Color(0xff0854A1);
  Color _colorPanelCabecera = Color(0xffF2F2F2);
  TextStyle _estiloItemDescr = TextStyle(
      fontSize: 14, fontFamily: 'fuente72', fontWeight: FontWeight.w700);
  TextStyle _estiloItemNro = TextStyle(
      fontSize: 16,
      fontFamily: 'fuente72',
      fontWeight: FontWeight.w700,
      color: Color(0xff0A6ED1));
  TextStyle _estiloItemStat = TextStyle(
    fontSize: 14,
    fontFamily: 'fuente72',
    color: Color(0xff32363A),
  );
  TextEditingController _inputFieldDateController = new TextEditingController();
  String _fecha = '';
  String _opcionSeleccionada;
  String filtroBusqueda = "";

  List<OrdenModel> listaOrdenToda = new List<OrdenModel>();
  List<OrdenModel> listaOrdenTodaFiltrada = new List<OrdenModel>();
  var formaterGeneral = new DateFormat('MMM d, yyyy');

  @override
  void initState() {
    cargarOrdenes(widget.token).then((value) {
      setState(() {
        listaOrdenToda = value;
        listaOrdenTodaFiltrada = listaOrdenToda;
        cantidadOrdenes = listaOrdenToda.length;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // print(widget.token); receive data works
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: _sapColor,
        automaticallyImplyLeading: false,
        title: Text('Inicio'),
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.sync,
              ),
              onPressed: () {
                setState(() {
                  cargarOrdenes(widget.token).then((value) {
                    setState(() {
                      listaOrdenToda = value;
                      listaOrdenTodaFiltrada = listaOrdenToda;
                      cantidadOrdenes = listaOrdenToda.length;
                    });
                  });
                });
              }),
          //_perfilCircle(context),
          PopupMenuButton<String>(
            icon: Icon(
              Icons.supervised_user_circle,
            ),
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              // PopupMenuItem<String>(
              //   value: "perfil",
              //   child: Text(
              //     "Perfil (En desarrollo)",
              //     style: TextStyle(fontFamily: 'fuente72'),
              //   ),
              // ),
              PopupMenuItem<String>(
                value: "cerrar_sesion",
                child: Text(
                  "Cerrar Sesion",
                  style: TextStyle(fontFamily: 'fuente72'),
                ),
              ),
            ],
            onSelected: (value) {
              //     if (value == "tomar_foto") {
              // print('Nothing');
              if (value == "cerrar_sesion") {
                cerrarSesion();
              }
            },
          )
        ],
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _panelFiltros(context),
            _panelContador(),
            _panelCabecera(),
            Expanded(child: _panelLista(context)),
          ],
        ),
      ),
    );
  }

  Widget _perfilCircle(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      child: CircleAvatar(
        // child: Text('KM'),
        child: Icon(
          Icons.supervised_user_circle,
          color: _sapColor,
        ),
        backgroundColor: Colors.white,
      ),
    );
    // margin: EdgeInsets.only(right: 15.0));
  }

  Widget _panelFiltros(BuildContext context) {
    return ExpansionPanelList(
      animationDuration: Duration(milliseconds: 300),
      expansionCallback: (int index, bool isExpanded) {
        setState(() {
          _data[index].isExpanded = !isExpanded;
        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                title: Text(
                  'Estándar',
                  style: TextStyle(
                      fontSize: 24, color: _colorBlue, fontFamily: 'fuente72'),
                ),
              ),
            );
          },
          body: creandoFiltros(context),
          isExpanded: item.isExpanded,
        );
      }).toList(),
    );
  }

  Widget _panelContador() {
    return Container(
      width: double.infinity,
      child: Text(
        'Órdenes de trabajo (' + '${cantidadOrdenes ?? "Estimando ..."})',
        style: TextStyle(fontFamily: 'fuente72', fontSize: 18),
      ),
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
    );
  }

  Widget _panelCabecera() {
    return Container(
      color: _colorPanelCabecera,
      width: double.infinity,
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Text(
            'No. Orden',
            style: _estiloItemStat,
          )),
          Text(
            'Cumplimiento',
            style: _estiloItemStat,
          ),
        ],
      ),
    );
  }

  Widget _panelLista(BuildContext context) {
    return FutureBuilder(
        future: cargarOrdenes(widget.token),
        builder:
            (BuildContext context, AsyncSnapshot<List<OrdenModel>> snapshot) {
          if (snapshot.hasData) {
            final ordenes = snapshot.data;
            return RefreshIndicator(
              onRefresh: refrescarLista,
              child: ListView.builder(
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: listaOrdenTodaFiltrada.length,
                itemBuilder: (context, i) {
                  return itemOt(listaOrdenTodaFiltrada[i]);
                },
              ),
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        });
  }

  Widget itemOt(OrdenModel orden) {
    var formater = new DateFormat('MMM d, yyyy');
    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: ListTile(
        onTap: () async {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return DetallesOT(
              token: widget.token,
              nroot: '${orden.nroOt}',
              idot: '${orden.id}',
              descriot: '${orden.descripcion}',
              areaot: '${orden.area}',
              criti: '${orden.criticidad}',
              critico: '${orden.criticidadColor}',
              noreserva: '${orden.nroReserva}',
              cantnece: '${orden.cantNecesaria}',
              cantreque: '${orden.cantEntregada}',
              cumpli: '${orden.cumplimiento}',
              fechamovi: '${orden.fechaMovilizacion}',
            );
          }));
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 9,
            ),
            Text(
              '${orden.nroOt}',
              style: _estiloItemNro,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              '${orden.descripcion}',
              style: _estiloItemDescr,
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
                Text(
                  'Criticidad: ',
                  style: TextStyle(fontFamily: 'fuente72'),
                ),
                Text(
                  '${orden.criticidad}',
                  style: TextStyle(
                      fontFamily: 'fuente72',
                      fontSize: 14,
                      color: Hexcolor('${orden.criticidadColor}')),
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Text('Área: ', style: TextStyle(fontFamily: 'fuente72')),
                Text('${orden.area}', style: _estiloItemStat),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Text('Subsistema: ', style: TextStyle(fontFamily: 'fuente72')),
                Flexible(
                    child: Text('${orden.subsistema}', style: _estiloItemStat)),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Text('No. Reserva: ', style: TextStyle(fontFamily: 'fuente72')),
                Text(
                  '${orden.nroReserva}',
                  style: _estiloItemStat,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Text('Fecha Movilización: ',
                    style: TextStyle(fontFamily: 'fuente72')),
                Text(
                  formater.format(DateTime.parse('${orden.fechaMovilizacion}')),
                  style: _estiloItemStat,
                ),
              ],
            ),
          ],
        ),
        trailing: Container(
          width: 52,
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Text(
                    '${orden.cumplimiento}%',
                    style: TextStyle(
                        fontFamily: 'fuente72',
                        color: colorCumplimiento('${orden.cumplimiento}'),
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ],
              ),
              SizedBox(
                height: 5,
              ),
              Icon(
                iconOt('${orden.nota}'),
                size: 17,
                color: Color(0xffE9730C),
              ),
              SizedBox(height: 15)
            ],
          ),
        ),
      ),
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

  IconData iconOt(String x) {
    if (x == "1") {
      return MyFlutterApp.warning_empty;
    }
  }

  Future<Null> refrescarLista() async {
    setState(() {
      cargarOrdenes(widget.token);
    });
  }

  Widget creandoFiltros(BuildContext context) {
    // print(_inputFieldDateController.text);
    //2020-07-24 00:00:00.000
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextField(
            onChanged: (value) {
              setState(() {
                print(value);
                listaOrdenTodaFiltrada = listaOrdenToda
                    .where((u) => (u.nroOt
                            .toLowerCase()
                            .contains(value.toLowerCase()) ||
                        u.descripcion
                            .toLowerCase()
                            .contains(value.toLowerCase()) ||
                        u.criticidad
                            .toLowerCase()
                            .contains(value.toLowerCase()) ||
                        u.area.toLowerCase().contains(value.toLowerCase()) ||
                        u.nroReserva
                            .toLowerCase()
                            .contains(value.toLowerCase())))
                    .toList();
              });
            },
            style: TextStyle(
              fontFamily: 'fuente72',
              fontSize: 14,
            ),
            decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(2.0)),
                hintText: 'Buscar',
                suffixIcon: Icon(
                  Icons.search,
                  color: Color(0xff0854a0),
                )),
          ),
          SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    //getfiltros(widget.token);
    List<DropdownMenuItem<String>> lista = new List();

    lista.add(DropdownMenuItem(child: Text('area1'), value: 'area1'));

    return lista;
  }

  List<DropdownMenuItem<String>> getOpcionesDropdownArea() {
    List<DropdownMenuItem<String>> lista = new List();

    lista.add(DropdownMenuItem(child: Text('area1'), value: 'area1'));

    return lista;
  }

  _selectDate(BuildContext context) async {
    DateTime escogida = await showDatePicker(
        context: context,
        initialDate: new DateTime.now(),
        firstDate: new DateTime(2020),
        lastDate: new DateTime(2025),
        locale: Locale('es', 'ES'));
    var formaterfiltro = new DateFormat('MMM d, yyyy');
    if (escogida != null) {
      setState(() {
        //_fecha = escogida.toString();
        _fecha = formaterfiltro.format(escogida).toString();
        //_inputFieldDateController.text = _fecha;
        _inputFieldDateController.text = _fecha;
      });
    }
  }

  void cerrarSesion() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return LoginPage();
    }));
  }
}
