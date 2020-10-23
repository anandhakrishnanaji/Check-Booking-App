import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _session = null, _userid = null, _name = null;
  List _iconlist = [];

  get name => _name;
  get session => _session;
  get userid => _userid;
  get iconlist => _iconlist;

  Future<bool> login(String mobile, String password) async {
    final url =
        'https://genapi.bluapps.in/Serv_v3/login_v3?utype=club&mobile=$mobile&pass=$password&utype=club';
    try {
      print('hi');
      final response = await http.get(url);
      final jresponse = json.decode(response.body) as Map;
      if (jresponse['status'] == 'failed')
        throw (jresponse['message']);
      else {
        print(jresponse);
        _session = jresponse['session_id'];
        _userid = jresponse['user_id'];
        _name = jresponse['vendor_name'];
        await _saveToken();
        return true;
      }
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> _saveToken() async {
    SharedPreferences shr = await SharedPreferences.getInstance();
    shr.setString('session', _session);
    shr.setString('userid', _userid);
    shr.setString('name', _name);
  }

  Future<bool> isloggedin() async {
    SharedPreferences shr = await SharedPreferences.getInstance();
    if (shr.containsKey('session') && shr.containsKey('userid')) {
      _session = shr.getString('session');
      _userid = shr.getString('userid');
      _name = shr.getString('name');
      final response = await http.get(
          'https://genapi.bluapps.in/Serv_v3/club_service?user_id=$_userid&session_id=$_session');
      final jresponse = json.decode(response.body);
      if (jresponse['status'] == 'failed') {
        shr.clear();
        return false;
      } else {
        _iconlist = jresponse['data'];
        return true;
      }
    } else
      return false;
  }

  Future<List> obtainIcons() async {
    print(_iconlist == []);
    try {
      if (_iconlist.length == 0) {
        final url =
            'https://genapi.bluapps.in/Serv_v3/club_service?user_id=$_userid&session_id=$_session';
        final response = await http.get(url);
        final jresponse = json.decode(response.body) as Map;
        print(jresponse);
        if (jresponse['status'] == 'failed') throw (jresponse['message']);
        _iconlist = jresponse['data'];
        return _iconlist;
      } else
        return _iconlist;
    } catch (e) {
      throw (e.toString());
    }
  }

  Future<void> logout() async {
    SharedPreferences shr = await SharedPreferences.getInstance();
    final response = await http
        .get('https://genapi.bluapps.in/Serv_v3/logout?session_id=$session');
    final jresponse = json.decode((response.body)) as Map;
    if (jresponse['status'] == 'failed') throw (jresponse['message']);
    shr.clear();
    _session = null;
  }
}
