import 'package:flutter/material.dart';

class DetalleMatPage extends StatefulWidget {
  final String token;
  final String nroot; //modificar eso del numero ot
  DetalleMatPage({this.token, this.nroot});
  @override
  _DetalleMatPageState createState() => _DetalleMatPageState();
}

class _DetalleMatPageState extends State<DetalleMatPage> {
  Color _colorTitle = Color(0xff6A6D70);
  Color _colorSubtitle = Color(0xff32363A);
  Color sapColor = Color(0xff354A5F);
  Color _iconColor = Color(0xff0854a1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: sapColor,
        automaticallyImplyLeading: false,
        title: Text(''),
      ),
      body: Stack(
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(bottom: 60),
              height: double.infinity,
              width: double.infinity,
              child: ListView(
                children: <Widget>[
                  detalleMat(),
                ],
              )),
          Align(
            alignment: Alignment.bottomCenter,
            child: SafeArea(
              child: Container(
                alignment: Alignment.bottomCenter,
                height: 60,
                width: double.infinity,
                child: _options(),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget detalleMat() {
    return Column(
      children: <Widget>[
        ListTile(
          title: Text(
            'Detalle Material',
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 19.0,
                fontFamily: 'fuente72',
                color: _colorSubtitle),
          ),
        ),
        Divider(
          indent: 9.0,
          endIndent: 9.0,
          height: 2,
          thickness: 1.0,
        ),
        ListTile(
          title: Text(
            'No. Material:',
            style: TextStyle(
                color: _colorTitle, fontFamily: 'fuente72', fontSize: 15),
          ),
          subtitle: Text(
            'CONJUNTO PERNO;AMSCRE;1919X6043829',
            style: TextStyle(
              color: _colorSubtitle,
              fontWeight: FontWeight.w500,
              fontSize: 16,
              fontFamily: 'fuente72',
            ),
          ),
        ),
        ListTile(
          title: Text(
            'Descripcion:',
            style: TextStyle(
              color: _colorTitle,
              fontFamily: 'fuente72',
              fontSize: 14,
            ),
          ),
          subtitle: Text(
            'Bodega Central',
            style: TextStyle(
                color: _colorSubtitle,
                fontWeight: FontWeight.w500,
                fontFamily: 'fuente72',
                fontSize: 16),
          ),
        ),
        ListTile(
          title: Text(
            'Ubicacion:',
            style: TextStyle(
                color: _colorTitle, fontFamily: 'fuente72', fontSize: 14),
          ),
          subtitle: Text(
            'Patio 9Q',
            style: TextStyle(
                color: _colorSubtitle,
                fontWeight: FontWeight.w500,
                fontFamily: 'fuente72',
                fontSize: 16),
          ),
        ),
        ListTile(
          title: Text(
            'Cant. Requerida:',
            style: TextStyle(
                color: _colorTitle, fontFamily: 'fuente72', fontSize: 14),
          ),
          subtitle: Text(
            '60 UN',
            style: TextStyle(
                color: _colorSubtitle,
                fontWeight: FontWeight.w500,
                fontFamily: 'fuente72',
                fontSize: 16),
          ),
        ),
        ListTile(
          title: Text(
            'Punto de Acopio:',
            style: TextStyle(
                color: _colorTitle, fontFamily: 'fuente72', fontSize: 14),
          ),
          subtitle: Text(
            '0',
            style: TextStyle(
                color: _colorSubtitle,
                fontWeight: FontWeight.w500,
                fontFamily: 'fuente72',
                fontSize: 16),
          ),
        ),
        ListTile(
          title: Text(
            'Cant. Entregada:',
            style: TextStyle(
                fontFamily: 'fuente72', fontSize: 14, color: _colorTitle),
          ),
          subtitle: Container(
            child: _inputCantidad(),
            margin: EdgeInsets.only(top: 10),
            height: 45,
          ),
          trailing: Container(
            padding: EdgeInsets.only(top: 8),
            width: 180.0,
            child: _operatorCant(),
          ),
        ),
        ListTile(
          title: Text(
            'Incidencias:',
            style: TextStyle(
                fontFamily: 'fuente72', fontSize: 14, color: _colorTitle),
          ),
          subtitle: Container(
            child: _inputIncidencia(),
            margin: EdgeInsets.only(top: 10),
            height: 45,
          ),
        ),
        ListTile(
          title: Text(
            'Notas:',
            style: TextStyle(
                fontFamily: 'fuente72', fontSize: 14, color: _colorTitle),
          ),
          subtitle:
              Container(margin: EdgeInsets.only(top: 10), child: _inputNotas()),
        ),
      ],
    );
  }

  Widget _inputCantidad() {
    return TextField(
      decoration: InputDecoration(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0))),
    );
  }

  Widget _inputIncidencia() {
    return TextField(
      decoration: InputDecoration(
          suffixIcon: Icon(Icons.keyboard_arrow_down),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0))),
    );
  }

  Widget _inputNotas() {
    return TextField(
      decoration: InputDecoration(
          hintText: 'Escriba aqui',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0))),
    );
  }

  Widget _options() {
    return Card(
      elevation: 6.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7.0)),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              FlatButton(
                  color: _iconColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(9)),
                  onPressed: () {
                    _guardar(context);
                  },
                  child: Text(
                    'Guardar',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'fuente72',
                        fontSize: 15,
                        fontWeight: FontWeight.w900),
                  )),
              FlatButton(
                  onPressed: () {},
                  child: Text(
                    'Cancelar',
                    style: TextStyle(
                        color: _iconColor,
                        fontSize: 15,
                        fontFamily: 'fuente72'),
                  )),
            ],
          )
        ],
      ),
    );
  }

  Widget _operatorCant() {
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            FlatButton(
              onPressed: () {},
              child: Icon(
                Icons.remove,
                color: _iconColor,
              ),
            ),
            FlatButton(
              onPressed: () {},
              child: Icon(
                Icons.add,
                color: _iconColor,
              ),
            )
          ],
        )
      ],
    );
  }

  void _guardar(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => new AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(4.0))),
              content: Builder(
                builder: (context) {
                  return Container(
                    child: Text(
                      'El registro de material fue guardado',
                      style: TextStyle(fontFamily: 'fuente72'),
                      textAlign: TextAlign.center,
                    ),
                  );
                },
              ),
            ));
  }
}
