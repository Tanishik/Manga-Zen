import 'dart:convert';
import 'package:http/http.dart' as http;
import '../Manga/Manga.dart';

class Top50MangaService {

  static Future<List<Manga>> fetchManga({int offset = 0}) async {

    final url = Uri.parse(
      "https://api.mangadex.org/manga"
      "?limit=50"
      "&offset=$offset"
      "&order[followedCount]=desc"
      "&includes[]=cover_art",
    );

    final response = await http.get(url);

    if (response.statusCode != 200) {
      throw Exception("Failed to load manga");
    }

    final data = jsonDecode(response.body);
    List mangas = data["data"];

    return mangas.map<Manga>((json) {

      final attributes = json["attributes"];

      final titleMap = attributes["title"];
      final title = titleMap["en"] ?? titleMap.values.first;

      final relationships = json["relationships"];

      String coverFile = "";

      for (var rel in relationships) {
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
