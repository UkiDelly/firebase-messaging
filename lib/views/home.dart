import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:ndialog/ndialog.dart';
import 'package:page_transition/page_transition.dart';

import 'add_employee.dart';
import 'employee_record.dart';

class MobileHome extends StatelessWidget {
  const MobileHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Center(
          child: _EmployeeList(),
        ),
      ),
    );
  }
}

class _EmployeeList extends StatefulWidget {
  const _EmployeeList({Key? key}) : super(key: key);

  @override
  State<_EmployeeList> createState() => __EmployeeListState();
}

class __EmployeeListState extends State<_EmployeeList> {
  int numOfEmployees = 0;
  List nameList = [];
  List idList = [];

  //*Get the employee list
  getEmployeeList() async {
    final employee =
        await FirebaseFirestore.instance.collection('employee').get();
    numOfEmployees = employee.docs.length;

    for (var item in employee.docs) {
      nameList.add(item['name']);
      idList.add(item.id);
    }

    setState(() {
      numOfEmployees;
      nameList;
      idList;
    });
  }

  //rebuild the Widget
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    nameList = [];
    idList = [];
    numOfEmployees = 0;
    getEmployeeList();
  }

  @override
  void initState() {
    super.initState();
    getEmployeeList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        //Logo
        Hero(
          tag: 'logo',
          child: Image.asset(
            'assets/mashiso.png',
            height: 250,
          ),
        ),

        //
        const SizedBox(
          height: 15,
        ),

        //*Employee text and add button
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            const Text(
              "Employee",
              style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            ),

            //*Add Employee
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    PageTransition(
                        child: const AddEmployee(),
                        type: PageTransitionType.leftToRight));
              },
              icon: const Icon(Icons.person_add),
              color: const Color(0xffFDBF05),
            )
          ],
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 8, 8, 0),
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: ListView.builder(
                //Remove the sliver padding
                padding: const EdgeInsets.all(0),
                scrollDirection: Axis.vertical,
                physics: const ScrollPhysics(),
                itemCount: numOfEmployees,
                itemBuilder: (BuildContext context, int index) {
                  //* Each employee
                  return Card(
                    elevation: 3,
                    color: const Color(0xffFDBF05),
                    child: ListTile(
                      title: Center(
                          child: Text(
                        "${nameList[index]}",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      )),
                      onTap: () => Navigator.push(
                          context,
                          PageTransition(
                              child: EmployeeRecord(
                                  employeeId: idList[index],
                                  name: nameList[index]),
                              type: PageTransitionType.rightToLeft)),

                      //* Alert dialog before deleting employee
                      onLongPress: () => NAlertDialog(
                        content: const SizedBox(
                          height: 70,
                          child: Center(
                              child: Text(
                            "Are you sure to delete this employee?",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w500),
                          )),
                        ),
                        actions: [
                          TextButton(
                              style: const ButtonStyle(
                                  splashFactory: NoSplash.splashFactory),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text(
                                "Cancel",
                                style: TextStyle(),
                              )),

                          //* Delete employee
                          TextButton(
                              onPressed: () async {
                                await FirebaseFirestore.instance
                                    .collection('employee')
                                    .doc(idList[index])
                                    .delete();

                                //rebuild the widget
                                didChangeDependencies();
                                Navigator.pop(context);
                              },
                              child: const Text(
                                "Ok",
                                style: TextStyle(color: Colors.red),
                              )),
                        ],
                      ).show(context),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
