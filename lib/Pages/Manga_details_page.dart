import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga_zen/Manga/Manga.dart';
import 'package:manga_zen/Pages/Reader_page.dart';
import 'package:manga_zen/Services/Chapter_services.dart';
import 'package:manga_zen/Tiles/Chapter_tile.dart';

class MangaDetails extends StatefulWidget {
  final Manga mangaId;
  const MangaDetails({super.key, required this.mangaId});

  @override
  State<MangaDetails> createState() => _MangaDetailsState();
}

class _MangaDetailsState extends State<MangaDetails> {
  late Box favoritesBox;
  Set<String> readChapter = {};
  late Box readBox;

  List<Chapter> chapters = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    readBox = Hive.box('readChapters');
    favoritesBox = Hive.box('favorites');
    loadChapters();
  }

  Future<void> loadChapters() async {
    print('fetch Start');
    final result = await fetchChapters(widget.mangaId.id);

    print('fetched');

    setState(() {
      chapters = result;
      isLoading = false;
    });
  }

  bool get isFavorite => favoritesBox.containsKey(widget.mangaId.id);

  void toggleFavorite() {
    setState(() {
      if (isFavorite) {
        favoritesBox.delete(widget.mangaId.id);
      } else {
        favoritesBox.put(widget.mangaId.id, {
          "id": widget.mangaId.id,
          "title": widget.mangaId.title,
          "image": widget.mangaId.image,
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isLandsape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    if (isLoading) {
      return Scaffold(
        backgroundColor: const Color.fromARGB(255, 21, 21, 21),
        body: const Center(
          child: CircularProgressIndicator(
            color: Color.fromARGB(255, 74, 14, 14),
          ),
        ),
      );
    }
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 21, 21),

      body: Column(
        children: [
          Expanded(
            child: ListView(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: isLandsape ? 940 : 500,
                      height: isLandsape ? 250 : 260,
                      child: ImageFiltered(
                        imageFilter: ImageFilter.blur(sigmaX: 5.0),
                        child: Image.network(
                          widget.mangaId.image,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                    Container(
                      width: isLandsape ? 940 : 500,
                      height: isLandsape ? 280 : 260,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          stops: [0.2, 1.0],
                          colors: [
                            const Color.fromARGB(255, 21, 21, 21),
                            Colors.black54,
                          ],
                        ),
                      ),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                            right: 15,
                            left: 15,
                            bottom: 15,
                            top: 70,
                          ),
                          child: SizedBox(
                            height: 170,
                            width: 120,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: FadeInImage.assetNetwork(
                                placeholder: 'assets/Placeholder.png',
                                image: widget.mangaId.image,
                                fit: BoxFit.cover,
                                fadeInDuration: Duration(milliseconds: 300),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.mangaId.title,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 25,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.person_2_outlined,
                                    color: Colors.white54,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    widget.mangaId.mangaka,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 18,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.brush_rounded,
                                    color: Colors.white54,
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'This is a ${widget.mangaId.status} series',
                                    style: const TextStyle(
                                      color: Colors.white54,
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    AppBar(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      scrolledUnderElevation: 0,
                      title: Text(widget.mangaId.title),
                      actions: [],
                    ),
                  ],
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Favorite button
                    Column(
                      children: [
                        IconButton(
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: Colors.white54,
                            size: 25,
                          ),
                          onPressed: () {
                            toggleFavorite();
                          },
                        ),
                        const Text(
                          'Library',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),

                    // Placeholder buttons
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.hourglass_empty,
                            color: Colors.white54,
                            size: 25,
                          ),
                          onPressed: () {},
                        ),
                        const Text(
                          'Soon',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.sync,
                            color: Colors.white54,
                            size: 25,
                          ),
                          onPressed: () {},
                        ),
                        const Text(
                          'Tracking',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          icon: const Icon(
                            Icons.web,
                            color: Colors.white54,
                            size: 25,
                          ),
                          onPressed: () {},
                        ),
                        const Text(
                          'WebView',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 14,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                chapters.isEmpty
                    ? Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40),
                          child: Text(
                            'No Chapters yet.',
                            style: TextStyle(
                              color: Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      )
                    : ListView.builder(
                        itemCount: chapters.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          final _chapter = chapters[index];

                          print('Manga Details page');

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                readBox.put(_chapter.id, _chapter.id);
                              });

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => ReaderPage(
                                    chapterList: chapters,
                                    key: UniqueKey(),
                                    manga: widget.mangaId,
                                    chapter: chapters[index],
                                  ),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(5.0),
                              child: ChapterTile(chapter: _chapter),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
