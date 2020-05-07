import 'package:PTasker/services/auth.dart';
import 'package:flutter/material.dart';
import 'package:wave/config.dart';
import 'package:wave/wave.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  SignIn({this.toggleView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  String error = '';

  String email = '';

  String password = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            child: RotatedBox(
              quarterTurns: 4,
              child: WaveWidget(
                config: CustomConfig(
                  gradients: [
                    [Colors.deepPurple, Colors.deepPurple.shade200],
                    [Colors.indigo.shade200, Colors.purple.shade200],
                  ],
                  durations: [19440, 10800],
                  heightPercentages: [0.20, 0.25],
                  blur: MaskFilter.blur(BlurStyle.solid, 10),
                  gradientBegin: Alignment.topRight,
                  gradientEnd: Alignment.bottomLeft,
                ),
                waveAmplitude: 0,
                size: Size(
                  double.infinity,
                  double.infinity,
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                Container(
                  height: 500,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Вход",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white70,
                                fontWeight: FontWeight.bold,
                                fontSize: 28.0)),
                        Card(
                          margin: EdgeInsets.only(left: 30, right: 30, top: 30),
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: TextFormField(
                              decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.person,
                                    color: Colors.black26,
                                  ),
                                  suffixIcon: Icon(
                                    Icons.check_circle,
                                    color: Colors.black26,
                                  ),
                                  hintText: "Почта",
                                  hintStyle: TextStyle(color: Colors.black26),
                                  filled: true,
                                  fillColor: Colors.white,
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(40.0)),
                                  ),
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 16.0)),
                              validator: (val) =>
                                  val.isEmpty ? 'Введите почту' : null,
                              onChanged: (val) {
                                setState(() => email = val);
                              }),
                        ),
                        Card(
                          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                          elevation: 11,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40))),
                          child: TextFormField(
                            obscureText: true,
                            decoration: InputDecoration(
                                prefixIcon: Icon(
                                  Icons.lock,
                                  color: Colors.black26,
                                ),
                                hintText: "Пароль",
                                hintStyle: TextStyle(
                                  color: Colors.black26,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderSide: BorderSide.none,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(40.0)),
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 20.0, vertical: 16.0)),
                            validator: (val) =>
                                val.length < 6 ? 'Минимум 6 символов' : null,
                            onChanged: (val) {
                              setState(() => password = val);
                            },
                          ),
                        ),
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.all(30.0),
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            color: Colors.pink,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                dynamic result =
                                    await _auth.signInWithEmailAndPassword(
                                        email, password);
                                if (result == null) {
                                  setState(() {
                                    error = 'Не верная почта или пароль!';
                                  });
                                }
                              }
                            },
                            elevation: 11,
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(40.0))),
                            child: Text("Войти",
                                style: TextStyle(color: Colors.white70)),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text("Нет аккаунта?"),
                            FlatButton(
                              child: Text("Регистрация"),
                              textColor: Colors.indigo,
                              onPressed: () {
                                widget.toggleView();
                              },
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// SizedBox(
//   height: 100,
// ),
// Align(
//   alignment: Alignment.bottomCenter,
//   child: Column(
//     mainAxisAlignment: MainAxisAlignment.center,
//     children: <Widget>[
// Text("or, connect with"),
// SizedBox(
//   height: 20.0,
// ),
// Row(
//   children: <Widget>[
//     SizedBox(
//       width: 20.0,
//     ),
//     Expanded(
//       child: RaisedButton(
//         child: Text("Facebook"),
//         textColor: Colors.white,
//         color: Colors.blue,
//         shape: RoundedRectangleBorder(
//           borderRadius:
//               BorderRadius.all(Radius.circular(40)),
//         ),
//         onPressed: () {},
//       ),
//     ),
//     SizedBox(
//       width: 10.0,
//     ),
//     Expanded(
//       child: RaisedButton(
//         child: Text("Twitter"),
//         textColor: Colors.white,
//         color: Colors.indigo,
//         shape: RoundedRectangleBorder(
//           borderRadius:
//               BorderRadius.all(Radius.circular(40)),
//         ),
//         onPressed: () {},
//       ),
//     ),
//     SizedBox(
//       width: 20.0,
//     ),
//   ],
// ),
// Row(
//   mainAxisAlignment: MainAxisAlignment.center,
//   children: <Widget>[
//     Text("Dont have an account?"),
//     FlatButton(
//       child: Text("Sign up"),
//       textColor: Colors.indigo,
//       onPressed: () {},
//     )
//   ],
// )
//     ],
//   ),
// )
