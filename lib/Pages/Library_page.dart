import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga_zen/Manga/Manga.dart';
import 'package:manga_zen/Pages/Edit_profile_page.dart';
import 'package:manga_zen/Pages/Manga_details_page.dart';
import 'package:manga_zen/Tiles/manga_tiles.dart';

class LibraryPage extends StatefulWidget {
  const LibraryPage({super.key});

  @override
  State<LibraryPage> createState() => _LibraryPageState();
}



class _LibraryPageState extends State<LibraryPage> {



 

  @override
  Widget build(BuildContext context) {
    final isLandsape = 
    MediaQuery.of(context).orientation ==
    Orientation.landscape;

    final profilebox = Hive.box('Profile');
  

    final box = Hive.box('favorites');

  
  
  

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 21, 21),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Library',
        style: TextStyle(color: Colors.white,
        fontWeight: FontWeight.bold,
        fontFamily: 'Montserrat',),),

        actions: [

           Padding(
                              padding: const EdgeInsets.all(12),
                              child: ValueListenableBuilder(
                                  valueListenable: profilebox.listenable(),
                                   builder: (context, Box box, _) {
                                      final username = box.get('username',defaultValue: '_Guest');
                                     final selectedIndex = profilebox.get('pfpIndex',defaultValue: -1);

                                   

                                     return GestureDetector(
                                      onTap: () {
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => EditProfilePage()));
                                      },
                                       child: Row(
                                  
                                         children: [

                                   Text(username,style: 
                                TextStyle(color: Colors.white,fontSize: 17,fontWeight: FontWeight.bold,fontFamily: 'Montserrat',),),

                                const SizedBox(width: 5,),


                                           CircleAvatar(
                                           radius: 20,
                                           backgroundColor: Colors.white,
                                          backgroundImage: selectedIndex == -1
                                         ?null
                                      :AssetImage(AvatarData.avatars[selectedIndex]),
                                      child: selectedIndex == -1
                                    ? const Icon(Icons.person,
                                 color: Colors.grey,size: 30,):null,
                                      ),      
                                         ],
                                       ),
                                     );
                                   },)
                              ),
                                ],
                               ),


      body: ValueListenableBuilder(
        valueListenable: box.listenable(),
        builder: (context, Box box, _) {

            final savedMangas = box.values.map((data){

         final map = Map<String,dynamic>.from(data);
          return Manga(
           id: map["id"],
           image: map["image"], 
           title: map['title'], 
           rank: '', 
           view: '', 
         chapters: [], 
          isTop: false, 
         mangaka: 'unknown', 
         status: 'unknown');
    }).toList();



          return Padding(
            padding: const EdgeInsets.all(10),
            child: savedMangas.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text('૮(˶ㅠ︿ㅠ)ა',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 27
                        ),),
                        SizedBox(height: 2,),
                        Text(
                          'Your Library is empty',
                          style: TextStyle(
                            fontFamily: 'Montserrat',
                            color: Colors.grey,
                            fontSize: 15,
                          ),
                        ),
                      ],
                    ),
                  )
                : isLandsape?
                GridView.builder(
                    itemCount: savedMangas.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 5,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 20,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final manga = savedMangas[index];

                      return GestureDetector(
                        onTap: () {
                          final historyBox = Hive.box('history');

                          historyBox.put(manga.id, {
                            "id": manga.id,
                            "title":manga.title,
                            "image":manga.image
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MangaDetails(mangaId: manga),
                              
                            ),
                            
                          );
                          setState(() {
                            
                          });
                        },
                        child: MangaTiles(manga: manga),
                      );
                    },
                  ):
                GridView.builder(
                    itemCount: savedMangas.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      childAspectRatio: 0.65,
                    ),
                    itemBuilder: (context, index) {
                      final manga = savedMangas[index];

                      return GestureDetector(
                        onTap: () {
                          final historyBox = Hive.box('history');

                          historyBox.put(manga.id, {
                            "id": manga.id,
                            "title":manga.title,
                            "image":manga.image
                          });

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => MangaDetails(mangaId: manga),
                              
                            ),
                            
                          );
                          setState(() {
                            
                          });
                        },
                        child: MangaTiles(manga: manga),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
