import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tahfeez_app/Home.dart';
import 'package:tahfeez_app/moodle/Firestore.dart';

class UserSignupData extends StatefulWidget {
  final String memorizerEmail;
  const UserSignupData({super.key, required this.memorizerEmail});

  @override
  State<UserSignupData> createState() => _UserSignupDataState();
}

class _UserSignupDataState extends State<UserSignupData> {
  var _phoneController = TextEditingController();
  var _centerController = TextEditingController();
  var _cityController = TextEditingController();
  var _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final Firestore myFirestore= Firestore();

  _signUp(phone,center,city,name){
myFirestore.addMemorizer({'phone':phone,'center':center,'city':city,'name':name,'email':widget.memorizerEmail});
  }

  @override
  Widget build(BuildContext context) {
    var vw = MediaQuery.of(context).size.width;
    var vh = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(title: Text("أكمل بياناتك")),
      body:  Stack(
            children: <Widget>[
              Image.asset(
                "assets/images/background.jpg",
                fit: BoxFit.cover,
                width: vw,
              ),
              Scaffold(
                backgroundColor: Colors.transparent,
                body: Directionality(
                  textDirection: TextDirection.rtl,
                  child: ListView(
                    padding:
                        EdgeInsets.only(top:vh*0.1, bottom: 50),
                    children: [
                      Container(
                        alignment: Alignment.center,
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/icon/logo.png",
                                width: 200,
                              ),
                              Text( "بيانات الحلقة",
                                  style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 32,
                                      fontFamily: 'Segoe UI',
                                      fontWeight: FontWeight.bold)),
                              Container(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  label: Text('اسم المحفظ رباعي'),
                                  focusColor: Colors.red),
                              controller: _nameController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'يجب تعبئة هذه الخانة';
                                } 
                                
                                return null;
                              },
                            ),
                            width: vw * 0.70,
                          ),
                          Container(
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  label: Text("رقم الجوال"),
                                  hintText: '+970592654021',
                                  focusColor: Colors.red),
                              controller: _phoneController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  print(" ******************* ");
                                  return 'يجب تعبئة هذه الخانة';
                                } else if (value!.length != 13) {
                                  print(value.length);
                                  return 'رقم الجوال غير صحيح';
                                }
                                return null;
                              },
                            ),
                            width: vw * 0.70,
                          ),
                          Container(
                            child: TextFormField(
                              textInputAction: TextInputAction.next,
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  label: Text("المدينة"),
                                  focusColor: Colors.red),
                              controller: _cityController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  print(" ******************* ");
                                  return 'يجب تعبئة هذه الخانة';
                                }
                                return null;
                              },
                            ),
                            width: vw * 0.70,
                          ),
                          Container(
                            child: TextFormField(
                              decoration: InputDecoration(
                                  border: UnderlineInputBorder(),
                                  label: Text("أسم مركز التحفيظ"),
                                  hintText:
                                      "يجب ان يكون موحد لجميع المحفظين في المركز",
                                  focusColor: Colors.red),
                              controller: _centerController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  print(" ******************* ");
                                  return 'يجب تعبئة هذه الخانة';
                                }
                                return null;
                              },
                            ),
                            width: vw * 0.70,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _signUp(
_phoneController.text.toString().trim(),
_centerController.text.toString().trim(),
_cityController.text.toString().trim(),
_nameController.text.toString().trim()
                                  );

                                  Navigator.pushAndRemoveUntil(context,
                                                    MaterialPageRoute(
                                                        builder: (context) {
                                                    return Home();
                                                  }),(route) => false,);
                                }
                                
                              },
                              child: Text(" انشاء حساب ")),
                        
                              ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          )
       
    );
  }
}
