import 'package:flash_card/app_colors.dart';
import 'package:flash_card/provider/app_provider.dart';
import 'package:flash_card/repo/models/flash_card_model.dart';
import 'package:flash_card/screens/views/favorites.dart';
import 'package:flash_card/screens/views/home_screen.dart';
import 'package:flash_card/screens/views/settings.dart';
import 'package:flash_card/screens/widgets/home/add_new_word.dart';
import 'package:flash_card/screens/widgets/home/custom_navigation_nar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PageIndex extends StatefulWidget {
  const PageIndex({super.key});

  @override
  State<PageIndex> createState() => _PageIndexState();
}

class _PageIndexState extends State<PageIndex> {
  AppProvider? appProvider;

  int _selectedIndex = 0;
  //List<FlashCard> listOfWOrds = [];

  void _onTabSelected(int index) {
    debugPrint("Selected index: $index");
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) async {
      _fetchData(context);
      //_showMediaQuery();
    });
  }

  //Just learning how MediaQuery works
  void _showMediaQuery() {
    /*final mediaQuery = MediaQuery.of(context);
       debugPrint("MediaQuery height... : ${mediaQuery.size.height}");
    debugPrint("MediaQuery width... : ${mediaQuery.size.width}");
    debugPrint("MediaQuery orientation... : ${mediaQuery.orientation}");
    debugPrint(
      "MediaQuery viewInsets.bottom... : ${mediaQuery.viewInsets.bottom}",
    );
    debugPrint(
      "MediaQuery padding top and bottom... : ${mediaQuery.padding.top} ${mediaQuery.padding.bottom}",
    );
    debugPrint(
      "MediaQuery padding left and right... : ${mediaQuery.padding.left} ${mediaQuery.padding.right}",
    );
    debugPrint(
      "MediaQuery devicePixelRatio	... : ${mediaQuery.devicePixelRatio}",
    );
    debugPrint("MediaQuery textScaler	... : ${mediaQuery.textScaler}"); */
  }

  Future<void> _fetchData(BuildContext context) async {
    await Provider.of<AppProvider>(context, listen: false).fetchListOfWords();
    debugPrint("Data fetched successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorWhite,
      body: FutureBuilder(
        future: _fetchData(context),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            return Consumer<AppProvider>(
              builder: (context, appProvider, child) {
                List<FlashCard> listOfWords = appProvider.listOfWords;
                List<FlashCard> reversedList = listOfWords.reversed.toList();
                return _safArea(reversedList);
              },
            );
          }
        },
      ),
      extendBody: true,
      floatingActionButton: AddNewWord(),
      bottomNavigationBar: CustomNavigationBar(
        onTabSelected: _onTabSelected,
        selectedIndex: _selectedIndex,
      ),
    );
  }

  SafeArea _safArea(List<FlashCard> listOfWords) {
    return SafeArea(
      child: IndexedStack(
        index: _selectedIndex,
        children: [
          listOfWords.isNotEmpty ? HomeScreen() : _noCadsAvialableContainer(),
          FavoritesScreen(),
          SettingsScreen(),
        ],
      ),
    );
  }

  // This is the container that will be shown when there are no flash cards available
  Center _noCadsAvialableContainer() {
    return Center(
      child: Text(
        'No flash card available',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w500,
          fontFamily: 'Poppins',
          color: AppColors.greyColor.withValues(alpha: 0.8),
        ),
      ),
    );
  }
}
