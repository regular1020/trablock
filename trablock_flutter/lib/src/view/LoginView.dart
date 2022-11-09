import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/provider/AuthProvider.dart';
import 'package:trablock_flutter/src/provider/UserProvider.dart';

class LoginView extends StatefulWidget {
  LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  late AuthProvider _auth;
  late UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context, listen: false);
    _userProvider = Provider.of<UserProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text("로그인"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height*0.08,
              width: MediaQuery.of(context).size.width*0.5,
              child: TextButton(
                style: ButtonStyle(
                  padding: MaterialStateProperty.all<EdgeInsets>(const EdgeInsets.all(2.0)),
                  elevation: MaterialStateProperty.all<double>(2.0),
                  backgroundColor:
                    MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.grey;
                      } else {
                        return Colors.white;
                      }
                    }),
                ),
                child: const Text("LoginWithGoogle"),
                onPressed: () async {
                  String? id = await _auth.signInWithGoogle();
                  if (id != null) {
                    _userProvider.setID(id);
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
