import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webhook_manager/classes/hookrequest.dart';
import 'package:webhook_manager/embeds/author.dart';
import 'package:webhook_manager/embeds/contentAddon.dart';
import 'package:webhook_manager/embeds/footer.dart';
import 'package:webhook_manager/pages/debug.dart';
import 'classes/embed.dart';
import 'pages/settings_main.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Webhook Manager",
      theme: ThemeData.dark().copyWith(
        // textTheme: GoogleFonts.montserratTextTheme(),
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0x006686))
      ),
      home: const WebhookManager(),
    );
  }
}

enum UrlState{ url1, url2, url3, url4, url5 }

class WebhookManager extends StatefulWidget {
  const WebhookManager({Key? key}) : super(key: key);

  @override
  State<WebhookManager> createState() => _WebhookManagerState();
}

class _WebhookManagerState extends State<WebhookManager> {
  late TextEditingController _controller;
  late TextEditingController _secondaryController;
  late TextEditingController _thirdController;
  late TextEditingController _fourthController;
  late TextEditingController _fifthController;
  late TextEditingController _cAcc1;
  late TextEditingController _cAcc2;
  late TextEditingController _cAcc3;
  late TextEditingController _cHolder1;
  late TextEditingController _cHolder2;
  late TextEditingController _cHolder3;
  late TextEditingController _cHolder4;
  late TextEditingController _cHolder5;

  int _currentNavIndex = 1;

  Embed? _embed;
  Color _pickedColor = Colors.white;

  Map<String, Map<String, dynamic>>? _embedParamGatherer;
  Map<String, dynamic>? _hookProfileGatherer;
  UrlState? _radioValue;

  Future<void> _setTextEditors() async {
    final prefs = await SharedPreferences.getInstance();
    _cHolder1.text = prefs.getString('url') ?? '';        
    _cHolder2.text = prefs.getString('url2') ?? '';
    _cHolder3.text = prefs.getString('url3') ?? '';
    _cHolder4.text = prefs.getString('url4') ?? '';
    _cHolder5.text = prefs.getString('url5') ?? '';
    final List<String> states = [
      _cHolder1.text,
      _cHolder2.text,
      _cHolder3.text,
      _cHolder4.text,
      _cHolder5.text,
    ];
    for (final String i in states) {
      if (i != '') {
        _radioValue = UrlState.values[states.indexOf(i)];
        break;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _secondaryController = TextEditingController();
    _thirdController = TextEditingController();
    _fourthController = TextEditingController();
    _fifthController = TextEditingController();
    _cAcc1 = TextEditingController();
    _cAcc2 = TextEditingController();
    _cAcc3 = TextEditingController();
    _cHolder1 = TextEditingController();
    _cHolder2 = TextEditingController();
    _cHolder3 = TextEditingController();
    _cHolder4 = TextEditingController();
    _cHolder5 = TextEditingController();
    _setTextEditors();
  }

  @override
  void dispose() {
    _controller.dispose();
    _secondaryController.dispose();
    _thirdController.dispose();
    _fourthController.dispose();
    _fifthController.dispose();
    _cAcc1.dispose();
    _cAcc2.dispose();
    _cAcc3.dispose();
    _cHolder1.dispose();
    _cHolder2.dispose();
    _cHolder3.dispose();
    _cHolder4.dispose();
    _cHolder5.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Webhook Manager"),
        actions: [
          PopupMenuButton<int>(
            itemBuilder: (context) => [
              const PopupMenuItem<int>(
                value: 1,
                child: Text("debug"),
              ),
              const PopupMenuDivider(),
              PopupMenuItem<int>(
                value: 0,
                child: Row(
                  children: const [
                    Icon(Icons.settings, color: Colors.black,),
                    SizedBox(width: 8),
                    Text('General Settings'),
                  ],
                ),
              ),
            ],
            onSelected: (item) => _selectedMenu(context, item),
          ),
        ],
      ),
      body: PageTransitionSwitcher( // TODO: make animation work
        transitionBuilder: (
          Widget child,
          Animation<double> primaryAnimation,
          Animation<double> secondaryAnimation,
        ) {
          return FadeThroughTransition(
            animation: primaryAnimation,
            secondaryAnimation: secondaryAnimation,
            child: child,
          );
        },
        child: _getActiveWidget(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'Message',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.business),
            label: 'Embed', 
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Account',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Webhooks',
          ),
        ],
        currentIndex: _currentNavIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Theme.of(context).colorScheme.onPrimary,
        unselectedItemColor: Theme.of(context).colorScheme.onPrimary.withOpacity(0.38),
        backgroundColor: Theme.of(context).colorScheme.primary,
        onTap: (index) {
          setState(() {
            _currentNavIndex = index;
          });
        },
      ),
    );
  }

  Widget _getActiveWidget() => <Widget>[
    Center(
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text('Simple Message'),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Message',
              ),
              controller: _controller,
              onSubmitted: (String value) async {
                _controller.clear();
                HookRequest.send(value);
              },
            ),
          ),
        ],
      ),
    ),
    Center(
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.all(18.0),
            child: Text('Embed Builder'),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Title',
              ),
              controller: _controller,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description',
              ),
              controller: _secondaryController,
            ),
          ),
          Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Theme.of(context).colorScheme.onSecondaryContainer,
                    primary: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AuthorSelector(callback: (Map<String, dynamic> data) {
                            if (_embedParamGatherer == null) {
                              _embedParamGatherer = {'author': data};
                            } else {
                              _embedParamGatherer?['author'] = data;
                            }
                          },
                          defaults: _embedParamGatherer == null ? null : _embedParamGatherer!.containsKey('author') ? _embedParamGatherer!['author'] : null,
                        ),
                      ),
                    );
                  },
                  child: const Text('Author'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Theme.of(context).colorScheme.onSecondaryContainer,
                    primary: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => FooterSelector(callback: (Map<String, dynamic> data) {
                            if (_embedParamGatherer == null) {
                              _embedParamGatherer = {'footer': data};
                            } else {
                              _embedParamGatherer?['footer'] = data;
                            }                      
                          },
                          defaults: _embedParamGatherer == null ? null : _embedParamGatherer!.containsKey('footer') ? _embedParamGatherer!['footer'] : null,
                        )
                      ),
                    );
                  },
                  child: const Text('Footer'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Theme.of(context).colorScheme.onSecondaryContainer,
                    primary: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          titlePadding: const EdgeInsets.all(0),
                          contentPadding: const EdgeInsets.all(0),
                          content: SingleChildScrollView(
                            child: MaterialPicker(
                              pickerColor: _pickedColor,
                              onColorChanged: _onColorChanged,
                              enableLabel: true,
                              portraitOnly: false,
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              child: const Text('Got it'),
                              onPressed: () {
                                _onColorChanged(_pickedColor);
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: const Text('Color'),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 12, 4, 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    onPrimary: Theme.of(context).colorScheme.onSecondaryContainer,
                    primary: Theme.of(context).colorScheme.secondaryContainer,
                  ),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => ContentAddon(callback: (String data) {
                          if (_embedParamGatherer == null) {
                            _embedParamGatherer = {'msg': {'msg': data}};
                          } else {
                            _embedParamGatherer?['msg'] = {'msg': data};
                          }
                        })
                      ),
                    );
                  },
                  child: const Text('Message Content'),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                onPrimary: Theme.of(context).colorScheme.onPrimary,
                primary: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                if (_controller.text == '' && _secondaryController.text == '') return;
                _embed = _controller.text == '' ? Embed(description: _secondaryController.text) : _secondaryController.text == '' ? Embed(title: _controller.text) : Embed(title: _controller.text, description: _secondaryController.text);
                _controller.clear();
                _secondaryController.clear();                
                if (_embedParamGatherer != null){
                  if (_embedParamGatherer!.containsKey('color')) {
                    _embed?.setColor(_embedParamGatherer?['color']?['color']);
                  }
                  if (_embedParamGatherer!.containsKey('msg')) {
                    _embed?.setMessageAddon(_embedParamGatherer?['msg']?['msg']);
                  }
                  if (_embedParamGatherer!.containsKey('author')) {
                    _embed?.setAuthor(_embedParamGatherer?['author']?['name'], iconUrl: _embedParamGatherer?['author']?['icon_url'], url: _embedParamGatherer?['author']?['url']);
                  }
                  if (_embedParamGatherer!.containsKey('footer')) {
                    _embed?.setFooter(_embedParamGatherer?['footer']?['text'], iconUrl: _embedParamGatherer?['footer']?['icon_url']);
                  }
                }
                HookRequest.embeds([_embed!]);
                _embed = null;
                _embedParamGatherer = null;
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Embed sent to channel successfully'),
                  ),
                ));
              },
              child: const Text('Send Embed'),
            ),
          ),
        ],
      ),
    ),
    Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: const <Widget>[
                Text('Account Settings'),
                SizedBox(height: 8),
                Text('Note that a username is required to change other fields.',)
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Username',
              ),
              controller: _cAcc1,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Avatar URL',
              ),
              controller: _cAcc2,
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
                if (_cAcc1.text == '') return;
                HookRequest.setUsername(_cAcc1.text);
                HookRequest.setAvatarUrl(_cAcc2.text);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Padding(
                    padding: EdgeInsets.all(8),
                    child: Text('Updated webhook account settings!'),
                  ),
                ));
              },
              child: const Text('Save'),
            ),
          ),
        ],
      ),
    ),
    Center(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Column(
              children: const <Widget>[
                Text('Webhook Selector'),
                SizedBox(height: 8),
                Text('Note that at least one webhook URL is required. ')
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Webhook URL 1',
                ),
                controller: _cHolder1,
              ),
              leading: Radio<UrlState>(
                value: UrlState.url1,
                groupValue: _radioValue,
                onChanged: (UrlState? value) {
                  _radioHandler(
                    value: value,
                    context: context,
                    controller: _cHolder1,
                    key: 'url',
                  );
                }
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Webhook URL 2',
                ),
                controller: _cHolder2,
              ),
              leading: Radio<UrlState>(
                value: UrlState.url2,
                groupValue: _radioValue,
                onChanged: (UrlState? value) {
                  _radioHandler(
                    value: value,
                    context: context,
                    controller: _cHolder2,
                    key: 'url2',
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Webhook URL 3',
                ),
                controller: _cHolder3,
              ),
              leading: Radio<UrlState>(
                value: UrlState.url3,
                groupValue: _radioValue,
                onChanged: (UrlState? value) {
                  _radioHandler(
                    value: value,
                    context: context,
                    controller: _cHolder3,
                    key: 'url3',
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Webhook URL 4',
                ),
                controller: _cHolder4,
              ),
              leading: Radio<UrlState>(
                value: UrlState.url4,
                groupValue: _radioValue,
                onChanged: (UrlState? value) {
                  _radioHandler(
                    value: value,
                    context: context,
                    controller: _cHolder4,
                    key: 'url4',
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListTile(
              title: TextField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Webhook URL 5',
                ),
                controller: _cHolder5,
              ),
              leading: Radio<UrlState>(
                value: UrlState.url5,
                groupValue: _radioValue,
                onChanged: (UrlState? value) {
                  _radioHandler(
                    value: value,
                    context: context,
                    controller: _cHolder5,
                    key: 'url5',
                  );
                },
              ),
            ),
          ),
        ],
      ),
    ),
  ][_currentNavIndex];

  void _radioHandler({required UrlState? value, required BuildContext context, required TextEditingController controller, required String key}) async {
    if (controller.text == '') {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: const Padding(
          padding: EdgeInsets.all(8),
          child: Text('Please enter a webhook URL into the field.'),
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
      ));
      return;
    }
    HookRequest.url = controller.text;
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, controller.text);
    setState(() {
      _radioValue = value;
    });
  }

  void _onColorChanged(Color color) {
    setState(() {
      _pickedColor = color;
    });
    final parsedColor = {'color': int.parse('0x${color.value.toRadixString(16).substring(2)}')};
    if (_embedParamGatherer == null) {
      _embedParamGatherer = {'color': parsedColor};
    } else {
      _embedParamGatherer?['color'] = parsedColor;
    }
  }

  void _selectedMenu(BuildContext context, int value) => [
      () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const SettingsMain(),
        ),
      ),
      () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => const DebugWidget(),
        ),
      ),
    ][value]();
}