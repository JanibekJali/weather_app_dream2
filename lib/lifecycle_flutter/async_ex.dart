import 'dart:developer';

import 'package:flutter/material.dart';

class AsyncExample extends StatefulWidget {
  const AsyncExample({super.key});

  @override
  State<AsyncExample> createState() => _AsyncExampleState();
}

class _AsyncExampleState extends State<AsyncExample> {
  String? text = '';
  String getText1() {
    return text!;
  }

  @override
  void initState() {
    text = 'Text Joldo kele jatat';
    log('initState ===> ');
    getText2();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    log('didChanage dependecy ===>');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showMyDialog();
    });

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    log('Dispose ===> ');
    super.dispose();
  }

  Future<String> getText2() async {
    try {
      await Future.delayed(Duration(seconds: 3), () {
        text = '3 secunddan kiyin text keldi';
        setState(() {});
        log('gettext2 ===> ');
      });
      return text!;
    } catch (kata) {
      throw Exception(kata);
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('AlertDialog Title'),
          content: SingleChildScrollView(
            child: ListBody(
              children: const <Widget>[
                Text('This is a demo alert dialog.'),
                Text('Would you like to approve of this message?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Approve'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    log('build ===> ');
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Text(
              text!,
              style: TextStyle(fontSize: 35),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text(
                  'Go back first page',
                  style: TextStyle(fontSize: 30),
                ))
          ],
        ),
      ),
    );
  }
}
