import 'package:flutter/material.dart';
import 'package:project/Screens/Login/login_screen.dart';
import 'package:project/Screens/Signup/components/background.dart';
import 'package:project/components/already_have_an_account_acheck.dart';
import 'package:project/components/rounded_button.dart';
import 'package:project/components/rounded_input_field.dart';
import 'package:project/components/rounded_password_field.dart';

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  String valueChoose;
  List listItem = ["Car", "Truck", "Motorcycle"];

  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "SIGNUP",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
            ),
            SizedBox(height: size.height * 0.03),
            RoundedInputField(
              hintText: "Name",
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Lastname",
              onChanged: (value) {},
            ),
            RoundedInputField(
              hintText: "Phone Number",
              onChanged: (value) {},
            ),
            RoundedPasswordField(
              onChanged: (value) {},
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: EdgeInsets.only(left: 16, right: 16),
                decoration: BoxDecoration(),
                child: DropdownButton(
                  hint: Text("Vehicle type"),
                  dropdownColor: Colors.grey,
                  icon: Icon(Icons.arrow_drop_down_circle),
                  iconSize: 36,
                  isExpanded: true,
                  style: TextStyle(color: Colors.black, fontSize: 22),
                  value: valueChoose,
                  onChanged: (newValue) {
                    setState(() {
                      valueChoose = newValue;
                    });
                  },
                  items: listItem.map((valueItem) {
                    return DropdownMenuItem(
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
              ),
            ),
            RoundedButton(
              text: "SIGNUP",
              style: Colors.black,
              press: () {},
            ),
            SizedBox(height: size.height * 0.03),
            AlreadyHaveAnAccountCheck(
              login: false,
              press: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return LoginScreen();
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
