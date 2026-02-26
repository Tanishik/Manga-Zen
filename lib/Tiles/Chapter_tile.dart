import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:manga_zen/Manga/Manga.dart';

class ChapterTile extends StatefulWidget {
  final Chapter chapter;



  const ChapterTile({
    super.key,
    required this.chapter,
    
  });

  @override
  State<ChapterTile> createState() => _ChapterTileState();
}

class _ChapterTileState extends State<ChapterTile> {
  @override
  Widget build(BuildContext context) {

    final readBox = Hive.box('readChapters');
  
   final bool isRead = readBox.containsKey(widget.chapter.id);
  

        return Container(
          decoration: BoxDecoration(
            color: isRead
                ? Colors.grey.shade900
                : Colors.white24,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
              
                const SizedBox(width: 15),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chapter: ${widget.chapter.number}',
                        style: TextStyle(
                          color: isRead
                              ? Colors.grey.shade500
                              : Colors.white70,
                          fontSize: 13,
                        ),
                      ),
                      widget.chapter.chapterTitle.isEmpty
                      ?Text('title: Unavailable',style: TextStyle(color: Colors.white70,fontWeight: FontWeight.bold),)
                      :Text(
                       " ${widget.chapter.chapterTitle}",
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: isRead
                              ? Colors.grey.shade500
                              : Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    
                    ],
                  ),
                ),
                const Icon(
                  Icons.download_for_offline_outlined,
                  color: Colors.white70,
                ),
              ],
            ),
          ),
        
      
    );
  }
}
