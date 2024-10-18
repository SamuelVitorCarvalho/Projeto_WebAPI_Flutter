import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/journal.dart';

class JournalService {
  static const String url = "http://192.168.1.16:3000/";
  static const String resource = "journals/";

  String getUrl() {
    return "$url$resource";
  }

  Future<bool> register(Journal journal, String token) async {
    try {
      String jsonJournal = json.encode(journal.toMap());

      var response = await http.post(
        Uri.parse(getUrl()),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonJournal,
      );

      if (response.statusCode == 201) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    try {
      String jsonJournal = json.encode(journal.toMap());

      var response = await http.put(
        Uri.parse("${getUrl()}$id"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token"
        },
        body: jsonJournal,
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<List<Journal>> getAll(
      {required String id, required String token}) async {
    http.Response response = await http.get(
      Uri.parse("${url}users/$id/journals"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      throw Exception();
    }

    List<Journal> list = [];
    List<dynamic> listDynamic = json.decode(response.body);

    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }

    return list;
  }

  Future<bool> delete(String id) async {
    try {
      http.Response response = await http.delete(Uri.parse("${getUrl()}$id"));

      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
