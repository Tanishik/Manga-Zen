import 'dart:convert';
import 'package:http/http.dart' as http;




class PagesService {
static Future<List<String>> fetchChapterPages(String id) async {
  final url = Uri.parse(
    'https://api.mangadex.org/at-home/server/$id',
  );

  print('request start');

  final response = await http
      .get(
        url,
        headers: {
          'User-Agent': 'manga-zen/1.0',
          'Accept': 'application/json',
        },
      )
      .timeout(const Duration(seconds: 10));

  print('status: ${response.statusCode}');

  final data = jsonDecode(response.body);

  final baseUrl = data['baseUrl'];
  final chapter = data['chapter'];

  if (baseUrl == null || chapter == null) {
    return [];
  }

  final hash = chapter['hash'];
  final pages = chapter['data'];

  return List<String>.from(pages)
      .map((f) => '$baseUrl/data/$hash/$f')
      .toList();
}



}