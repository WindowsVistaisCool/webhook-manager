import 'package:flutter/material.dart';

class AuthorSelector extends StatefulWidget {
  const AuthorSelector({
    Key? key,
    required this.callback,
    this.defaults,
  }) : super(key: key);

  final void Function(Map<String, dynamic>) callback;
  final Map<String, dynamic>? defaults;

  @override
  State<AuthorSelector> createState() => _AuthorSelectorState();
}

class _AuthorSelectorState extends State<AuthorSelector> {
  late TextEditingController _controller;
  late TextEditingController _controller2;
  late TextEditingController _controller3;
  Map<String, dynamic> _data = {};

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _controller2 = TextEditingController();
    _controller3 = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    _controller2.dispose();
    _controller3.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.defaults != null) {
      _data = widget.defaults!;
      final Map<String, TextEditingController> controllerMap = {
        "name": _controller,
        "icon_url": _controller2,
        "url": _controller3,
      };
      for (final String key in _data.keys) {
        controllerMap[key]!.text = _data[key]! ?? '';
      }
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Author Selection"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _controller,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Author Name",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _controller2,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Author Icon URL",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _controller3,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Author URL",
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  onPrimary: Theme.of(context).colorScheme.onPrimary,
                  primary: Theme.of(context).colorScheme.primary,
                ),
                onPressed: () {
                  if (_controller.text == '') return;
                  _data = {
                    "name": _controller.text,
                  };
                  if (_controller2.text != '') _data['icon_url'] = _controller2.text;
                  if (_controller3.text != '') _data['url'] = _controller3.text;
                  widget.callback(_data);
                  Navigator.pop(context, _data);
                },
                child: const Text('Save'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}