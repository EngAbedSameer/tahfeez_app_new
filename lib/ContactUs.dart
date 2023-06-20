import 'dart:async';

import 'package:flutter/material.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:tahfeez_app/moodle/floating_bug.dart';
import "package:sentry/sentry.dart";
class ContactUs extends StatefulWidget {

  final String userEmail;
  ContactUs({super.key, required this.userEmail});

  @override
  State<ContactUs> createState() => _ContactUsState();
}

class _ContactUsState extends State<ContactUs> with ChangeNotifier {
bool _showOverlayer = false;
  bool _isSent = false;
  late String _panelUserName = '';
  late String _panelDescription = '';
  late String _centerName = '';
var eventId = SentryId.newId();
  
  void _onPressed() {
    setState(() {
      _showOverlayer = !_showOverlayer;
    });
  }

  void _onChanged(newValue, String type) {
    setState(() {
      switch (type) {
        case 'name':
          _panelUserName = newValue;
          break;
        case 'description':
          _panelDescription = newValue;
          break;
        case 'center':
        _centerName =newValue;
      }
    });
  }

  void _onSumbit() {
    if (_panelUserName.isNotEmpty && _panelDescription.isNotEmpty) {
      setState(() {
        _isSent = true;
      });
      captureUserFeedback(
        _panelUserName,
        _centerName+" \n"+_panelDescription,
      );
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          _showOverlayer = false;
          _panelUserName = '';
          _panelDescription = '';
        });
      });
    } else {
      return;
    }
  }

void captureUserFeedback(String name, String comments) {
  print('''
 eventId: $eventId,
      comments: $comments,
      name: $name,
      email: ${widget.userEmail},
''');
    Sentry.captureUserFeedback(SentryUserFeedback(
      eventId: eventId,
      comments: comments,
      name: name,
      email: widget.userEmail,
    ));
    notifyListeners();
  }

  Widget _buildPanel(BuildContext context) {
    return 
        ListView(
          children: [Column(
            children: [
              Center(
                child: Container(
                  padding: const EdgeInsets.only(
                    top: 20,
                    left: 10,
                    right: 10,
                  ),
                  color: Colors.white,
                  // decoration: BoxDecoration(
                  //   color: Colors.white.withOpacity(1),
                  //   borderRadius: BorderRadius.circular(20),
                  // ),
                  
                  child: Column(
                    children: _isSent
                        ? [
                            const Text('نشكرك على مراسلتنا'),
                            const SizedBox(height: 20),
                            const Icon(Icons.done),
                          ]
                        : [
                            const Text('الابلاغ عن مشكلة'),
                            const SizedBox(height: 20),
                            TextField(
                              onChanged: (val) => _onChanged(val, 'name'),
                              decoration: const InputDecoration(
                                hintText: 'الإسم الرباعي',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              onChanged: (val) => _onChanged(val, 'center'),
                              decoration: const InputDecoration(
                                hintText: 'إسم المركز',
                              ),
                            ),
                            const SizedBox(height: 20),
                            TextField(
                              onChanged: (val) => _onChanged(val, 'description'),
                              decoration: const InputDecoration(
                                hintText: 'اشرح المشكلة بالتفصيل',
                              ),
                            ),
                            const SizedBox(height: 20),
                            ElevatedButton(
                             
                              onPressed: _onSumbit,
                              child: const Text('إرسال'),
                            ),
                          ],
                  ),
                ),
              ),
            ],
          ),]
        );
     
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
        title: Text("تواصل معنا", textAlign: TextAlign.center),
      ),body: _buildPanel(context));
  }
}