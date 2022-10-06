import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tradeapp/provider/auth.dart';

class SignIn extends StatefulWidget {
  final Function toggleView;
  const SignIn({super.key, required this.toggleView});

  @override
  // ignore: library_private_types_in_public_api
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController _pass = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();

  final AuthService _authService = AuthService();

  bool loading = false;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140.0),
        child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.white,
            elevation: 0.0,
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                SizedBox(height: 100),
                Center(
                  child: Text(
                    'Sign In',
                    style: TextStyle(color: Colors.black, fontSize: (50)),
                  ),
                ),
              ],
            )),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              key: _form,
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 20.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Email cannot be empty";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => email = val.trim());
                    },
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Enter Password",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    controller: _pass,
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (val.length < 8) {
                        return "Password cannot be less than 8 character";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => password = val.trim());
                    },
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () async {
                        try {
                          setState(() => loading = true);
                          if (_form.currentState!.validate()) {
                            setState(() => loading = true);
                            // ignore: unused_local_variable
                            dynamic result = await _authService
                                .signInWithEmailAndPassword(email, password);
                          }
                        } on FirebaseAuthException catch (e) {
                          if (e.code == 'user-not-found') {
                            setState(
                                () => error = 'No user exists with this email');
                          } else if (e.code == 'wrong-password') {
                            setState(() => error = 'Incorrect Password  ');
                          }
                        }
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 100)),
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(fontSize: 30)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.teal[300])),
                      child: const Text("Log In",
                          style: TextStyle(color: Colors.white))),
                  const SizedBox(height: 20.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Don't have an account ?",
                          style: TextStyle(fontSize: 20)),
                      TextButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(fontSize: 20),
                        ),
                      )
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }
}
