import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:tagline_demo/constants.dart';
import 'package:tagline_demo/screens/home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  bool modalLoading = false;

  @override
  Widget build(BuildContext context) {
    Color getColor(Set states) {
      const Set interactiveStates = {
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue[300];
      }
      return Colors.blue;
    }

    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: modalLoading,
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                FlutterLogo(
                  size: 60.0,
                ),
                SizedBox(
                  height: 15.0,
                ),
                Text(
                  "WelCome In Tagline Demo",
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.w800,
                      fontSize: 19.0),
                ),
                SizedBox(
                  height: 20.0,
                ),
                TextField(
                  controller: _emailController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      labelText: "Email",
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 15.0,
                ),
                TextField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 10.0),
                      labelText: "Password",
                      enabledBorder: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder()),
                ),
                SizedBox(
                  height: 20.0,
                ),
                SizedBox(
                  height: 40.0,
                  child: ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus();
                      setState(() {
                        modalLoading = true;
                      });
                      bool success = await loginWithEmail();
                      setState(() {
                        modalLoading = false;
                      });

                      if (success) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomeScreen.routeName, (route) => false);
                      }
                    },
                    child: Text("SignUp With Email"),
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith(getColor)),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                Row(
                  children: [
                    Expanded(
                        child: Divider(
                      thickness: 2.0,
                      endIndent: 5.0,
                      color: Colors.blue[300],
                    )),
                    Text(
                      "OR",
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 18.0,
                          fontWeight: FontWeight.w700),
                    ),
                    Expanded(
                        child: Divider(
                      color: Colors.blue[300],
                      thickness: 2.0,
                      indent: 5.0,
                    )),
                  ],
                ),
                SizedBox(
                  height: 25.0,
                ),
                Row(
                  children: [
                    Expanded(
                        child:
                            SignInButton(Buttons.Google, onPressed: () async {
                      setState(() {
                        modalLoading = true;
                      });
                      bool success = await withGoogleSignUp();
                      setState(() {
                        modalLoading = false;
                      });

                      if (success) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomeScreen.routeName, (route) => false);
                      }
                    })),
                    SizedBox(
                      width: 15.0,
                    ),
                    Expanded(
                        child: SignInButton(Buttons.FacebookNew,
                            onPressed: () async {
                      setState(() {
                        modalLoading = true;
                      });
                      bool success = await withFacebookSingUp();
                      setState(() {
                        modalLoading = false;
                      });

                      if (success) {
                        Navigator.pushNamedAndRemoveUntil(
                            context, HomeScreen.routeName, (route) => false);
                      }
                    }))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> loginWithEmail() async {
    try {
      UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
              email: _emailController.text, password: _passwordController.text);

      if (userCredential != null) {
        return true;
      } else {
        return false;
      }
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(context, e.message);
      return false;
    } catch (e) {
      print(e);
    }

    return false;
  }

  Future<bool> withGoogleSignUp() async {
    try {
      final GoogleSignInAccount googleUser = await GoogleSignIn().signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      return userCredential == null ? false : true;
    } on FirebaseAuthException catch (e) {
      showErrorSnackBar(context, e.message);
      return false;
    } catch (e) {
      print(e);
    }
    return false;
  }

  Future<bool> withFacebookSingUp() async {
    try {
      final LoginResult accessToken = (await FacebookAuth.instance.login());
      OAuthCredential authCredential = FacebookAuthProvider.credential(
        accessToken.accessToken.token,
      );
      return authCredential == null ? false : true;
    } catch (e) {
      return false;
    }
  }
}
