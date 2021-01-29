import 'package:expeditor_app/api.dart';
import 'package:expeditor_app/src/pages/menu.dart';
import 'package:expeditor_app/src/pages/ordenes_page.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController(text: '');
  TextEditingController passwordController = TextEditingController(text: '');
  String message = '';
  Color _colorGradbeg = Color(0xffDFE3E4);
  Color _colorGradend = Color(0xffF3F4F5);
  Color _colorBoton = Color(0xff0A6ED1);
  TextStyle estiloTexto =
      TextStyle(fontFamily: 'fuente72', fontSize: 14, color: Color(0xff354A5F));

  @override
  void initState() {
    cargarPref();
    super.initState();
  }

  cargarPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emailController = TextEditingController(text: prefs.get('correo'));
    passwordController = TextEditingController(text: prefs.get('pwd'));
    setState(() {});
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => Future.value(false),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Stack(
          children: <Widget>[
            _fondoApp(),
            _crearTarjeta(context),
            _textoCopy(),
          ],
        ),
      ),
    );
  }

  Widget _fondoApp() {
    return Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [_colorGradbeg, _colorGradend],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ));
  }

  Widget _crearTarjeta(BuildContext context) {
    return SafeArea(
      child: Container(
          width: double.infinity,
          height: 450,
          margin: EdgeInsets.only(top: 60, left: 15, right: 15),
          child: Card(
            elevation: 20,
            child: Form(
              key: _formkey,
              child: Column(
                children: <Widget>[
                  _crearImagen(),
                  Container(
                      padding: EdgeInsets.only(left: 60),
                      width: double.infinity,
                      child: Text(
                        'Usuario:',
                        style: estiloTexto,
                      )),
                  _crearInputuser(),
                  SizedBox(
                    height: 12,
                  ),
                  Container(
                      padding: EdgeInsets.only(left: 60),
                      width: double.infinity,
                      child: Text(
                        'Contraseña:',
                        style: estiloTexto,
                      )),
                  _crearInputpass(),
                  Expanded(child: SizedBox()),
                  _crearBoton(context),
                ],
              ),
            ),
          )),
    );
  }

  Widget _crearImagen() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 40, horizontal: 60),
      width: 90,
      height: 64,
      child: Image(image: AssetImage('assets/logo.png')),
    );
  }

  Widget _crearInputuser() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60),
      height: 48,
      child: TextFormField(
        controller: emailController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
        validator: (value) {
          if (value.isEmpty) {
            return 'Ingrese un usuario';
          }
          return null;
        },
      ),
    );
  }

  Widget _crearInputpass() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 60),
      height: 48,
      child: TextFormField(
        obscureText: true,
        controller: passwordController,
        decoration: InputDecoration(
            contentPadding: EdgeInsets.all(10), border: OutlineInputBorder()),
        validator: (value) {
          if (value.isEmpty) {
            return 'Ingrese un usuario';
          }
          return null;
        },
      ),
    );
  }

  Widget _crearBoton(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 70),
      padding: EdgeInsets.symmetric(horizontal: 60),
      child: RaisedButton(
        child: Text(
          'Iniciar Sesión',
          style: TextStyle(
            color: Colors.white,
            fontFamily: 'fuente72',
            fontWeight: FontWeight.w700,
          ),
        ),
        onPressed: () async {
          var email = emailController.text;
          var password = passwordController.text;
          if (email.isEmpty || password.isEmpty) {
            Fluttertoast.showToast(
                msg: "Campos Vacios ..",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 14.0);
          } else {
            Fluttertoast.showToast(
                msg: "Validando credenciales ...",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.TOP,
                timeInSecForIosWeb: 1,
                backgroundColor: Colors.white,
                textColor: Colors.black,
                fontSize: 14.0);
            var rsp = await loginUser(email, password);
            if (rsp['code'] == 200) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              prefs.setString('correo', email);
              prefs.setString('pwd', password);
              var tipUser = await tipoUsuario(email, password);
              var cumpli = await porcentajeCumpli(rsp['message'], tipUser);
              print(tipUser);
              Fluttertoast.showToast(
                  msg: "Loguin Exitoso",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.blue[300],
                  textColor: Colors.white,
                  fontSize: 14.0);
              // Navigator.push(context, MaterialPageRoute(builder: (context) {
              //   return OrdenesPage(
              //     token: rsp['message'],
              //   );
              // }));
              if (cumpli is double) {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MenuPage(
                    token: rsp['message'],
                    cumpli: cumpli / 100,
                    tipo: tipUser,
                    map: null,
                  );
                }));
              } else {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return MenuPage(
                    token: rsp['message'],
                    cumpli: 20 / 100,
                    tipo: tipUser,
                    map: cumpli,
                  );
                }));
              }
            } else {
              Fluttertoast.showToast(
                  msg: "Credenciales Invalidos. Vuelva a intentarlo porfavor.",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.TOP,
                  timeInSecForIosWeb: 1,
                  backgroundColor: Colors.red[300],
                  textColor: Colors.white,
                  fontSize: 14.0);
            }
          }
        },
        color: _colorBoton,
      ),
    );
  }

  Widget _textoCopy() {
    return Container(
      padding: EdgeInsets.only(bottom: 15),
      alignment: Alignment.bottomCenter,
      child: Text(
        '© 2020 Innovadis | Todos los derechos reservados',
        style: estiloTexto,
      ),
    );
  }

  // void _login(BuildContext context) {
  //   final route = MaterialPageRoute(builder: (context) => OrdenesPage());
  //   Navigator.push(context, route);
  // }
}
