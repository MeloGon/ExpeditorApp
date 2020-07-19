import 'package:expeditor_app/src/models/orden_model.dart';
import 'package:expeditor_app/src/pages/detallesot_page.dart';
import 'package:flutter/material.dart';
import 'package:expeditor_app/api.dart';
import 'package:intl/intl.dart';

class OrdenesPage extends StatefulWidget {
  final String token;
  OrdenesPage({this.token});
  @override
  _OrdenesPageState createState() => _OrdenesPageState();
}

class _OrdenesPageState extends State<OrdenesPage> {
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

  @override
  Widget build(BuildContext context) {
    // print(widget.token); receive data works
    return Scaffold(
      appBar: AppBar(
        backgroundColor: _sapColor,
        automaticallyImplyLeading: false,
        title: Text('Inicio'),
        actions: <Widget>[
          IconButton(icon: Icon(Icons.more_horiz), onPressed: () {}),
          _perfilCircle(),
        ],
      ),
      body: Container(
        height: double.infinity,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _panelFiltros(),
            _panelContador(),
            _panelCabecera(),
            Expanded(child: _panelLista(context)),
          ],
        ),
      ),
    );
  }

  Widget _perfilCircle() {
    return Container(
        child: CircleAvatar(
          child: Text('KM'),
          backgroundColor: Colors.white,
        ),
        margin: EdgeInsets.only(right: 15.0));
  }

  Widget _panelFiltros() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                'Estándar',
                style: TextStyle(fontSize: 24, color: _colorBlue),
              ),
              Icon(
                Icons.keyboard_arrow_down,
                size: 30,
              ),
            ],
          ),
          Text('No Filtrado')
        ],
      ),
    );
  }

  Widget _panelContador() {
    return Container(
      width: double.infinity,
      child: Text(
        'Órdenes de trabajo(7)',
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
            return ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: ordenes.length,
              itemBuilder: (context, i) {
                return itemOt(ordenes[i]);
              },
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
                Text('Criticidad: '),
                Text(
                  '${orden.criticidad}',
                  style: _estiloItemStat,
                ),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Text('Área: '),
                Text('${orden.area}', style: _estiloItemStat),
              ],
            ),
            SizedBox(
              height: 5,
            ),
            Row(
              children: <Widget>[
                Text('No. Reserva: '),
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
                Text('Fecha Movilización: '),
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
                    style: TextStyle(color: Color(0xffE9730C), fontSize: 14),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 15,
                  ),
                ],
              ),
              Icon(
                Icons.warning,
                color: Color(0xffE9730C),
              ),
              SizedBox(height: 15)
            ],
          ),
        ),
      ),
    );
  }
}
