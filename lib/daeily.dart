// ignore_for_file: avoid_function_literals_in_foreach_calls, curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';
// import 'package:tahfeez_app/Home.dart';
import 'package:tahfeez_app/moodle/BottomBar.dart';
// import 'package:tahfeez_app/moodle/firebase-oprations.dart';
// import 'package:tahfeez_app/moodle/DataSet.dart' as data;
import 'sqfDB.dart';

class Da extends StatelessWidget {
  final String memorizerEmail;

  const Da({super.key, 
  required this.memorizerEmail});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tahfeez',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home:  DaPage(memorizerEmail: memorizerEmail,),
    );
  }
}

class DaPage extends StatefulWidget {
  final String memorizerEmail;

  const DaPage({super.key, required this.memorizerEmail});

  @override
  State<DaPage> createState() => _DaPageState();
}

class _DaPageState extends State<DaPage> {
  // var _localData = data.daily;
  // SqlDb db = SqlDb();
  // Future<List<Map<dynamic, dynamic>>> _getStd() async {
  //   List<Map> localData = await db.readData("SELECT * FROM students");
  //   return localData;
  // }

  List<Map> _dataToBeInserted = [];
  bool isOnce = false;


  _getStd() async{
    
  }

  // Future<List<Map>> _getStd() async {
  //   List<Map> result = await db.readData(
  //       "SELECT id, f_name, m_name, l_name , attendance ,points FROM students");
  //   if (!isOnce) _dataToBeInserted = _getdata(List.from(result));
  //   isOnce = true;
  //   return _dataToBeInserted;
  // }

  _getdata(List<Map> data) {
    // [
    //   {
    //     "id": "",
    //     "f_name": "",
    //     "m_name": "",
    //     "l_name": "",
    //     "attendance": "",
    //     "points": "",
    //     "isAttended": false,
    //     "date": DateTime.now().toString()
    //   }
    // ];
    return data.map((map) {
      return {...map, "isAttended": false, "date": DateTime.now().toString()};
    }).toList(growable: false);
  }

  // _save() {
  //   _dataToBeInserted.forEach((element) {
  //     if (element['isAttended'].toString() == "true") {
  //       db.insertData(
  //           "INSERT INTO 'Attendance' (std_id, name, date) VALUES ( '${element['id']}' , '${element['f_name'] + "  " + element['l_name']}' ,'${element['date']}')");
  //       // element['isAttended'] = (element['isAttended']) ? 1 : 0;
  //       // var attend = element['isAttended'] + element['attendance'];
  //       db.updateData(
  //           "UPDATE 'Students'  SET attendance= ${1 + element['attendance']}  WHERE id=${element['id']}");
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("الحضور و الغياب"),
      ),
      body: FutureBuilder(
          future: _getStd(),
          builder: ((context, AsyncSnapshot<List<Map>> snapshot) {
            if (snapshot.hasData && snapshot.data!.length > 0) {
              return ListView.builder(
                  itemCount: snapshot.data?.length,
                  itemBuilder: (context, index) {
                    var stdData = snapshot.data!.elementAt(index);
                    return Card(
                      child: CheckboxListTile(
                        title:
                            Text(stdData['f_name'] + " " + stdData['l_name']),
                        value: _dataToBeInserted.elementAt(index)['isAttended'],
                        onChanged: (value) {
                          setState(() =>
                                _dataToBeInserted
                                    .elementAt(index)['isAttended'] = value
                              );
                        },
                      ),
                      // Text(snapshot.data!.elementAt(index)['name'].toString())
                    );
                  });
            } else
              return Center(child: CircularProgressIndicator());
          })),
      bottomNavigationBar: BottomBar(
        dailyReplace: false,
        dailyPush: false,
        home: true,
        addStudent: true,
        memorizerEmail: widget.memorizerEmail,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text("Sure!!!"),
                  content: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: () {
                            // _save();
                            Navigator.of(context)
                                .popUntil((route) => route.isFirst);
                          },
                          child: Text(" YES ")),
                      ElevatedButton(
                          onPressed: () => {Navigator.of(context).pop()},
                          child: Text(" Cancel ")),
                    ],
                  ),
                );
              });
        },
        child: Icon(Icons.done),
      ),
    );
  }
}
