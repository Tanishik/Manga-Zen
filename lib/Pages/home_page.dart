import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:manga_zen/Manga/Manga.dart';
import 'package:manga_zen/Pages/History_page.dart';
import 'package:manga_zen/Pages/Library_page.dart';
import 'package:manga_zen/Pages/Search_page.dart';
import 'package:manga_zen/Services/manga_api.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

List<Manga> mangaList = [];
bool isLoading = true;

class _HomePageState extends State<HomePage> {
  int _SelectedIndex = 0;

  void navigateBottomBar(int index) {
    setState(() {
      _SelectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    LoadManga();
  }

  Future<void> LoadManga() async {
    final manga = await MangaService.fetchManga();

    setState(() {
      mangaList = manga;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [LibraryPage(), SearchPage(), HistoryPage()];

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.black,

      body: IndexedStack(
        index: _SelectedIndex,
        children: pages,

      ),


      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(35),
            color: Colors.grey.shade900
          ),

          child: Padding(
            padding: const EdgeInsets.all(8.0),

            child: GNav(
              
              padding: EdgeInsetsGeometry.symmetric(
                horizontal: 25,
                vertical: 20
              ),
              tabBackgroundColor: Colors.grey.shade800,
              tabs: [
                GButton(
                icon: Icons.book,
                text: "Library",
                iconColor: Colors.grey.shade600,
                  iconActiveColor: const Color.fromARGB(255, 184, 2, 2),
                  textColor: const Color.fromARGB(255, 184, 2, 2),
                ),
            
                 GButton(
                  icon: Icons.search_outlined,
                  text: "Discover",
                  iconColor: Colors.grey.shade600,
                  iconActiveColor: const Color.fromARGB(255, 184, 2, 2),
                  textColor: const Color.fromARGB(255, 184, 2, 2),),
            
                  GButton(
                  icon: Icons.history,
                  text: "History",
                  iconColor: Colors.grey.shade600,
                    iconActiveColor: const Color.fromARGB(255, 184, 2, 2),
                  textColor: const Color.fromARGB(255, 184, 2, 2),
                  )
            
              ],
              selectedIndex: _SelectedIndex,
              onTabChange: (value) {
                setState(() {
                  _SelectedIndex = value;
                });
              },
              ),
          ),
        ),
      )
    );
  }
}
