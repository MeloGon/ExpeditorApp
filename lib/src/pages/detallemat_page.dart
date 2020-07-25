import 'package:expeditor_app/api.dart';
import 'package:expeditor_app/src/pages/detallesot_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hexcolor/hexcolor.dart';

class DetalleMatPage extends StatefulWidget {
  final String token,
      idmate,
      codmate,
      descripcion,
      lugar,
      ubicacion,
      cantre,
      unidad,
      acopio,
      canten,
      incidencia,
      nota;
  DetalleMatPage(
      {this.token,
      this.idmate,
      this.codmate,
      this.descripcion,
      this.lugar,
      this.ubicacion,
      this.cantre,
      this.unidad,
      this.acopio,
      this.canten,
      this.incidencia,
      this.nota});
  @override
  _DetalleMatPageState createState() => _DetalleMatPageState();
}

class _DetalleMatPageState extends State<DetalleMatPage> {
  String _opcionSeleccionada;
  int cod_incidencia;
  List<String> _poderes = [
    'ST - Sin stock',
    'SU - Sin ubicación',
    'TR - En Transito',
    'PS - Patio salvataje',
    'TE - En terreno',
    'RB - Retiro desde Bodega',
    'Sin incidencia',
  ];
  int prueba = 4;
  String nota_enviar = "";
  int cantParse;
  String notaa;
  Color _colorTitle = Color(0xff6A6D70);
  Color _colorSubtitle = Color(0xff32363A);
  Color sapColor = Color(0xff354A5F);
  Color _iconColor = Color(0xff0854a1);
  TextEditingController _controller;

  @override
  void initState() {
    super.initState();

    if (widget.incidencia.contains("ST - Sin stock")) {
      _opcionSeleccionada = "ST - Sin stock";
    }
    if (widget.incidencia.contains("SU - Sin ubicación")) {
      _opcionSeleccionada = "SU - Sin ubicación";
    }
    if (widget.incidencia.contains("TR - En Transito")) {
      _opcionSeleccionada = "TR - En Transito";
    }
    if (widget.incidencia.contains("PS - Patio salvataje")) {
      _opcionSeleccionada = "PS - Patio salvataje";
    }
    if (widget.incidencia.contains("TE - En terreno")) {
      _opcionSeleccionada = "TE - En terreno";
    }
    if (widget.incidencia.contains("RB - Retiro desde Bodega")) {
      _opcionSeleccionada = "RB - Retiro desde Bodega";
    }
    setState(() {
      print(widget.nota);
      _controller = new TextEditingController(text: widget.nota.toString());
      if (int.parse(widget.canten) == 0) {
        cantParse = int.parse(widget.cantre);
      } else {
        cantParse = int.parse(widget.canten);
      }
    });
  }

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
                child: _options(context),
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
            '${widget.codmate}',
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
            '${widget.descripcion}',
            style: TextStyle(
                color: _colorSubtitle,
                fontWeight: FontWeight.w500,
                fontFamily: 'fuente72',
                fontSize: 16),
          ),
        ),
        ListTile(
          title: Text(
            'Lugar:',
            style: TextStyle(
                color: _colorTitle, fontFamily: 'fuente72', fontSize: 14),
          ),
          subtitle: Text(
            '${widget.lugar ?? ""}',
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
            '${widget.ubicacion}',
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
            '${widget.cantre}' + ' ' + '${widget.unidad ?? " "}',
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
            '${widget.acopio ?? " "}',
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
            width: double.infinity,
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
      controller: TextEditingController(text: '$cantParse'),
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(10),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0))),
    );
  }

  Widget _inputIncidencia() {
    if (_opcionSeleccionada == 'ST - Sin stock') {
      cod_incidencia = 1;
      print(cod_incidencia);
    }
    if (_opcionSeleccionada == 'SU - Sin ubicación') {
      cod_incidencia = 2;
      print(cod_incidencia);
    }
    if (_opcionSeleccionada == '"TR - En Transito') {
      cod_incidencia = 3;
      print(cod_incidencia);
    }
    if (_opcionSeleccionada == 'PS - Patio salvataje') {
      cod_incidencia = 4;
      print(cod_incidencia);
    }
    if (_opcionSeleccionada == 'TE - En terreno') {
      cod_incidencia = 5;
      print(cod_incidencia);
    }
    if (_opcionSeleccionada == 'RB - Retiro desde Bodega') {
      cod_incidencia = 6;
      print(cod_incidencia);
    }
    if (_opcionSeleccionada == 'Sin incidencia') {
      cod_incidencia = 0;
      print(cod_incidencia);
    }
    return Padding(
      padding: EdgeInsets.only(left: 1, right: 1),
      child: Container(
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
            border: Border.all(color: Hexcolor('#89919A'), width: 0.9)),
        child: DropdownButton(
          hint: Text('Seleccione'),
          style: TextStyle(fontFamily: 'fuente72', color: Colors.black),
          value: _opcionSeleccionada,
          icon: Icon(
            Icons.arrow_drop_down,
            color: _iconColor,
          ),
          isExpanded: true,
          items: getOpcionesDropdown(),
          onChanged: (opt) {
            setState(() {
              _opcionSeleccionada = opt;
            });
            if (_opcionSeleccionada == 'ST - Sin stock') {
              cod_incidencia = 1;
              print(cod_incidencia);
            }
            if (_opcionSeleccionada == 'SU - Sin ubicación') {
              cod_incidencia = 2;
              print(cod_incidencia);
            }
            if (_opcionSeleccionada == '"TR - En Transito') {
              cod_incidencia = 3;
              print(cod_incidencia);
            }
            if (_opcionSeleccionada == 'PS - Patio salvataje') {
              cod_incidencia = 4;
              print(cod_incidencia);
            }
            if (_opcionSeleccionada == 'TE - En terreno') {
              cod_incidencia = 5;
              print(cod_incidencia);
            }
            if (_opcionSeleccionada == 'RB - Retiro desde Bodega') {
              cod_incidencia = 6;
              print(cod_incidencia);
            }
            if (_opcionSeleccionada == 'Sin incidencia') {
              cod_incidencia = 0;
              print(cod_incidencia);
            }
          },
        ),
      ),
    );
  }

  List<DropdownMenuItem<String>> getOpcionesDropdown() {
    List<DropdownMenuItem<String>> lista = new List();

    _poderes.forEach((poder) {
      lista.add(DropdownMenuItem(
        child: Text(poder),
        value: poder,
      ));
    });

    return lista;
  }

  Widget _inputNotas() {
    return TextField(
      controller: _controller,
      onChanged: (value) {
        setState(() {
          notaa = value;
        });
      },
      decoration: InputDecoration(
          hintText: 'Escriba aqui',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(2.0))),
    );
  }

  Widget _options(BuildContext context) {
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
                  onPressed: () async {
                    var rsp = await editarCantidad(
                        widget.token,
                        int.parse(widget.idmate),
                        cantParse,
                        cod_incidencia,
                        notaa ?? widget.nota);
                    if (rsp['code'] == 200) {
                      _guardar(context);
                    }
                  },
                  child: Text(
                    'Guardar',
                    style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'fuente72',
                        fontSize: 15,
                        fontWeight: FontWeight.w700),
                  )),
              FlatButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
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
              onPressed: () {
                setState(() {
                  cantParse--;
                });
              },
              child: Icon(
                Icons.remove,
                color: _iconColor,
              ),
            ),
            FlatButton(
              onPressed: () {
                setState(() {
                  cantParse++;
                });
              },
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
    showDialog<String>(
        context: context,
        builder: (BuildContext context) => new AlertDialog(
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

    Future.delayed(const Duration(milliseconds: 900), () {
      setState(() {
        Navigator.pop(context);
        Navigator.pop(context);
      });
    });
  }
}
