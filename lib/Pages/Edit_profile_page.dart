import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:manga_zen/Manga/Manga.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late Box userBox;

  late int selectedAvatar = -1;

  late TextEditingController usernameController;

  @override
  void initState() {
    super.initState();

    userBox = Hive.box('Profile');

    usernameController = TextEditingController();

    usernameController.text = userBox.get('username', defaultValue: '');

    selectedAvatar = userBox.get('pfpIndex', defaultValue: -1);
  }

  @override
  void dispose() {
    usernameController.dispose();
    super.dispose();
  }

  Future<void> saveProfile() async {
    await userBox.put('username', usernameController.text);

    await userBox.put('pfpIndex', selectedAvatar);
  }

  @override
  Widget build(BuildContext context) {
    final isLandsape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return isLandsape
        ? Scaffold(
            backgroundColor: const Color.fromARGB(255, 27, 27, 27),
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () {
                      if (usernameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text('PLease enter a username')],
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.black12,
                            duration: Duration(milliseconds: 700),
                          ),
                        );
                        return;
                      }

                      saveProfile();

                      Navigator.pop(context);
                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ],
              backgroundColor: Colors.grey.shade900,
              foregroundColor: Colors.white,
              title: Text(
                'Profile Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),

            body: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: const SizedBox(height: 50)),

                SliverToBoxAdapter(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(0),
                            child: CircleAvatar(
                              backgroundColor: Colors.grey.shade100,
                              radius: 60,
                              backgroundImage: selectedAvatar == -1
                                  ? null
                                  : AssetImage(
                                      AvatarData.avatars[selectedAvatar],
                                    ),
                              child: selectedAvatar == -1
                                  ? Icon(
                                      Icons.person,
                                      color: Colors.grey,
                                      size: 90,
                                    )
                                  : null,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Set a username',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextFormField(
                      cursorColor: Colors.white,
                      controller: usernameController,
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Montserrat',
                      ),
                      maxLength: 30,

                      decoration: InputDecoration(
                        counterStyle: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                        filled: true,
                        fillColor: Colors.grey.shade700,
                        labelStyle: const TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),

                        focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(
                            color: Colors.white70,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                ),

                SliverToBoxAdapter(child: SizedBox(height: 35)),

                SliverToBoxAdapter(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Text(
                            'Choose your profile icon',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              fontFamily: 'Montserrat',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 200,

                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      child: GridView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: AvatarData.avatars.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 10,
                          mainAxisSpacing: 14,
                          crossAxisSpacing: 14,
                          childAspectRatio: 1,
                        ),

                        itemBuilder: (context, index) {
                          return Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedAvatar = index;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(3),
                                child: CircleAvatar(
                                  backgroundImage: AssetImage(
                                    AvatarData.avatars[index],
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            backgroundColor: const Color.fromARGB(255, 27, 27, 27),
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: GestureDetector(
                    onTap: () {
                      if (usernameController.text.trim().isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [Text('PLease enter a username')],
                            ),
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: Colors.black12,
                            duration: Duration(milliseconds: 700),
                          ),
                        );
                        return;
                      }

                      saveProfile();

                      Navigator.pop(context);
                    },
                    child: Text(
                      'SAVE',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                ),
              ],
              backgroundColor: Colors.grey.shade900,
              foregroundColor: Colors.white,
              title: Text(
                'Profile Settings',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Montserrat',
                ),
              ),
            ),

            body: Column(
              children: [
                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    backgroundColor: Colors.grey.shade100,
                    radius: 60,
                    backgroundImage: selectedAvatar == -1
                        ? null
                        : AssetImage(AvatarData.avatars[selectedAvatar]),
                    child: selectedAvatar == -1
                        ? Icon(Icons.person, color: Colors.grey, size: 90)
                        : null,
                  ),
                ),

                const SizedBox(height: 20),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Set a username',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    controller: usernameController,
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Montserrat',
                    ),

                    maxLength: 30,

                    decoration: InputDecoration(
                      counterStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.grey.shade700,
                      labelStyle: const TextStyle(color: Colors.white),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(5),
                      ),

                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.white70,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 35),

                Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(15),
                        child: Text(
                          'Choose your profile icon',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: GridView.builder(
                      itemCount: AvatarData.avatars.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 5,
                        mainAxisSpacing: 14,
                        crossAxisSpacing: 14,
                        childAspectRatio: 1,
                      ),

                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedAvatar = index;
                              });
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(3),
                              child: CircleAvatar(
                                backgroundImage: AssetImage(
                                  AvatarData.avatars[index],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          );
  }
}
