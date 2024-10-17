import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/journal.dart';

class JournalService {
  static const String url = "http://192.168.1.16:3000/";
  static const String resource = "journals/";

  String getUrl() {
    return "$url$resource";
  }

  Future<void> register(Journal journal) async {
    try {
      String jsonJournal = json.encode(journal.toMap());

      var response = await http.post(
        Uri.parse(getUrl()),
        headers: {"Content-Type": "application/json"},
        body: jsonJournal,
      );

      if (response.statusCode == 200) {
        print("Request successful: ${response.body}");
      } else {
        print("Failed with status: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<String> get() async {
    http.Response response = await http.get(Uri.parse(getUrl()));

    return response.body;
  }
}