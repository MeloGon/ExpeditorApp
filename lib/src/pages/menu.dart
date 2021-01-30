import 'dart:async';

import 'package:expeditor_app/api.dart';
import 'package:expeditor_app/src/pages/login_page.dart';
import 'package:expeditor_app/src/pages/ordenes_page.dart';
import 'package:expeditor_app/src/widgets/loginbg_widget.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'dart:ui';

import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:pie_chart/pie_chart.dart';

//import 'package:percent_indicator/circular_percent_indicator.dart';

class MenuPage extends StatefulWidget {
  final String token;
  final double cumpli;
  final int tipo;
  final Map map;
  MenuPage({this.token, this.cumpli, this.tipo, this.map});
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
  var porcentajeCumplido;
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

  var formater = new DateFormat('mm');

  var dt = DateTime.now();
  var fecha;

  //final menuprovider = MenuProvider();
  final controllerchanges = new StreamController<dynamic>();

  // Map<String, double> dataMap = {
  //   "Flutter": 5,
  //   "React": 3,
  //   "Xamarin": 2,
  //   "Ionic": 2,
  // };

  List<Color> listColors = [
    Color(0xffFFEC21),
    Color(0xff378AFF),
    Color(0xffFFA32F),
    Color(0xffF54F52),
    Color(0xff93F03B),
    Color(0xff9552EA)
  ];

  @override
  void initState() {
    porcentajeCumplido = widget.cumpli ?? 0;
    fecha = DateFormat.yMMMM('es').format(dt);
    print(widget.tipo);
    print(widget.map);
    super.initState();
  }

  // cargarCumplimiento() async {
  //   porcentajeCumplido = await porcentajeCumpli(widget.token) / 100;
  //   print(porcentajeCumplido);
  // }

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
                      'Inicio',
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
                  padding: EdgeInsets.only(left: 10, right: 10),
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
        lineWidth: 8.0,
        percent: porcentajeCumplido,
        center: new Text('${(porcentajeCumplido * 100).toStringAsFixed(0)}%'),
        progressColor: Colors.blue[300],
        backgroundColor: Colors.grey[200],
        animation: true,
        animationDuration: 1500,
      ),
    );

    Widget _valuePercentAll = Padding(
      padding: EdgeInsets.all(10),
      child: PieChart(
        dataMap: widget.map,
        animationDuration: Duration(milliseconds: 800),
        chartLegendSpacing: 32,
        chartRadius: MediaQuery.of(context).size.width / 3.2,
        colorList: listColors,
        initialAngleInDegree: 0,
        chartType: ChartType.ring,
        ringStrokeWidth: 9,
        legendOptions: LegendOptions(
          showLegendsInRow: false,
          legendPosition: LegendPosition.right,
          showLegends: true,
        ),
        chartValuesOptions: ChartValuesOptions(
          showChartValueBackground: true,
          showChartValues: true,
          showChartValuesInPercentage: true,
          showChartValuesOutside: true,
        ),
      ),
    );

    Widget _contentWe = Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text('Avances Preparativos', style: _titleCardStyle),
            Text(
              '$fecha'.toUpperCase(),
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
      // defaultColumnWidth: FixedColumnWidth(widget.tipo == 1 || widget.tipo == 2
      //     ? MediaQuery.of(context).size.width * 0.95
      //     : MediaQuery.of(context).size.width * 0.5),
      defaultColumnWidth:
          FixedColumnWidth(MediaQuery.of(context).size.width * 0.5),
      children: [
        TableRow(children: [
          // roundButtonWidget(widget.tipo == 1 || widget.tipo == 2
          //     ? _valuePercentAll
          //     : _contentWe)
          roundButtonWidget(_contentWe),
        ]),
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
          // height: widget.tipo == 1 || widget.tipo == 2 ? 350.0 : 188.0,
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
