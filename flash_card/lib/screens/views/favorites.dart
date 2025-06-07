import 'package:flash_card/app_colors.dart';
import 'package:flash_card/helper/constants/consts.dart';
import 'package:flash_card/helper/methods/capitalize_first_letter.dart';
import 'package:flash_card/provider/app_provider.dart';
import 'package:flash_card/repo/models/flash_card_model.dart';
import 'package:flash_card/screens/widgets/general/app_bar.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  bool isInverted = false;
  List<FlashCard>? listOfFavWords;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    /*     debugPrint("Screen screenWidth: $screenWidth");
    debugPrint("Screen screenWidth/2: ${screenWidth / 2}"); */

    TextTheme textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      //appBar: CustomAppBar(showBackArrowLeadingiIcon: false),
      body: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          listOfFavWords =
              appProvider.userFavoriteWords.isNotEmpty
                  ? appProvider.userFavoriteWords
                  : [];

          return listOfFavWords != null && listOfFavWords!.isNotEmpty
              ? _favoriteSceenContent(screenWidth, textTheme)
              : Center(
                child: Text(
                  "No favorite words yet!",
                  style: textTheme.bodyLarge /* TextStyle(
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    color: AppColors.greyColor.withValues(alpha: 0.8),
                  ) */,
                ),
              );
        },
      ),
    );
  }

  Widget _favoriteSceenContent(double screenWidth, TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        //Text
        Padding(
          padding: EdgeInsets.only(left: marginleft, right: marginRigth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Gallery of your favorite words",
                style: textTheme.titleMedium /* TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: AppColors.greyColor.withValues(alpha: 0.8),
                ) */,
              ),
              Text(
                "Total: (${listOfFavWords?.length ?? 0})",
                style: textTheme.titleMedium /* TextStyle(
                  fontSize: 14,
                  fontFamily: 'Poppins',
                  color: AppColors.greyColor.withValues(alpha: 0.8),
                ) */,
              ),
            ],
          ),
        ),

        //Carousel view
        /**/ SizedBox(
          height: 200,
          child: CarouselView(
            scrollDirection: Axis.horizontal,
            itemExtent: screenWidth / 2,
            itemSnapping: true,
            elevation: 7,
            shape: ShapeBorder.lerp(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: AppColors.greyColor.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                side: BorderSide(
                  color: AppColors.pinkAccent.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
              0.5,
            ),
            padding: EdgeInsets.all(8),
            children: List.generate(
              (listOfFavWords ?? []).length,
              (index) => Container(
                color: AppColors.greyColor.withValues(alpha: 0.7),
                child:
                    listOfFavWords![index].imageURL != null &&
                            listOfFavWords![index].imageURL!.isNotEmpty
                        ? Image.network(
                          listOfFavWords![index].imageURL!,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.broken_image, color: Colors.grey);
                          },
                        )
                        : Icon(Icons.image_not_supported, color: Colors.grey),
              ),
            ),
          ),
        ),

        //Divider
        const Divider(color: AppColors.greyColor, thickness: 1, height: 20),

        //Text and Icon to inverse the list
        Padding(
          padding: EdgeInsets.only(left: marginleft, right: marginRigth),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Text Info
              Text(
                "Invert the list by clicking the arrow",
                style: textTheme.bodySmall /* TextStyle(
                  fontSize: 12,
                  fontFamily: 'Poppins',
                  color: AppColors.greyColor.withValues(alpha: 0.8),
                ), */,
              ),

              //Icon
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      //debugPrint("Icon down pressed");
                      setState(() {
                        isInverted = !isInverted;
                      });
                    },
                    icon:
                        isInverted == true
                            ? Icon(
                              Icons.keyboard_arrow_up,
                              color: AppColors.textInBlack,
                            )
                            : Icon(
                              Icons.keyboard_arrow_down,
                              color: AppColors.greyColor,
                            ),
                  ),
                ],
              ),
            ],
          ),
        ),

        //ListView
        Expanded(
          child: Align(
            alignment: Alignment.topCenter,
            child: ListView.builder(
              itemCount: listOfFavWords!.length,
              physics: const BouncingScrollPhysics(),
              reverse: isInverted,
              shrinkWrap: true,
              padding: EdgeInsets.zero, // Remove any default padding
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 3,
                  ),
                  child: Container(
                    height: 100,
                    width: double.infinity,
                    //color: AppColors.greyColor.withValues(alpha: 0.7),
                    decoration: BoxDecoration(
                      color: AppColors.greyColor.withValues(alpha: 0.3),
                      borderRadius: BorderRadius.circular(10),
                      /* boxShadow: [
                        BoxShadow(
                          color: AppColors.greyColor.withValues(alpha: 0.5),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ], */
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                        left: marginleft,
                        top: 3,
                        bottom: 3,
                        //right: 3,
                      ), //Left = marginleft = 16, i have to add 16 to the (20) from (MediaQuery.of(context).size.width * 0.75 - 20)
                      child: Row(
                        children: [
                          //Image on the left
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.25,
                            child: Container(
                              height: 100,
                              //width: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: AppColors.greyColor.withValues(
                                  alpha: 0.7,
                                ),
                              ),
                              clipBehavior: Clip.hardEdge,
                              child: Image.network(
                                listOfFavWords![index].imageURL!,
                                fit: BoxFit.cover,
                                /* width: 100,
                                height: 100, */
                              ),
                            ),
                          ),

                          SizedBox(
                            width: 17,
                          ), // Here (That is why i am using 20)
                          // (size.width* 0.75) - (17+16+10) = 43 ( + 10 = 53 bc it was given an error about 10 pixels size of the container )
                          //Column with Title and Subtitle
                          SizedBox(
                            width:
                                MediaQuery.of(context).size.width * 0.75 - 53,
                            child: Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    capitalizeFirstLetter(
                                      listOfFavWords![index].word,
                                    ),
                                    style:
                                        textTheme
                                            .headlineSmall /* const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: AppColors.textInBlack,
                                      fontSize: 16,
                                    ) */,
                                  ),
                                  Text(
                                    capitalizeFirstLetter(
                                      listOfFavWords![index].definition!.first,
                                    ),
                                    style:
                                        textTheme.labelLarge /* const TextStyle(
                                      fontFamily: 'Poppins',
                                      color: AppColors.textInBlack,
                                      fontSize: 12,
                                    ) */,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  /*
  TO get ramdom images
  https://picsum.photos/400?random=$index
 */
}
