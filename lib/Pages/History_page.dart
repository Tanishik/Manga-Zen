import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:manga_zen/Manga/Manga.dart';
import 'package:manga_zen/Pages/Manga_details_page.dart';
import 'package:manga_zen/Tiles/history_tile.dart';

class  HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}



class _HistoryPageState extends State<HistoryPage> {



  
 
  @override
  Widget build(BuildContext context) {


    final box = Hive.box('history');

    final historyMangas = box.values.map((data){
      

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
         status: 'unkown');


    }).toList();

          void _showdialog(){

       showDialog(context: context, builder: (context){
      return AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Remove everything?',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 22 ,fontFamily: 'Montserrat',),),

        actions: [
          Center(

            
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                Text('Are you sure? All history will be lost.',style: TextStyle(color: Colors.grey,fontSize: 10,fontFamily: 'Montserrat',),),

                const SizedBox(height: 20,),

               Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  
                 MaterialButton(onPressed: (){
               
                  Navigator.pop(context);
                },
            child: const Text('Cancel',style: TextStyle(color: Colors.white,fontFamily: 'Montserrat',),),),

          

          
            
             MaterialButton(onPressed: ()async{

                 await box.clear();
                  setState(() {
                    
                  });
              
              Navigator.pop(context);
              
             },
            child: const Text('Clear all!',style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold,fontFamily: 'Montserrat',),),)
            
                ],
               )


            ],),
          ),
        
        ],
      );
    });
    
    }


    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 21, 21, 21),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text('History',style: 
          TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',),
          ),
        ),

        actions: [
          ElevatedButton(

        
         style: ElevatedButton.styleFrom(
          elevation: 0,
          
          backgroundColor: Colors.grey.shade900,
          foregroundColor: Colors.red.shade900,
          disabledForegroundColor: Colors.grey,
          disabledBackgroundColor: Colors.grey.shade900
          ),
       
      onPressed: historyMangas.isEmpty?null: () {
        _showdialog();

      },
      
     
      
      child: Icon(Icons.delete_outline,size: 25,),),

        ],
      ),

     
          
      body:  Padding(
              padding: const EdgeInsets.all(12),
              child:historyMangas.isEmpty
              ?Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text('(≖_≖)',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 40
                  ),),

                    const SizedBox(height: 2,),

                    Text('Nothing read recently',style: TextStyle(color: Colors.grey,fontSize: 15,fontFamily: 'Montserrat',),)
                  ],
                ),
              )
               :ListView.builder(
                itemCount: historyMangas.length,
                itemBuilder: (context, index) {

                 
                  
                  return Padding(
                    padding: const EdgeInsets.all(8.0),

                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (_) => MangaDetails(mangaId: historyMangas[index])
                          ));
                      },
                      child: HistoryTile(manga: historyMangas[index])),
                    
                  );

                },)
            ),
          
               

              
        
    
    );
  }
}