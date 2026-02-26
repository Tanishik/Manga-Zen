import 'package:flutter/material.dart';
import 'package:manga_zen/Manga/Manga.dart';
import 'package:manga_zen/Services/Pages_service.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ReaderItem {
  final String? imagePath;
  final String? currentTitle;
  final String? nextTitle;
  final bool isBreak;

  ReaderItem.page(this.imagePath)
      : currentTitle = null,
        nextTitle = null,
        isBreak = false;

  ReaderItem.breakScreen({
    required this.currentTitle,
    required this.nextTitle,
  })  : imagePath = null,
        isBreak = true;
}

class ReaderPage extends StatefulWidget {
  final Manga manga;
  final Chapter chapter;
  final List<Chapter> chapterList;

  const ReaderPage({
    super.key,
    required this.manga,
    required this.chapter,
    required this.chapterList,
  });

  @override
  State<ReaderPage> createState() => _ReaderPageState();
}

class _ReaderPageState extends State<ReaderPage> {
  late List<ReaderItem> allItems;
  late PageController _pageController;

  int currentIndex = 0;
  bool isLoading = true;
  bool isFetchingNextChapter = false;
  bool readingOrient = true;

  late int currentChapterIndex;

  @override
  void initState() {
    super.initState();
    currentChapterIndex =
        widget.chapterList.indexWhere((c) => c.id == widget.chapter.id);
    _pageController = PageController(initialPage: 0);
    _initReader();
  }

  Future<void> _initReader() async {
    allItems = [];
    await loadChapter(widget.chapter);
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  Future<void> loadChapter(Chapter chapter, {bool append = false}) async {
    final pages =
        await PagesService.fetchChapterPages(chapter.id).timeout(
      const Duration(seconds: 8),
    );

    final List<ReaderItem> newItems = [];

    if (!append) {
      newItems.add(
        ReaderItem.breakScreen(
          currentTitle: chapter.chapterTitle,
          nextTitle: currentChapterIndex > 0
              ? widget.chapterList[currentChapterIndex - 1].chapterTitle
              : "Previous Chapter",
        ),
      );
    }

    for (final page in pages) {
      newItems.add(ReaderItem.page(page));
    }

    String nextTitle = "No Next Chapters";
    if (currentChapterIndex + 1 < widget.chapterList.length) {
      nextTitle = widget.chapterList[currentChapterIndex + 1].chapterTitle;
    }

    newItems.add(
      ReaderItem.breakScreen(
        currentTitle: chapter.chapterTitle,
        nextTitle: nextTitle,
      ),
    );

    if (append) {
      allItems.addAll(newItems);
    } else {
      allItems = newItems;
    }

    // Preload images
    for (final item in newItems) {
      if (!item.isBreak) precacheImage(NetworkImage(item.imagePath!), context);
    }
  }

  Widget _buildBreakScreen(String current, String next) {
    final bool isNoNext = next == "No Next Chapters";
    final bool isFirstChapter = currentChapterIndex == 0;
    final String titleLabel = isFirstChapter ? "First Chapter:" : "Finished:";

    return readingOrient == true
      ? Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(titleLabel,
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Text(
                current,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                isNoNext
                    ? "No Next Chapters"
                    : "Swipe for Next Chapter ->",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        )
      : Container(
          color: Colors.black,
          height: MediaQuery.of(context).size.height,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(titleLabel,
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 8),
              Text(
                current,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 25),
              Text(
                isNoNext
                    ? "No Next Chapters"
                    : "Swipe for Next Chapter ^",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
  }
  



    void preLoadImage(int index) {
    for (int i = 1; i <= 3; i++) {
      final backIndex = index - i;
      if (backIndex >= 0 && backIndex < allItems.length) {
        final item = allItems[backIndex];
        if (!item.isBreak) {
          precacheImage(NetworkImage(item.imagePath!), context);
        }
      }
    }


    for (int i = 1; i <= 3; i++) {
      final forwardIndex = index + i;
      if (forwardIndex >= 0 && forwardIndex < allItems.length) {
        final item = allItems[forwardIndex];
        if (!item.isBreak) {
          precacheImage(NetworkImage(item.imagePath!), context);
        }
      }
    }
  }


  @override
  Widget build(BuildContext context) {


    if (isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Color.fromARGB(255, 74, 14, 14)),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                    context: context,
                    builder: (_) => AlertDialog(
                          backgroundColor: Colors.grey.shade900,
                          title: const Text(
                            'Reading Direction',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 22,
                                fontFamily: 'Montserrat'),
                          ),
                          actions: [
                            Row(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      readingOrient = false;
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Reading Direction: Vertical ^'),
                                          ],
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.black12,
                                        duration: Duration(seconds: 1),
                                      ));
                                    });
                                  },
                                  child: Text(
                                    "Vertical",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: readingOrient == false
                                          ? Colors.red
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      readingOrient = true;
                                      Navigator.pop(context);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text('Reading Direction: Horizontal ->'),
                                          ],
                                        ),
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: Colors.black12,
                                        duration: Duration(seconds: 1),
                                      ));
                                    });
                                  },
                                  child: Text(
                                    "Horizontal",
                                    style: TextStyle(
                                      fontFamily: 'Montserrat',
                                      color: readingOrient == true
                                          ? Colors.red
                                          : Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ));
              },
              child: Icon(Icons.settings, color: Colors.white),
            ),
          )
        ],
      ),
      body: readingOrient
          ? PhotoViewGallery.builder(
            
              pageController: _pageController,
              reverse: true,
              itemCount: allItems.length,
              
                     
              onPageChanged: (index) async {

          
                     
              
                    preLoadImage(index);
                 
                    setState(() => currentIndex = index);
                    

               
               
                    final item = allItems[index];
                   
               
                    if (item.isBreak &&
                        item.nextTitle != "No Next Chapters" &&
                        !isFetchingNextChapter) {
                      isFetchingNextChapter = true;
               
                      if (currentChapterIndex + 1 < widget.chapterList.length) {
                        currentChapterIndex++;
                        final nextChapter = widget.chapterList[currentChapterIndex];
                     
                        await loadChapter(nextChapter, append: true);
               
                        if (mounted) setState(() {});
                      }
               
                      isFetchingNextChapter = false;
                    }
                  },

              builder: (context, index) {
                final item = allItems[index];
                if (item.isBreak) {
                  return PhotoViewGalleryPageOptions.customChild(
                    
                    child: _buildBreakScreen(item.currentTitle!, item.nextTitle!),
                  );
                }
                return PhotoViewGalleryPageOptions(
                  
                  imageProvider: NetworkImage(item.imagePath!),
                  
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  
                  heroAttributes: PhotoViewHeroAttributes(tag: item.imagePath!),
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              
              backgroundDecoration: const BoxDecoration(color: Colors.black),
              
            )
          : PhotoViewGallery.builder(
              pageController: _pageController,
              scrollDirection: Axis.vertical,
          
              itemCount: allItems.length,
                 onPageChanged: (index) async {
                 preLoadImage(index);
                setState(() => currentIndex = index);


                final item = allItems[index];

 
                    if (item.isBreak &&
                       item.nextTitle != "No Next Chapters" &&
                       !isFetchingNextChapter) {
                       isFetchingNextChapter = true;


                      if (currentChapterIndex + 1 < widget.chapterList.length) {
                      currentChapterIndex++;
                      final nextChapter = widget.chapterList[currentChapterIndex];
                        await loadChapter(nextChapter, append: true);


                        if (mounted) setState(() {});
                        }


                         isFetchingNextChapter = false;
                          }
                            },


              builder: (context, index) {
                final item = allItems[index];
                if (item.isBreak) {
                  return PhotoViewGalleryPageOptions.customChild(
                    
                    child: _buildBreakScreen(item.currentTitle!, item.nextTitle!),
                  );
                }
                return PhotoViewGalleryPageOptions(
                  
                  
                  imageProvider: NetworkImage(item.imagePath!),
                  
                  minScale: PhotoViewComputedScale.contained,
                  maxScale: PhotoViewComputedScale.covered * 3,
                  heroAttributes: PhotoViewHeroAttributes(tag: item.imagePath!),
                );
              },
              scrollPhysics: const BouncingScrollPhysics(),
              backgroundDecoration: const BoxDecoration(color: Colors.black),
            )
    );
  }
}
