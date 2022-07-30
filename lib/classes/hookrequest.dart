import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'embed.dart';

class HookRequest {
  static String? _url;
  static String? _username;
  static String? _avatarUrl;

  static set url(String url) { _url = url; }

  static get username => _username;
  static void setUsername(String username) { _username = username; }

  static get avatarUrl => _avatarUrl;
  static void setAvatarUrl(String avatarUrl) { _avatarUrl = avatarUrl; }

  static Future<void> _post(Map<String, dynamic> body) async {
    final prefs = await SharedPreferences.getInstance();
    _url ??= prefs.getString('url');
    if (_username != null) body['username'] = _username;
    if (_avatarUrl != null) body['avatar_url'] = _avatarUrl;
    final response = await http.post(
      Uri.parse(_url!),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
      body: jsonEncode(body)
    );
  }

  static Future<void> send(String message) async {
    await _post({"content": message});
  }

  static Future<void> embeds(List<Embed> embeds) async {
    await _post({"embeds": embeds.map((e) => e.toJson()).toList()});
  }
}