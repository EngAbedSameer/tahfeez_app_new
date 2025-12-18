import 'package:provider/provider.dart';

import 'floating_bug.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

class BugReportOverlay extends StatefulWidget with ChangeNotifier {
  BugReportOverlay({Key? key}) : super(key: key);

  @override
  State<BugReportOverlay> createState() => _BugReportOverlayState();
}

class _BugReportOverlayState extends State<BugReportOverlay> {
  bool _showOverlayer = false;
  bool _isSent = false;
  final String _title = 'app Title';
  late String _panelUserName = '';
  late String _panelDescription = '';
  late FloatingBugReportProvider _floatingBugReportProvider;

  @override
  void initState() {
    _floatingBugReportProvider = FloatingBugReportProvider(userEmail: "widget.mEmail");
    super.initState();
  }

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
        default:
      }
    });
  }

  void _onSumbit() {
    if (_panelUserName.isNotEmpty && _panelDescription.isNotEmpty) {
      setState(() {
        _isSent = true;
      });
      _floatingBugReportProvider.captureUserFeedback(
        _panelUserName,
        _panelDescription,
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

  @override
  void dispose() {
    setState(() {
      _showOverlayer = false;
      _isSent = false;
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double heightOfTabBar = 100;
    return ChangeNotifierProvider<FloatingBugReportProvider>(
      create: (context) => FloatingBugReportProvider(userEmail:"widget.mEmail"),
      child: Consumer<FloatingBugReportProvider>(
        builder: (context, reporter, child) => MaterialApp(
          title: _title,
          home: Scaffold(
            body: Stack(
              fit: StackFit.expand,
              children: [
                if (_showOverlayer) _buildPanel(context),
                Positioned(
                  right: 0,
                  width: 40,
                  height: 40,
                  bottom: heightOfTabBar,
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue[50],
                    ),
                    child: IconButton(
                      onPressed: _onPressed,
                      icon: const Icon(
                        Icons.bug_report,
                        color: Colors.green,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPanel(BuildContext context) {
    return Positioned(
      child: Container(
        color: Colors.black.withOpacity(0.1),
        child: Center(
          child: Container(
            padding: const EdgeInsets.only(
              top: 20,
              left: 10,
              right: 10,
            ),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(1),
              borderRadius: BorderRadius.circular(20),
            ),
            width: 320.0, // width depends on the screen size
            height: 250, // height depends on the screen size
            child: Column(
              children: _isSent
                  ? [
                      const Text('Thank you for your feedback!'),
                      const SizedBox(height: 20),
                      const Icon(Icons.done),
                    ]
                  : [
                      const Text('Report an issue'),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (val) => _onChanged(val, 'name'),
                        decoration: const InputDecoration(
                          hintText: 'Full name',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        onChanged: (val) => _onChanged(val, 'description'),
                        decoration: const InputDecoration(
                          hintText: 'Give full description',
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: _onSumbit,
                        child: const Text('Submit'),
                      ),
                    ],
            ),
          ),
        ),
      ),
      left: 0,
      right: 0,
      top: 0,
      bottom: 0,
    );
  }
}