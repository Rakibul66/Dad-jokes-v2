import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_colors.dart';
import '../constants.dart';
import '../controller/joke_controller.dart';
import 'favorite_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final JokeController jokeController = Get.put(JokeController());


  // Function to copy punchline text to clipboard
  Future<void> copyPunchlineToClipboard(String punchline) async {
    await Clipboard.setData(ClipboardData(text: punchline));
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('Joke copied to clipboard!'),
      ),
    );
  }

  // Function to add joke to favorites list
  Future<void> addToFavorites(String joke) async {
    final prefs = await SharedPreferences.getInstance();
    final favoriteJokes = prefs.getStringList('favoriteJokes') ?? [];

    favoriteJokes.add(joke);

    await prefs.setStringList('favoriteJokes', favoriteJokes);

    ScaffoldMessenger.of(Get.context!).showSnackBar(
      const SnackBar(
        content: Text('Joke added to favorites!'),
      ),
    );
  }



  @override
  void initState() {
    super.initState();
   
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return bannerAdsUnitId;
    } else if (Platform.isIOS) {
      return bannerAdsUnitId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }




  @override
  void dispose() {
    super.dispose();
 
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return Scaffold(
      extendBodyBehindAppBar: true, // Extend body behind the app bar
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent app bar
        elevation: 0, // No shadow

      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg.png'), // Background image
                fit: BoxFit.cover,
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 16.w),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20.h),
                      Image.asset(
                        'assets/dadjokes.png',
                        width: 150.w,
                        height: 50.h,
                      ), // Dad Jokes image
                      SizedBox(height: 24.h),
                      Card(
                        color: colorCard,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 5,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.all(16.sp),
                          child: Column(
                            children: [
                              Obx(() {
                                return Text(
                                  jokeController.joke.value.joke,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: Colors.white,
                                  ),
                                  textAlign: TextAlign.center,
                                );
                              }),
                              SizedBox(height: 10.h),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.copy),
                                    onPressed: () =>
                                        copyPunchlineToClipboard(
                                          jokeController.joke.value.joke,
                                        ),
                                    color: Colors.white,
                                  ),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.favorite_outline,
                                      color: colorWhite,
                                    ),
                                    onPressed: () {
                                      addToFavorites(
                                        jokeController.joke.value.joke,
                                      );
                                    },
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Material(
                        color: colorGreen,
                        borderRadius: BorderRadius.circular(50.r),
                        elevation: 4.0,
                        child: InkWell(
                          onTap: () {
                            jokeController.showRandomJoke();
                          },
                          child: Container(
                            height: 55.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorButtonGradientStart1,
                                  colorButtonGradientEnd1,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Center(
                              child: Text(
                                "Next Joke",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: 16.h),
                      InkWell(
                        onTap: () {
                        
                          Get.to(
                            const FavoriteListScreen(),
                            transition: Transition.fade, // Set transition animation
                            duration: const Duration(milliseconds: 500), // Set animation duration
                            curve: Curves.easeInOut, // Set animation curve
                          );
                        },
                        splashColor: Colors.transparent,
                        child: Material(
                          color: colorGreen,
                          borderRadius: BorderRadius.circular(50.r),
                          elevation: 4.0,
                          child: Container(
                            height: 55.h,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  colorButtonGradientStart2,
                                  colorButtonGradientEnd2,
                                ],
                              ),
                              borderRadius: BorderRadius.circular(50.r),
                            ),
                            child: Center(
                              child: Text(
                                "Favorite List",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),


                    ],
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
