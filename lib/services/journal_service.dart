import 'package:http/http.dart' as http;

class JournalService {
  static const String url = "http://192.168.1.16:3000/";
  static const String resource = "learnhttp";

  String getUrl() {
    return "$url$resource";
  }

  register(String content) async {
    await http.post(Uri.parse(getUrl()), body: {"content": content});
  }

  Future<String> get() async {
    http.Response response = await http.get(Uri.parse(getUrl()));

    return response.body;
  }
}