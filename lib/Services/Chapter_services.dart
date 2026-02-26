import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Manga/Manga.dart';

Future<List<Chapter>> fetchChapters(String mangaId) async {
  final url =
      "https://api.mangadex.org/chapter?manga=$mangaId&translatedLanguage[]=en&order[chapter]=asc&limit=100";

  final response = await http.get(Uri.parse(url));
  final data = jsonDecode(response.body);

  final List chaptersJson = data["data"];

  return chaptersJson.map((c) {
    final attr = c["attributes"];

    return Chapter(
      id: c["id"],
      chapterTitle: attr["title"] ?? "Chapter ${attr["chapter"]}",
      number: attr["chapter"] ?? "0",
      thumbnail: "",
    );
  }).toList();
}
