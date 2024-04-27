import 'dart:convert';

Map<String, dynamic> decodeResponse(response) =>
    jsonDecode(utf8.decode(response.bodyBytes));
