import 'package:flash_card/app_colors.dart';
import 'package:flash_card/helper/methods/capitalize_first_letter.dart';
import 'package:flash_card/repo/fetch.dart';
import 'package:flash_card/repo/models/flash_card_model.dart';
import 'package:flash_card/screens/widgets/home/audio_player_widget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomSheet extends StatefulWidget {
  final FlashCard flashCard;
  final Size screenSize;
  final bool isExpanded;
  final bool pageHasChanged;

  const CustomBottomSheet({
    super.key,
    required this.flashCard,
    required this.screenSize,
    required this.isExpanded,
    required this.pageHasChanged,
  });

  @override
  State<CustomBottomSheet> createState() => _CustomBottomSheetState();
}

class _CustomBottomSheetState extends State<CustomBottomSheet> {
  bool isExpanded = false;
  bool isPressed = false;
  String? textTranslated;

  @override
  void initState() {
    super.initState();
    //setState(() => isExpanded = widget.isExpanded);
    //debugPrint("What is wrong with the audio: ${widget.flashCard.audio}");
  }

  @override
  void didUpdateWidget(CustomBottomSheet oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.isExpanded != oldWidget.isExpanded) {
      setState(() {
        isExpanded = widget.isExpanded;
      });
    }

    // Reset translation when the flash card changes
    if (widget.flashCard != oldWidget.flashCard) {
      setState(() {
        textTranslated = null;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //Pronunciation Audio
          widget.flashCard.audio?.isEmpty ?? true
              ? Container()
              : Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  AudioPlayerWidget(
                    audioUrl: widget.flashCard.audio!,
                    isExpanded: isExpanded,
                  ),
                ],
              ),

          //Example text
          widget.flashCard.definition?.isEmpty ?? true
              ? Container()
              : _exampleText(textTheme),

          // Space
          SizedBox(height: 10),

          //Translate the text section
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              GestureDetector(
                onTapDown: (_) async {
                  setState(() => isPressed = true);

                  //Show a loading indicator
                  showDialog(
                    context: context,
                    builder:
                        (context) =>
                            const Center(child: CircularProgressIndicator()),
                  );

                  // Get the user's country and language
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  final userPreferredLanguage = prefs.getString(
                    'preferredUserLanguage', //preferredUserLanguage //language
                  );

                  debugPrint(
                    "Text to translate -: ${widget.flashCard.definition!.first}",
                  );

                  // Translate the text
                  if (userPreferredLanguage != null) {
                    //Translate the text
                    final result = await translateText(
                      widget.flashCard.definition!.first,
                      'en',
                      userPreferredLanguage,
                    );

                    debugPrint("Result from translateText -: $result");

                    //Close the loading indicator
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }

                    debugPrint("Result -: $result");

                    if (result['status'] == 'success') {
                      final translatedText = result['data']['translatedText'];
                      debugPrint("Translated Text -: $translatedText");
                      setState(() => textTranslated = translatedText);
                    }
                  } else {
                    debugPrint(
                      "User preferred language is NOT set. So get the user language",
                    );

                    //Get the user language
                    final userCountryAndLanguage = prefs.getString('language');
                    debugPrint(
                      "User countr's language -: $userCountryAndLanguage",
                    );

                    debugPrint(
                      "User country and language -: $userCountryAndLanguage",
                    );

                    //CONT LATER
                  }
                },
                onTapUp: (_) => setState(() => isPressed = false),
                onTapCancel: () => setState(() => isPressed = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 100),
                  transform: Matrix4.identity()..scale(isPressed ? 1.1 : 1.0),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "Tap to translate",
                      style:
                          Theme.of(context).brightness == Brightness.dark
                              ? textTheme.labelMedium
                              : textTheme.titleSmall /* TextStyle(
                        fontSize: 10,
                        color: isPressed ? Colors.blue : Colors.black,
                      ), */,
                    ),
                  ),
                ),
              ),
            ],
          ),

          //Spacing
          SizedBox(height: 10),

          //Synonyms text
          widget.flashCard.synonyms?.isEmpty ?? true
              ? Container()
              : Text(
                "Synonyms",
                style: textTheme.labelLarge /* TextStyle(
                  fontSize: 12,
                  color:
                      isExpanded
                          ? AppColors.textColorWhenIsEpanded
                          : AppColors.textColorWhenNotExpanded,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ), */,
              ),
          _synonymsORStems(widget.flashCard.synonyms!, textTheme),

          //Antonyms text
          widget.flashCard.antonyms?.isEmpty ?? true
              ? Container()
              : Text(
                "Antonyms",
                style: textTheme.labelLarge /* TextStyle(
                  fontSize: 12,
                  color:
                      isExpanded
                          ? AppColors.textColorWhenIsEpanded
                          : AppColors.textColorWhenNotExpanded,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ), */,
              ),
          widget.flashCard.antonyms?.isEmpty ?? true
              ? Container()
              : _synonymsORStems(widget.flashCard.antonyms!, textTheme),

          //Spacing
          SizedBox(height: 10),

          //Stems text
          widget.flashCard.stems?.isEmpty ?? true
              ? Container()
              : Text(
                "Root of the word",
                style: textTheme.labelLarge /* TextStyle(
                  fontSize: 12,
                  color:
                      isExpanded
                          ? AppColors.textColorWhenIsEpanded
                          : AppColors.textColorWhenNotExpanded,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Poppins',
                ), */,
              ),
          widget.flashCard.stems?.isEmpty ?? true
              ? Container()
              : _synonymsORStems(widget.flashCard.stems!, textTheme),

          //Spacing
          SizedBox(height: 10),
        ],
      ),
    );
  }

  //Example text
  Column _exampleText(TextTheme textTheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Example",
          style: textTheme.labelLarge /* TextStyle(
            fontSize: 12,
            color:
                isExpanded
                    ? AppColors.textColorWhenIsEpanded
                    : AppColors.textColorWhenNotExpanded,
            fontWeight: FontWeight.w500,
            fontFamily: 'Poppins',
          ), */,
        ),
        //Spacing
        SizedBox(height: 10),

        //Example text
        Text(
          textTranslated != null
              ? capitalizeFirstLetter(textTranslated)
              : capitalizeFirstLetter(widget.flashCard.definition!.first),
          style: textTheme.titleMedium /* TextStyle(
            fontSize: 14,
            color:
                isExpanded
                    ? AppColors.textInBlack
                    : AppColors.textColorWhenNotExpanded,
            fontWeight: FontWeight.w500,
            fontFamily: "Poppins",
          ), */,
        ),
      ],
    );
  }

  //Synonyms text
  SizedBox _synonymsORStems(List<String> synonymsORStems, TextTheme textTheme) {
    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: synonymsORStems.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Text(
                    synonymsORStems[index],
                    textAlign: TextAlign.center,
                    style:
                        widget.isExpanded
                            ? textTheme.labelMedium
                            : textTheme.labelLarge,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
