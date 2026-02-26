import 'package:flutter/material.dart';
import 'package:manga_zen/Manga/Manga.dart';

class TopMangasTile extends StatelessWidget {
  final Manga firstManga;
  final bool isLandscape;
  const TopMangasTile({
    super.key,
    required this.firstManga,
    required this.isLandscape,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Stack(
        children: [
          ShaderMask(
            shaderCallback: (Rect bounds) {
              return LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.center,

                colors: [Colors.black87, Colors.transparent],
              ).createShader(bounds);
            },
            blendMode: BlendMode.darken,
            child: SizedBox(
              width: isLandscape ? 980 : 480,
              height: isLandscape ? 800 : 280,
              child: AspectRatio(
                aspectRatio: 9 / 14,
                child: FadeInImage.assetNetwork(
                  placeholder: 'assets/Placeholder.png',
                  image: firstManga.image,
                  fit: BoxFit.cover,
                  fadeInDuration: Duration(milliseconds: 300),
                ),
              ),
            ),
          ),

          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      firstManga.title,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  const SizedBox(width: 5),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
