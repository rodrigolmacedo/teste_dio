import 'dart:async';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  Completer<SharedPreferences> instance = Completer<SharedPreferences>();

  LocalStorageService() {
    _initLocalStorage();
  }

  _initLocalStorage() async {
    SharedPreferences share = await SharedPreferences.getInstance();
    if (!instance.isCompleted) instance.complete(share);
  }

  Future<bool> put(String key, Map<String, dynamic> json) async {
    try {
      SharedPreferences share = await instance.future;
      share.setString(key, jsonEncode(json));
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> set(String key, String value) async {
    try {
      SharedPreferences share = await instance.future;
      share.setString(key, value);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<String> getString(String key) async {
    try {
      SharedPreferences share = await instance.future;
      String value = share.getString(key) ?? null;
      return value;
    } catch (e) {
      return null;
    }
  }

  Future<List<String>> getStringList(String key) async {
    SharedPreferences share = await instance.future;
    return share.getStringList(key) ?? new List<String>();
  }

  setStringList(List<String> list, String key) async {
    SharedPreferences share = await instance.future;
    share.setStringList(key, list);
  }

  Future<bool> containIn(String key) async {
    SharedPreferences share = await instance.future;
    if (share.containsKey(key))
      return true;
    else
      return false;
  }

  Future get<S>(String key, {S Function(Map) construct}) async {
    try {
      SharedPreferences share = await instance.future;
      String value = share.getString(key);
      Map<String, dynamic> json = jsonDecode(value);

      if (construct == null) {
        return json;
      } else {
        return construct(json);
      }
    } catch (e) {
      return null;
    }
  }

  Future remove(String key) async {
    SharedPreferences share = await instance.future;
    return share.remove(key);
  }

  Future removeAll() async {
    SharedPreferences share = await instance.future;
    return share.clear();
  }

  static const String TOKEN = "TOKEN";
}
