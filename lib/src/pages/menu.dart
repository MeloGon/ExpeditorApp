import 'dart:async';

import 'package:expeditor_app/api.dart';
import 'package:expeditor_app/src/pages/login_page.dart';
import 'package:expeditor_app/src/pages/ordenes_page.dart';
import 'package:expeditor_app/src/widgets/loginbg_widget.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:ui';

import 'package:percent_indicator/circular_percent_indicator.dart';

//import 'package:percent_indicator/circular_percent_indicator.dart';

class MenuPage extends StatefulWidget {
  final String token;
  MenuPage({this.token});
  @override
  _MenuPageState createState() => _MenuPageState();
}

class _MenuPageState extends State<MenuPage> {
  List<BoxShadow> _shadowsCards = [
    BoxShadow(
      color: Colors.black26,
      offset: Offset(0.0, 2.0), //(x,y)
      blurRadius: 8.0,
    ),
  ];

  Color _appBarColor = Color(0xff354A5F);
  dynamic cumplimiento;
  List lista;
  // Color _subtitleColor = Color(0xff6A6D70);
  TextStyle _titleStyle = TextStyle(
      fontSize: 18.0,
      fontFamily: 'fuente72',
      color: Color(0xff32363A),
      fontWeight: FontWeight.normal);

  TextStyle _titleCardStyle = TextStyle(
      fontSize: 16.0,
      fontFamily: 'fuente72',
      color: Color(0xff32363A),
      fontWeight: FontWeight.normal);

  TextStyle _subtitleCardStyle = TextStyle(
      fontSize: 14.0,
      fontFamily: 'fuente72',
      color: Color(0xff6A6D70),
      fontWeight: FontWeight.normal);

  TextStyle _numberCardStyle = TextStyle(
      fontSize: 40.0,
      fontFamily: 'fuente72',
      color: Color(0xff6A6D70),
      fontWeight: FontWeight.normal);

  TextStyle _changeStyle = TextStyle(
      fontSize: 14.0, fontFamily: 'fuente72', color: Color(0xff0A6ED1));
  var formater = new DateFormat('mm');
  //final menuprovider = MenuProvider();
  final controllerchanges = new StreamController<dynamic>();

  @override
  void initState() {
    cargarCumplimiento();
    super.initState();
  }

  cargarCumplimiento() async {
    lista = await porcentajeCumpli(widget.token);
    // print('esto es cumplimiento $cumplimiento');
    lista.forEach((element) {
      print(element);
    });
  }

  @override
  void dispose() {
    controllerchanges.close();
    super.dispose();
  }

  //final fifteenAgo = new DateTime.now().subtract(new Duration(minutes: 15));
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () => Future.value(false),
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              title: PopupMenuButton<String>(
                child: Row(
                  children: <Widget>[
                    Text(
                      'Menu',
                    ),
                    Icon(Icons.arrow_drop_down)
                  ],
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                  PopupMenuItem<String>(
                    value: "cerrar_sesion",
                    child: Text(
                      "Programa Semanal",
                      style: TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
                    ),
                  ),
                ],
                onSelected: (value) {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return OrdenesPage(
                      token: widget.token,
                    );
                  }));
                },
                /* onSelected: (value) {
                      if (value == "cerrar_sesion") {
                        print('Menu');
                      }
                    },*/
              ),
              //title: Text('Inicio',
              //style: TextStyle(fontFamily: 'fuente72', fontSize: 14.0)),
              backgroundColor: _appBarColor,
              centerTitle: false,
              actions: [
                PopupMenuButton<String>(
                  child: Row(
                    children: <Widget>[
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 20.0,
                        child: Icon(
                          Icons.supervised_user_circle,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  itemBuilder: (BuildContext context) =>
                      <PopupMenuEntry<String>>[
                    PopupMenuItem<String>(
                      value: "cerrar_sesion",
                      child: Text(
                        "Cerrar Sesión",
                        style:
                            TextStyle(fontFamily: 'fuente72', fontSize: 13.0),
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    if (value == "cerrar_sesion") {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return LoginPage();
                      }));
                    }
                  },
                ),
              ],
            ),
            body: Stack(
              children: <Widget>[
                LoguinBackground(),
                SingleChildScrollView(
                  padding: EdgeInsets.only(left: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _titulos("Órdenes de Trabajo"),
                      _botonesRedondeadosOT(),
                    ],
                  ),
                )
              ],
            )),
      ),
    );
  }

  Widget _titulos(String titleValue) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 15.0, left: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(titleValue.toString(), style: _titleStyle),
          ],
        ),
      ),
    );
  }

  Widget _botonesRedondeadosOT() {
    Widget _valueProgressCircular = Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: CircularPercentIndicator(
        radius: 60.0,
        lineWidth: 5.0,
        percent: 0.81,
        center: new Text("81%"),
        progressColor: Colors.blue[300],
        backgroundColor: Colors.grey[200],
        animation: true,
        animationDuration: 1500,
      ),
    );

    Widget _contentWe = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Cumplimiento', style: _titleCardStyle),
            Text(
              '2021',
              style: _subtitleCardStyle,
            ),
            // Text('2020W31', style: _subtitleCardStyle),
            Align(
                alignment: Alignment.bottomRight,
                child: _valueProgressCircular),
            SizedBox(height: 5.0)
          ],
        ));

    return Table(
      defaultColumnWidth:
          FixedColumnWidth(MediaQuery.of(context).size.width * 0.5),
      children: [
        TableRow(children: [roundButtonWidget(_contentWe)]),
      ],
    );
  }

  roundButtonWidget(Widget content) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) {
          return OrdenesPage(
            token: widget.token,
          );
        }));
      },
      child: ClipRect(
        child: Container(
          height: 188.0,
          margin: EdgeInsets.all(15.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4.0),
            boxShadow: _shadowsCards,
          ),
          child: content,
        ),
      ),
    );
  }
}
