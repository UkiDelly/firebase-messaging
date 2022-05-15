import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:ndialog/ndialog.dart';

import 'home.dart';

// ignore: must_be_immutable
class EmployeeRecord extends StatelessWidget {
  String employeeId;
  String name;
  EmployeeRecord({Key? key, required this.employeeId, required this.name})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),

            //*Name
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 40, fontWeight: FontWeight.bold),
                ),
              ),
            ),

            //
            const SizedBox(
              height: 30,
            ),

            // Divider
            _divider(),

            //* Record List
            RecordList(
              employeeId: employeeId,
              name: name,
            )
          ],
        ),
      ),
    );
  }

  Widget _divider() {
    return Row(children: const [
      SizedBox(
        width: 8,
      ),
      Padding(
        padding: EdgeInsets.only(left: 8.0),
        child: Text(
          "Record",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.w400),
        ),
      ),
      Expanded(
        child: Divider(
          indent: 5,
          endIndent: 8,
          thickness: 3,
          color: Colors.black,
        ),
      )
    ]);
  }
}

// ignore: must_be_immutable
class RecordList extends StatefulWidget {
  String employeeId;
  String name;
  RecordList({Key? key, required this.employeeId, required this.name})
      : super(key: key);

  @override
  State<RecordList> createState() => _RecordListState();
}

class _RecordListState extends State<RecordList> {
  List recordList = [];
  int recordListLength = 0;

  //* Get the record list
  getRecord() async {
    final _record = await FirebaseFirestore.instance
        .collection('employee')
        .doc(widget.employeeId)
        .collection('record')
        .orderBy('IN', descending: true)
        .get();

    setState(() {
      recordList = _record.docs;
      recordListLength = _record.docs.length;
    });
  }

  //Rebuild Widget
  @override
  void didChangeDependencies() {
    getRecord();
    super.didChangeDependencies();
  }

  @override
  void initState() {
    super.initState();
    getRecord();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ScrollConfiguration(
          behavior: MyBehavior(),
          child: ListView.separated(
            itemCount: recordListLength,
            separatorBuilder: (BuildContext context, int index) {
              return const Divider(
                thickness: 2,
                color: Colors.black,
              );
            },
            itemBuilder: (BuildContext context, int index) {
              //get time
              DateTime _timeInDate = recordList[index]['IN'].toDate();
              DateTime? _timeOutDate;
              try {
                _timeOutDate = recordList[index]['OUT'].toDate();
              } catch (e) {
                print(e);
                _timeOutDate = null;
              }

              String _timeIN = DateFormat.jm().format(_timeInDate);
              String _timeOUT = '';
              if (_timeOutDate != null) {
                _timeOUT = DateFormat.jm().format(_timeOutDate);
              }
              //get date
              String _date = DateFormat.yMMMMd('en_US')
                  .format(recordList[index]['IN'].toDate());

              //get how many work
              String totalWork = '';
              if (_timeOutDate != null) {
                totalWork =
                    "${_timeOutDate.difference(_timeInDate).inHours} hr ${_timeOutDate.difference(_timeInDate).inMinutes.remainder(60)} min";
              }

              //get location
              GeoPoint _locationIN = recordList[index]['locationIN'];
              late GeoPoint? _locationOUT;
              try {
                _locationOUT = recordList[index]['locationOUT'];
              } catch (e) {
                _locationOUT = null;
              }
              //
              return Card(
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(20))),
                elevation: 5,
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  splashFactory: NoSplash.splashFactory,
                  //* Alert before delete record
                  onLongPress: () => NAlertDialog(
                    content: const SizedBox(
                      height: 70,
                      child: Center(
                          child: Text(
                        "Are you sure to delete his record?",
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
                            style: TextStyle(color: Colors.black),
                          )),
                      TextButton(
                          onPressed: () async {
                            Navigator.of(context).pop();
                            didChangeDependencies();

                            await FirebaseFirestore.instance
                                .collection('employee')
                                .doc(widget.employeeId)
                                .collection('record')
                                .doc(recordList[index].id)
                                .delete();
                          },
                          child: const Text(
                            "Ok",
                            style: TextStyle(color: Colors.red),
                          )),
                    ],
                  ).show(context),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: const Color(0xffFDBF05), width: 3)),
                    child: Column(
                      children: [
                        //* Time in time and location
                        Text(
                          _date,
                          style: const TextStyle(
                              fontSize: 30, fontWeight: FontWeight.bold),
                        ),

                        const SizedBox(
                          height: 5,
                        ),

                        //*Time in/out and map
                        timeInOutAndMap(index, _timeIN, _timeOUT, _locationIN,
                            _locationOUT),

                        //* Total work time
                        Container(
                          padding: const EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: const Color(0xffFDBF05),
                              borderRadius: BorderRadius.circular(10)),
                          child: Text(
                            "Total work: $totalWork",
                            style: const TextStyle(
                                fontSize: 25, fontWeight: FontWeight.w300),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget timeInOutAndMap(int index, String timeIn, String? timeOut,
      GeoPoint locationIN, GeoPoint? locationOUT) {
    const MarkerId timeInMarker = MarkerId("IN");
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        //*Time in and map
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "IN: $timeIn",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w400),
            ),
            Container(
                margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(20)),
                width: (MediaQuery.of(context).size.width - 10) * 0.4,
                height: 200,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20)),
                  child: GoogleMap(
                      zoomControlsEnabled: false,
                      markers: {
                        Marker(
                            markerId: timeInMarker,
                            position: LatLng(
                                locationIN.latitude, locationIN.longitude))
                      },
                      mapType: MapType.normal,
                      mapToolbarEnabled: false,
                      initialCameraPosition: CameraPosition(
                          target:
                              LatLng(locationIN.latitude, locationIN.longitude),
                          zoom: 20)),
                )),
          ],
        ),

        //*Time out and map
        SizedBox(
          child: timeOut != ''
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "OUT: $timeOut",
                      style: const TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w400),
                    ),
                    Container(
                        margin: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(20)),
                        width: (MediaQuery.of(context).size.width - 10) * 0.4,
                        height: 200,
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                              bottomRight: Radius.circular(20),
                              bottomLeft: Radius.circular(20)),
                          child: GoogleMap(
                              zoomControlsEnabled: false,
                              markers: {
                                Marker(
                                    markerId: timeInMarker,
                                    position: LatLng(locationOUT!.latitude,
                                        locationOUT.longitude))
                              },
                              mapType: MapType.normal,
                              mapToolbarEnabled: false,
                              initialCameraPosition: CameraPosition(
                                  target: LatLng(locationOUT.latitude,
                                      locationOUT.longitude),
                                  zoom: 20)),
                        )),
                  ],
                )
              : null,
        )
      ],
    );
  }
}
