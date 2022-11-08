import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:trablock_flutter/src/provider/AuthProvider.dart';

class LoginWithGoogleView extends StatefulWidget {
  LoginWithGoogleView({Key? key}) : super(key: key);

  @override
  State<LoginWithGoogleView> createState() => _LoginWithGoogleViewState();
}

class _LoginWithGoogleViewState extends State<LoginWithGoogleView> {
  AuthProvider? _auth;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _auth = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("로그인"),
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
                  padding: MaterialStateProperty.all<EdgeInsets>(EdgeInsets.all(2.0)),
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
                onPressed: () {
                  _auth!.signInWithGoogle();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
