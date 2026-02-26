// ignore: file_names
import 'package:flutter/material.dart';
import 'package:manga_zen/Pages/Customization_page.dart';
import 'package:manga_zen/widgets/Background_image.dart';

class IntroPage extends StatelessWidget {
  const IntroPage({super.key});

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        BackgroundImage(),
        Padding(
          padding: const EdgeInsets.only(bottom: 110),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

               Image.asset('assets/images/icon.png',scale: 22,),

               const SizedBox(height: 2),
               


               Text(
                textAlign: TextAlign.center,
                'Where every panel tells a story',style: TextStyle(color: Colors.grey.shade400,
                fontWeight: FontWeight.bold
                ,fontSize: 11,fontFamily: 'Montserrat'),),

                
            
           
              
               const SizedBox(height: 32,),


                 Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                       Expanded(   
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context) => CustomizationPage()));
                          },
                          child: Container(
                            
                            margin: EdgeInsets.symmetric(horizontal: 20),
                            decoration: BoxDecoration(color: Colors.red.shade500,borderRadius: BorderRadius.circular(7)),
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Start Reading',style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontFamily: 'Montserrat'),),
                                          
                                  
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              

          

            ],
          ),
        )

        
      ],),
    );
  }
}