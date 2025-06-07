import 'package:flash_card/app_colors.dart';
import 'package:flash_card/helper/constants/consts.dart';

import 'package:flash_card/provider/app_provider.dart';
import 'package:flash_card/repo/fetch.dart';
import 'package:flash_card/repo/models/flash_card_model.dart';
import 'package:flash_card/screens/widgets/home/audio_player_widget.dart';
import 'package:flash_card/screens/widgets/home/bottom_sheet.dart';
import 'package:flash_card/screens/widgets/home/flip_card_container.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  //final List<FlashCard> listOfWords;
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<HomeScreen> {
  //List<FlashCard>? myListOfWords;
  List<FlashCard>? listOfWords;
  List<FlashCard>? reversedListOfWords;
  PageController _pageController = PageController();
  int _currentIndex = 0;
  FlashCard? flashCard;
  String? audioUrl;
  bool isExpanded = false;
  late SharedPreferences? prefs;
  bool pageHasChanged = false;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  //Next page
  void _nextPage() {
    debugPrint("Going to the next page");
    if (reversedListOfWords != null &&
        _currentIndex < reversedListOfWords!.length - 1) {
      _currentIndex++;
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  //Previous page
  void _previousPage() {
    debugPrint("Going to the previous page");
    if (reversedListOfWords != null && _currentIndex > 0) {
      _currentIndex--;
      _pageController.animateToPage(
        _currentIndex,
        duration: Duration(milliseconds: 300),
        curve: Curves.easeIn,
      );
    }
  }

  //Show audio player
  Widget showAudioPlayer() {
    if (flashCard?.audio != null && flashCard!.audio!.isNotEmpty) {
      debugPrint("FlashCard audio in showAudioPlayer: ${flashCard?.audio}");
      return AudioPlayerWidget(
        audioUrl: flashCard!.audio!,
        isExpanded: isExpanded,
      );
    }
    return SizedBox.shrink(); // If no audio, return an empty widget
  }

  //Update flashCard with the current card
  void updateFlashCardWithCurrentCard(int index) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        flashCard = reversedListOfWords![index]; // Update flashCard
      });
    });
  }

  //Toggle event to show more details
  void _toggleEvent(bool isUp) {
    debugPrint("Toggling event: $isUp");
    setState(() {
      isExpanded = isUp;
    });
  }

  //No longer in used (was for testing)
  Future<void> _displayUserLocation() async {
    //final position = await getLocationUserData();
    //debugPrint("User location: $position");

    prefs = await SharedPreferences.getInstance();
    final language = prefs?.getString("preferredUserLanguage");
    debugPrint("Language: $language");
    if (language != null && language.isNotEmpty) {
      translateText("Hello buddy, what is up?", "en", language);
    } else {
      debugPrint("No language found");
    }
  }

  @override
  Widget build(BuildContext context) {
    //Get the size of the screen
    final screenSize = MediaQuery.of(context).size;

    //Get the Text Theme
    TextTheme textTheme = Theme.of(context).textTheme;
    /*  TextTheme textTheme = Theme.of(context).textTheme.copyWith(
      bodyLarge: TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        fontFamily: 'Poppins',
        color: AppColors.textInBlack, //Theme.of(context).colorScheme.primary,
      ),
      bodySmall: TextStyle(
        fontSize: 12,
        fontFamily: 'Poppins',
        color: Colors.grey,
      ),
    ); */

    return Consumer<AppProvider>(
      builder: (context, appProvider, child) {
        listOfWords = appProvider.listOfWords;
        reversedListOfWords = listOfWords?.reversed.toList();
        bool hasWords = listOfWords?.isNotEmpty ?? false;

        return Scaffold(
          backgroundColor:
              isExpanded && Theme.of(context).brightness == Brightness.dark
                  ? Colors.black
                  : Theme.of(context).colorScheme.background,
          body: Stack(
            children: [
              //HomeContent
              _homeContent(screenSize, hasWords, textTheme),

              //Show more details (bottom sheet)
              if (flashCard != null)
                bottomSheetAnimatedContainer(screenSize, textTheme),
            ],
          ),
        );
      },
    );
  }

  //Home content
  Widget _homeContent(Size screenSize, bool hasWords, TextTheme textTheme) {
    return Padding(
      padding: EdgeInsets.all(allMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,

        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //Save the flash card component,
          if (hasWords)
            Center(
              child: Column(
                children: [
                  Text(
                    'Tap to flip the card',
                    style: textTheme.bodyLarge /* TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Poppins',
                      color: Theme.of(context).colorScheme.primary,
                    ), */,
                  ),
                  Text(
                    'Or swipe left to see the next card',
                    style: textTheme.bodySmall /* TextStyle(
                      fontSize: 12,
                      fontFamily: 'Poppins',
                      color: Colors.grey,
                    ), */,
                  ),
                ],
              ),
            ),

          //Spacing
          SizedBox(height: 5),

          //Flip card component
          hasWords
              ? SizedBox(
                height: MediaQuery.of(context).size.height * 0.5,
                child: PageView.builder(
                  itemCount: reversedListOfWords!.length,
                  controller: _pageController,
                  onPageChanged: (index) {
                    setState(() {
                      _currentIndex = index;
                      flashCard = reversedListOfWords![index];
                      pageHasChanged = true;
                      // Reset pageHasChanged after a short delay
                      Future.delayed(Duration(milliseconds: 100), () {
                        if (mounted) {
                          setState(() {
                            pageHasChanged = false;
                          });
                        }
                      });
                    });
                  },
                  itemBuilder: (context, index) {
                    final currentCard = reversedListOfWords![index];

                    //To Update flashCard with the current card
                    updateFlashCardWithCurrentCard(index);

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child:
                          isExpanded == true
                              ? Container()
                              : FlipCardContainer(flashCard: currentCard),
                    );
                  },
                ),
              )
              : Center(
                child: Text(
                  'No flash card available',
                  style: textTheme.bodyLarge,
                ),
              ),
        ],
      ),
    );
  }

  //Bottom sheet animated container (below the page view)
  AnimatedPositioned bottomSheetAnimatedContainer(
    Size screenSize,
    TextTheme textTheme,
  ) {
    return AnimatedPositioned(
      duration: Duration(milliseconds: 300),
      left: 0,
      right: 0,
      bottom: isExpanded ? 0 : -(screenSize.height * 0.50),
      curve: Curves.easeInOut,
      child: GestureDetector(
        onVerticalDragUpdate: (details) {
          if (details.primaryDelta! < -10) {
            _toggleEvent(true);
          } else if (details.primaryDelta! > 10) {
            _toggleEvent(false);
          }
        },
        child: Container(
          height: screenSize.height * 0.8,
          decoration: BoxDecoration(
            color: AppColors.blueColor.withValues(alpha: 0.5),
            /*  
                isExpanded
                    ? AppColors.backgroundColorWhite
                    : AppColors.blueColor.withValues(alpha: 0.5), */

            //AppColors.backgroundColorWhite, //AppColors.blueColor.withValues(alpha: 0.5),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            children: [
              Center(
                child: IconButton(
                  onPressed: () => _toggleEvent(!isExpanded),
                  icon: Icon(
                    isExpanded
                        ? Icons.keyboard_arrow_down
                        : Icons.keyboard_arrow_up,
                    color:
                        Theme.of(
                          context,
                        ).iconButtonTheme.style?.foregroundColor?.resolve({}) ??
                        Colors.grey,
                  ),
                ),
              ),
              Center(
                child: Text(
                  "More Details",
                  style: textTheme.headlineSmall /* TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Poppins',
                  ), */,
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(allMargin),
                  child: CustomBottomSheet(
                    flashCard: flashCard!,
                    screenSize: screenSize,
                    isExpanded: isExpanded,
                    pageHasChanged: pageHasChanged,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
