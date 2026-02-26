
class Manga {
   final String id;
   final String title;
   final String image;
   final String rank;
   final String view;
   final List<Chapter>?chapters;
   final bool isTop;
   final String mangaka;
   final String status;
   Manga({
    required this.id,
    required this.image,
    required this.title,
    required this.rank,
    required this.view,
    required this.chapters,
    required this.isTop,
    required this.mangaka,
    required this.status
    
   });

  List<Chapter> get safeChapters => chapters ?? [];

}

class Chapter{
  final String id;
  final String chapterTitle;
  final String thumbnail;
  final String number;

  Chapter({
    required this.chapterTitle,
    required this.thumbnail,
    required this.number,
    required this.id,
    
   });


}

class AvatarData{
  static const List<String> avatars=[

    'assets/profile_pictures/1.jpg',
    'assets/profile_pictures/2.jpg',
    'assets/profile_pictures/3.jpg',
    'assets/profile_pictures/4.jpg',
    'assets/profile_pictures/5.jpg',
    'assets/profile_pictures/6.jpg',
    'assets/profile_pictures/7.jpg',
    'assets/profile_pictures/8.jpg',
    'assets/profile_pictures/9.jpg',
    'assets/profile_pictures/10.png',
    'assets/profile_pictures/11.jpg',
    'assets/profile_pictures/12.jpg',
    'assets/profile_pictures/13.jpg',
    'assets/profile_pictures/14.jpg',
    'assets/profile_pictures/15.jpg',
    'assets/profile_pictures/16.png',
    'assets/profile_pictures/17.jpg',
    'assets/profile_pictures/18.jpg',
    'assets/profile_pictures/19.jpg',
    'assets/profile_pictures/20.jpg',




   
  ];
}

