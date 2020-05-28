import 'package:PTasker/screens/authenticate/authenticate.dart';
import 'package:PTasker/screens/new_design/home.dart';
import 'package:PTasker/services/auth.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: AuthService().user,
        builder: (context, snapshot) {
          if (snapshot.data == null) {
            return Authenticate();
          } else {
            return HomePage();
          }
        });
  }
}
