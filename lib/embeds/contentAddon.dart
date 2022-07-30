import 'package:flutter/material.dart';

class ContentAddon extends StatefulWidget {
  const ContentAddon({
    Key? key,
    required this.callback
  }) : super(key: key);

  final void Function(String) callback;

  @override
  State<ContentAddon> createState() => _ContentAddonState();
}

class _ContentAddonState extends State<ContentAddon> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: const Text("Add a message (press enter to return)"),
    ),
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextField(
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            labelText: "Message",
          ),
          onSubmitted: (String value) {
            widget.callback(value);
            Navigator.of(context).pop();
          },
          controller: _controller,
        ),
      ),
    ),
  );
}