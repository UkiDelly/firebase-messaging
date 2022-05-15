import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:page_transition/page_transition.dart';

import 'home.dart';

// ignore: must_be_immutable
class AddEmployee extends StatelessWidget {
  const AddEmployee({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await Navigator.pushReplacement(
            context,
            PageTransition(
                child: const MobileHome(), type: PageTransitionType.fade));
        return true;
      },
      child: const Scaffold(
        body: Center(child: _Add()),
      ),
    );
  }
}

// ignore: must_be_immutable
class _Add extends StatefulWidget {
  const _Add({
    Key? key,
  }) : super(key: key);

  @override
  State<_Add> createState() => __Add();
}

final formGlobalKey = GlobalKey<FormState>();

class __Add extends State<_Add> {
  TextEditingController nameController = TextEditingController(),
      usernameController = TextEditingController(),
      passwordController = TextEditingController();
  String errorMessage = '';

  //AddEmployee function
  addEmployee() async {
    await FirebaseFirestore.instance.collection('employee').add({
      'name': nameController.text,
      "username": usernameController.text,
      'password': passwordController.text
    });

    Fluttertoast.showToast(
        msg: "Successfully add an employee!",
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.TOP,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color(0xffFDBF05),
        textColor: Colors.white,
        fontSize: 15.0);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formGlobalKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //Logo
          Hero(
            tag: 'logo',
            child: Image.asset(
              'assets/mashiso.png',
              height: 200,
            ),
          ),

          const SizedBox(
            height: 36,
          ),

          // Name
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextFormField(
              controller: nameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  focusColor: Color(0xffFDBF05),
                  prefixIcon: Icon(Icons.alternate_email),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffFDBF05), width: 3),
                  ),
                  hintText: "Enter name",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffFDBF05), width: 3),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 3),
                  )),
              validator: (name) {
                if (name == '') {
                  return "Please enter the name";
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          //Username
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.8,
            child: TextFormField(
              controller: usernameController,
              textInputAction: TextInputAction.next,
              decoration: const InputDecoration(
                  focusColor: Color(0xffFDBF05),
                  prefixIcon: Icon(Icons.person),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffFDBF05), width: 3),
                  ),
                  hintText: "Enter username",
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffFDBF05), width: 3),
                  ),
                  errorBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.red, width: 3),
                  )),
              validator: (username) {
                if (username == '') {
                  return "Please enter a valid username";
                }
                return null;
              },
            ),
          ),
          const SizedBox(
            height: 20,
          ),

          //Password
          SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextFormField(
                obscureText: true,
                textInputAction: TextInputAction.done,
                controller: passwordController,
                decoration: const InputDecoration(
                    // Lock icon
                    prefixIcon: Icon(Icons.lock),
                    focusedBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffFDBF05), width: 3),
                    ),
                    hintText: "Enter password",
                    enabledBorder: UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Color(0xffFDBF05), width: 3),
                    ),
                    errorBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.red, width: 3),
                    )),
                validator: (password) {
                  if (password == '') {
                    return "Please don't leave this field empty";
                  }
                  return null;
                },
              )),
          const SizedBox(
            height: 12,
          ),

          //Add Employee Button
          SizedBox(
            width: 170,
            height: 50,
            child: ElevatedButton(
              onPressed: () {
                if (formGlobalKey.currentState!.validate()) {
                  addEmployee();
                  nameController.text = "";
                  usernameController.text = "";
                  passwordController.text = "";
                }
              },
              style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(const Color(0xffFDBF05))),
              child: const Text(
                "Add",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
