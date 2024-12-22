import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../app_colors.dart';
import '../constants.dart';

class FavoriteListScreen extends StatefulWidget {
  const FavoriteListScreen({Key? key}) : super(key: key);

  @override
  _FavoriteListScreenState createState() => _FavoriteListScreenState();
}

class _FavoriteListScreenState extends State<FavoriteListScreen> {
  List<String> favoriteJokes = [];

 

  @override
  void initState() {
    super.initState();
    loadFavoriteJokes();
   
  }

  // Function to load favorite jokes from shared preferences
  Future<void> loadFavoriteJokes() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteJokes = prefs.getStringList('favoriteJokes') ?? [];
    });
  }

  // Function to remove a joke from favorites
  Future<void> removeFavorite(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      favoriteJokes.removeAt(index);
      prefs.setStringList('favoriteJokes', favoriteJokes);
    });
  }

  
  @override
  void dispose() {
  
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        systemOverlayStyle: SystemUiOverlayStyle.light,
        flexibleSpace: Container(
          color: colorCard, // Set a fixed color here
        ),
        titleSpacing: -1,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(
            Icons.arrow_back,
            color: colorWhite,
          ),
        ),
        title: Text(
          "Favorite Jokes",
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: colorWhite,
          ),
        ),
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg.png'), // Background image
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 2.h),
          
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: ListView.builder(
                  itemCount: favoriteJokes.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      key: Key(favoriteJokes[index]), // Unique key for each item
                      direction: DismissDirection.horizontal,
                      background: Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(left: 20.0),
                        color: Colors.green,
                        child: const Icon(Icons.edit, color: Colors.white),
                      ),
                      secondaryBackground: Container(
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.only(right: 20.0),
                        color: Colors.red,
                        child: const Icon(Icons.delete, color: Colors.white),
                      ),
                      confirmDismiss: (direction) async {
                        if (direction == DismissDirection.endToStart) {
                          // User swiped to delete
                          return await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Confirm"),
                                content: const Text(
                                    "Are you sure you want to delete this joke?"),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.of(context).pop(false),
                                    child: const Text("CANCEL"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text("DELETE"),
                                  ),
                                ],
                              );
                            },
                          );
                        }
                        // Other directions are allowed to dismiss
                        return true;
                      },
                      onDismissed: (direction) {
                        setState(() {
                          favoriteJokes.removeAt(index);
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setStringList('favoriteJokes', favoriteJokes);
                          });
                        });
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Joke removed from favorites.'),
                            action: SnackBarAction(
                              label: 'UNDO',
                              onPressed: () {
                                // Add the item back
                                setState(() {
                                  favoriteJokes.insert(index, favoriteJokes[index]);
                                  SharedPreferences.getInstance().then((prefs) {
                                    prefs.setStringList('favoriteJokes', favoriteJokes);
                                  });
                                });
                              },
                            ),
                          ),
                        );
                      },
                      child: Card(
                        color: colorCard,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                        child: Padding(
                          padding: EdgeInsets.all(16.sp),
                          child: Text(
                            favoriteJokes[index],
                            style: TextStyle(
                              fontSize: 16.sp,
                              color: colorWhite,
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
      ),
    );
  }
}
