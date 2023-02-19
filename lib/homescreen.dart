import 'package:flutter/material.dart';
import 'package:google_maps_webservice/directions.dart';
import 'package:inec_reg/otp.dart';
import 'package:inec_reg/screen.dart';

class HomeScreen extends StatefulWidget {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController usernameController = TextEditingController();
  static const darkBlueColor = Color(0xff486579);
  @override
  Widget build(BuildContext context) {
    final loginButton = Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 5,
      color: Colors.white,
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OTPScreen(
                        phone: usernameController.text,
                      )));
        },
        child: const Text(
          'LOGIN',
          style: TextStyle(
              color: Colors.black26, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
    );
    return Scaffold(
      backgroundColor: darkBlueColor,
      body: Container(
        margin: EdgeInsets.only(top: 300),
        child: Form(
            key: formKey,
            child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: [
                  TextFormField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                        prefixIconColor: Colors.white,
                        hintText: "Phone number",
                        prefix: Padding(
                          padding: EdgeInsets.all(4),
                          child: Text("+234"),
                        ),
                        hintStyle: TextStyle(color: Colors.white)),
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    validator: ((value) {
                      if (value!.isEmpty) {
                        return "Field cannot be empty";
                      }
                      return null;
                    }),
                    onSaved: (value) {
                      usernameController.text = value!;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  loginButton
                ],
              ),
            )),
      ),
    );
  }
}
