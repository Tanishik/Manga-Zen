import 'package:flutter/material.dart';
import 'package:manga_zen/Manga/Manga.dart';
import 'package:manga_zen/Pages/History_page.dart';
import 'package:manga_zen/Pages/Library_page.dart';
import 'package:manga_zen/Pages/Search_page.dart';
import 'package:manga_zen/Services/manga_api.dart';

class HomePage extends StatefulWidget {



   HomePage({super.key});


  @override
  State<HomePage> createState() => _HomePageState();
}

List <Manga>mangaList = [];
bool isLoading=true;
class _HomePageState extends State<HomePage> {

  int _SelectedIndex = 0;

   
  

  

  void navigateBottomBar(int index) {
  setState(() {
     _SelectedIndex = index;
  });
} 

@override
     void initState(){
      super.initState();
      LoadManga();
     }

     Future<void> LoadManga()async{

      final manga = await MangaService.fetchManga();

      setState(() {
        mangaList=manga;
        isLoading=false;
      });

     }
  
 

  @override

 

  Widget build(BuildContext context) {

 
    final List<Widget>_pages=[

    LibraryPage(),
    SearchPage(),
    HistoryPage()
   
    
  ];


    return Scaffold(
      backgroundColor: Colors.black,
     

      body: _pages [_SelectedIndex],
       bottomNavigationBar: BottomNavigationBar(
        onTap: navigateBottomBar,
        currentIndex: _SelectedIndex,
        selectedItemColor: const Color.fromARGB(255, 185, 2, 2),
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: Colors.grey.shade900,
        
        
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.book),
          label: "Library"),

            BottomNavigationBarItem(icon: Icon(Icons.search_outlined),
          label: "Discover"),
         

           BottomNavigationBarItem(icon: Icon(Icons.history),
          label: "History"),
         
         

        ])
    );
    
  }
}
