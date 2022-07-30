import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../classes/hookrequest.dart';
import '../classes/settingmanager.dart';

class DebugWidget extends StatefulWidget {
  const DebugWidget({Key? key}) : super(key: key);

  @override
  State<DebugWidget> createState() => _DebugWidgetState();
}

class _DebugWidgetState extends State<DebugWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Debug"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(fontSize: 20, color: Theme.of(context).backgroundColor),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () async {
                print("set url");
                final prefs = await SharedPreferences.getInstance();
                prefs.setString("url", "https://discord.com/api/webhooks/1002312981251633183/nVgxlyxFKSHNuKFRnuw3b9Ac32LLd65Ul-oHiUtbM4Qp8cCHyHN4lNjiDKk_xBlaEFmK");
              },
              child: const Text('set url'),
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: TextStyle(fontSize: 20, color: Theme.of(context).backgroundColor),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                HookRequest.send("test");
                print("sent msg");
              },
              child: const Text('send msg'),
            ),
          ],
        ),
      ),
    );
  }
}