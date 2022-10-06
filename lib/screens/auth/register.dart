import 'package:flutter/material.dart';
import 'package:tradeapp/provider/auth.dart';
import 'package:tradeapp/provider/userDatabase.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  const Register({super.key, required this.toggleView});

  @override
  // ignore: library_private_types_in_public_api
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final TextEditingController _pass = TextEditingController();
  final TextEditingController _confirmPass = TextEditingController();
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _fullName = TextEditingController();

  final AuthService _authService = AuthService();

  String email = '';
  String password = '';
  String error = '';
  String fullName = '';

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
                    'Sign Up',
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
                    controller: _fullName,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: "Enter Full Name",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Name cannot be empty";
                      }
                      return null;
                    },
                    onChanged: (val) {
                      setState(() => fullName = val.trim());
                    },
                    keyboardType: TextInputType.name,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  TextFormField(
                    controller: _email,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                      labelText: "Enter Email",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
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
                  TextFormField(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    controller: _confirmPass,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: const BorderSide(),
                      ),
                      //fillColor: Colors.green
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return "Password cannot be empty";
                      }
                      if (val != _pass.text) {
                        return 'Not Match';
                      }
                      return null;
                    },
                    keyboardType: TextInputType.visiblePassword,
                    style: const TextStyle(
                      fontFamily: "Poppins",
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    error,
                    style: const TextStyle(color: Colors.red, fontSize: 14),
                  ),
                  const SizedBox(height: 20),
                  TextButton(
                      onPressed: () async {
                        if (_form.currentState!.validate()) {
                          dynamic result = await _authService
                              .registerWithEmailAndPassword(email, password);
                          userDatabase(uid: '')
                              .addUserData(_fullName.text, _email.text);
                          if (result == null) {
                            setState(
                                () => error = 'please enter a valid email');
                          }
                        }
                      },
                      style: ButtonStyle(
                          padding: MaterialStateProperty.all(
                              const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 75)),
                          textStyle: MaterialStateProperty.all(
                              const TextStyle(fontSize: 30)),
                          backgroundColor:
                              MaterialStateProperty.all(Colors.teal[300])),
                      child: const Text("Register",
                          style: TextStyle(color: Colors.white))),
                  const SizedBox(height: 20.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("Already have an account ?",
                          style: TextStyle(fontSize: 20)),
                      TextButton(
                        onPressed: () {
                          widget.toggleView();
                        },
                        child: const Text(
                          'Sign In',
                          style: TextStyle(fontSize: 20),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
