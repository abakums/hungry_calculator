import 'package:http/http.dart' as http;

class Network {
  final String scheme = 'http';
  final String host = '185.231.154.195';
  final int port = 80;
  String path;
  String? fragment;
  late Uri url;

  Network({required this.path, this.fragment}) {
    url = Uri(
      scheme: scheme,
      host: host,
      port: port,
      path: 'api/$path',
      fragment: fragment,
    );
  }

  Future<http.Response> post(String jsonEncode) {
    return http.post(Uri.parse(url.toString()),
        headers: <String, String>{
          "Content-Type": "application/json;charset=UTF-8",
        },
        body: jsonEncode);
  }

  Future<http.Response> get() {
    return http.get(Uri.parse(url.toString()));
  }
}
