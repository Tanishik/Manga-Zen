import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga_zen/Services/top50_picks.dart';
import 'package:manga_zen/Tiles/manga_tiles.dart';
import 'package:manga_zen/Manga/Manga.dart';
import 'package:manga_zen/Pages/home_page.dart';

class CustomizationPage extends StatefulWidget {
  const CustomizationPage({super.key});

  @override
  State<CustomizationPage> createState() => _CustomizationPageState();
}

class _CustomizationPageState extends State<CustomizationPage> {
  List<Manga> mangaList = [];
  bool isLoading = true;

  List<Manga> selectedMangas = [];
  final box = Hive.box('favorites');

  @override
  void initState() {
    super.initState();
    LoadManga();
  }

  Future<void> LoadManga() async {
    final manga = await Top50MangaService.fetchManga();

    setState(() {
      mangaList = manga;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    Hive.box('app').put('onboardingdone', true);

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          color: Color.fromARGB(255, 74, 14, 14),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,

      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,

          children: [
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      textAlign: TextAlign.center,
                      'Pick from our popular manga titles!',
                      style: TextStyle(
                        fontFamily: 'Montserrat',
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            Text(
              textAlign: TextAlign.center,
              'the titles you choose will appear in your Library',
              style: TextStyle(
                color: Colors.grey.shade400,
                fontSize: 10,
                fontFamily: ' Montserrat',
              ),
            ),

            const SizedBox(height: 15),

            Divider(
              color: Colors.grey.shade400,
              thickness: 0.4,
              indent: 16,
              endIndent: 16,
            ),

            const SizedBox(height: 10),

            Expanded(
              child: GridView.builder(
                itemCount: mangaList.length,

                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3,
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.45,
                ),

                itemBuilder: (context, index) {
                  final manga = mangaList[index];

                  return MangaTiles(
                    manga: manga,
                    isSelected: box.containsKey(manga.id),
                    onTap: () {
                      setState(() {
                        if (box.containsKey(manga.id)) {
                          box.delete(manga.id);
                        } else {
                          box.put(manga.id, {
                            box.put(manga.id, {
                              "id": manga.id,
                              "title": manga.title,
                              "image": manga.image,
                            }),
                          });
                        }
                      });
                    },
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            Container(
              height: 150,
              decoration: BoxDecoration(color: Colors.black),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey.shade900,
                            disabledBackgroundColor: Colors.grey.shade900,
                            foregroundColor: Colors.grey.shade400,
                            disabledForegroundColor: Colors.grey.shade600,
                          ),

                          onPressed: box.isEmpty
                              ? null
                              : () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => HomePage(),
                                    ),
                                  );
                                },

                          child: Text(
                            'Done',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (BuildContext context) => HomePage(),
                        ),
                      );
                    },
                    child: Text(
                      'Skip',
                      style: TextStyle(
                        color: Colors.grey.shade100,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
