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
    String jsonJournal = json.encode(journal.toMap());

    var response = await http.post(
      Uri.parse(getUrl()),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonJournal,
    );

    if (response.statusCode != 201) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }

      throw Exception(response.body);
    }

    return true;
  }

  Future<bool> edit(String id, Journal journal, String token) async {
    journal.updatedAt = DateTime.now();
    String jsonJournal = json.encode(journal.toMap());

    var response = await http.put(
      Uri.parse("${getUrl()}$id"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token"
      },
      body: jsonJournal,
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }

      throw Exception(response.body);
    }

    return true;
  }

  Future<List<Journal>> getAll({required String id, required String token}) async {
    http.Response response = await http.get(
      Uri.parse("${url}users/$id/journals"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }

      throw Exception(response.body);
    }

    List<Journal> list = [];
    List<dynamic> listDynamic = json.decode(response.body);

    for (var jsonMap in listDynamic) {
      list.add(Journal.fromMap(jsonMap));
    }

    return list;
  }

  Future<bool> delete(String id, String token) async {
    http.Response response = await http.delete(
      Uri.parse("${getUrl()}$id"),
      headers: {"Authorization": "Bearer $token"},
    );

    if (response.statusCode != 200) {
      if (json.decode(response.body) == "jwt expired") {
        throw TokenNotValidException();
      }

      throw Exception(response.body);
    }

    return true;
  }
}

class TokenNotValidException implements Exception{}