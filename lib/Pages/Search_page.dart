import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:manga_zen/Manga/Manga.dart';
import 'package:manga_zen/Pages/Manga_details_page.dart';
import 'package:manga_zen/Services/manga_api.dart';
import 'package:manga_zen/Services/search_service.dart';
import 'package:manga_zen/Services/top3_manga.dart';
import 'package:manga_zen/Tiles/Manga_tiles_Exolore_page.dart';
import 'dart:async';
import 'package:manga_zen/Tiles/top_mangas_tile.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Manga> mangaList = [];
  List<Manga> topMangas = [];
  List<Manga> filteredMangas = [];
  bool isLoading = true;
  bool isSearching = false;
  final PageController _controller =PageController();
  int _currentpage = 0;
   final int _totalPages= 5;
   Timer? _timer;


  final box = Hive.box('history');
 

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
   
    loadMangas();

    _timer = Timer.periodic(Duration(seconds: 3), 
    (timer){
      if(_currentpage < _totalPages -1){
        _currentpage++;
      }else{
        _currentpage = 0;
      }
      _controller.animateToPage( 
        _currentpage,  
        duration: Duration(milliseconds: 500), 
        curve: Curves.easeInOut);
    }
    );
     
  }

    Future<void> _refreshPage()async{
    await Future.delayed(const Duration(seconds: 1));
     final manga = await MangaService.fetchManga();
    final manga2 = await Top3MangaService.fetchManga();

       setState(() {
      topMangas = manga2;
      mangaList = manga;
      filteredMangas = manga;
     
    });

   
    
  }

  Future<void> loadMangas() async {
    final manga = await MangaService.fetchManga();
    final manga2 = await Top3MangaService.fetchManga();

    if (!mounted) return;

    setState(() {
      topMangas = manga2;
      mangaList = manga;
      filteredMangas = manga;
      isLoading = false;
    });
  }





  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

     final isLandsape = 
    MediaQuery.of(context).orientation ==
    Orientation.landscape;

   
    if (isLoading) {
      return const Scaffold(
        backgroundColor: Color.fromARGB(255, 21, 21, 21),
        body: Center(
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
          SizedBox(height: 30,),
      
          SizedBox(
            height: 75,
            
            child: Padding(
              padding: const EdgeInsets.all(15),
              child: SearchBar(
                leading:
                    const Icon(Icons.search_outlined, color: Colors.white),
                backgroundColor: WidgetStateColor.resolveWith(
                    (state) => const Color.fromARGB(255, 91, 91, 91)),
                hintText: 'Search by title',
                textStyle: const WidgetStatePropertyAll(
                    TextStyle(color: Colors.white54,fontFamily: 'Montserrat',)),
                elevation: WidgetStateProperty.all(0),
                onChanged: (value) {
                  if (_debounce?.isActive ?? false) {
                    _debounce!.cancel();
                  }

                  _debounce =
                      Timer(const Duration(milliseconds: 500), () async {
                    if (value.isEmpty) {
                      setState(() {
                        isSearching = false;
                        filteredMangas = mangaList;
                      });
                      return;
                    }

                    setState(() {
                      isSearching = true;
                    });

                    final results =
                        await SearchService.searchManga(value);

                    if (!mounted) return;

                    setState(() {
                      filteredMangas = results;
                    });
                  });
                },
              ),
            ),
          ),
         
          Expanded(
            child: filteredMangas.isEmpty
                ? const Center(
                    child: Text(
                      'No results',
                      style: TextStyle(
                          color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  )
                : RefreshIndicator(
                  color: const Color.fromARGB(255, 53, 53, 53),
                  backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                  onRefresh: _refreshPage,
                  child: CustomScrollView(
                      slivers: [

                         SliverToBoxAdapter(
                           child:  SizedBox(height: 10,),
                         ),
                        if (!isSearching)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: const Text(
                                'Top picks',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                            ),
                          ),

                        
                        if (!isSearching)
                          SliverToBoxAdapter(
                              child: SizedBox(
                                height: isLandsape?
                                400:250,
                                width: isLandsape?
                                500:350,
                                child: PageView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: topMangas.length,
                                    controller: _controller,
                                      itemBuilder: (context, index) {
                                        final manga = topMangas[index];
                                                  
                                        return  GestureDetector(
                                            onTap: () {
                                              box.put(manga.id, {
                                                "id": manga.id,
                                                "title": manga.title,
                                                "image": manga.image
                                              });
                                                  
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (_) => MangaDetails(
                                                          mangaId: manga)));
                                            },
                                            child: TopMangasTile(
                                                firstManga: manga,
                                                isLandscape: isLandsape,),
                                          );
                                        
                                      },
                                    ),
                              ),
                              
                            
                            ),
                          

                             SliverToBoxAdapter(
                           child:  SizedBox(height: 10,),
                         ),

                        if (!isSearching)
                          SliverToBoxAdapter(
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: const Text(
                                'Recently added',
                                style: TextStyle(
                                  fontFamily: 'Montserrat',
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 25),
                              ),
                            ),
                          ),

                         
                        SliverGrid.builder(
                          itemCount: filteredMangas.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            mainAxisSpacing: 14,
                            crossAxisSpacing: 14,
                            childAspectRatio: 0.53,
                          ),
                          itemBuilder: (context, index) {
                            final mangaid = filteredMangas[index];
                  
                            return GestureDetector(
                              onTap: () {
                                box.put(mangaid.id, {
                                  "id": mangaid.id,
                                  "title": mangaid.title,
                                  "image": mangaid.image
                                });
                  
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        MangaDetails(mangaId: mangaid),
                                  ),
                                );
                              },
                              child: MangaTiles2(manga: mangaid),
                            );
                          },
                        ),
                      ],
                    ),
                ),
          ),
        ],
      ),
    );
  }
}
