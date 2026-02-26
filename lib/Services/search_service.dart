import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Manga/Manga.dart';

class SearchService {

  static Future<List<Manga>> searchManga(String query) async {

    final url = Uri.parse(
      "https://api.mangadex.org/manga"
      "?title=$query"
      "&limit=20"
      "&includes[]=cover_art"
      "&order[relevance]=desc",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Search request failed");
    }

    final data = jsonDecode(response.body);
    List mangas = data["data"];

    return mangas.map((json) {

      final attributes = json["attributes"];

      // title extraction
      final titleMap = attributes["title"];
      final title =
          titleMap["en"] ?? titleMap.values.first;

      // cover extraction
      String coverFile = "";

      for (var rel in json["relationships"]) {
        if (rel["type"] == "cover_art") {
          coverFile = rel["attributes"]["fileName"];
        }
      }

      final coverUrl =
          "https://uploads.mangadex.org/covers/${json["id"]}/$coverFile.256.jpg";

      return Manga(
        id: json["id"],
        title: title,
        image: coverUrl,
        view: "0",
        rank: "#--",
        status: "Unknown",
        chapters: [],
        mangaka: "Unknown",
        isTop: false,
      );

    }).toList();
  }
}
