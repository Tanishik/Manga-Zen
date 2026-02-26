import 'package:flutter/material.dart';
import 'package:manga_zen/Manga/Manga.dart';

class MangaTiles extends StatelessWidget {
  final bool isSelected;
  final VoidCallback? onTap;

  final Manga manga;
  const MangaTiles({
    super.key,
    required this.manga,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(12),
        child: GestureDetector(
          onTap: onTap,
          child: Stack(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: AspectRatio(
                        aspectRatio: 9 / 14,
                        child: FadeInImage.assetNetwork(
                          placeholder: 'assets/Placeholder.png',
                          image: manga.image,
                          fit: BoxFit.cover,
                          fadeInDuration: Duration(milliseconds: 300),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.transparent, Colors.black45],
                  ),
                ),
              ),

              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      manga.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),

              if (isSelected)
                Container(
                  decoration: BoxDecoration(
                    color: Colors.black12,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
