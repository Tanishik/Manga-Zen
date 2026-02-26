import 'package:flutter/material.dart';
import 'package:manga_zen/Manga/Manga.dart';

class MangaTiles2 extends StatelessWidget {
  final Manga manga;
  const MangaTiles2({super.key, required this.manga});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(12),
        child: GestureDetector(
          child: Column(
            children: [
              Stack(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
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
                    ],
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            manga.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //    Padding(
              //      padding: const EdgeInsets.only(left: 10),
              //      child: Container(
              //       decoration: BoxDecoration(
              //         borderRadius: BorderRadius.circular(4),
              //         color: Colors.grey.shade800
              //       ),
              //        child: Padding(
              //          padding: const EdgeInsets.all(1.0),
              //          child: Text(manga.rank,
              //                   maxLines: 1,
              //                   overflow: TextOverflow.ellipsis,
              //                   style: const TextStyle(
              //                     color: Colors.white,
              //                     fontSize: 14,
              //                     fontWeight: FontWeight.bold
              //                   ),),

              //        ),
              //      ),
              //    ),

              //    const SizedBox(width: 5,),

              //      Text(manga.view,
              //             maxLines: 1,
              //             overflow: TextOverflow.ellipsis,
              //             style: const TextStyle(

              //               color: Colors.grey,
              //               fontSize: 9,
              //               fontWeight: FontWeight.bold
              //             ),),

              // ]
              // )
            ],
          ),
        ),
      ),
    );
  }
}
