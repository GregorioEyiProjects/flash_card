import 'package:flash_card/helper/methods/capitalize_first_letter.dart';
import 'package:flash_card/provider/app_provider.dart';
import 'package:flash_card/repo/models/flash_card_model.dart';
import 'package:flash_card/screens/widgets/dialogs/show_loading_dialog.dart';
import 'package:flash_card/screens/widgets/home/favoriteIcom.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flip_card/flutter_flip_card.dart';
import 'package:provider/provider.dart';

class FlipCardContainer extends StatefulWidget {
  final FlashCard flashCard;
  const FlipCardContainer({super.key, required this.flashCard});

  @override
  State<FlipCardContainer> createState() => _FlipCardContainerState();
}

class _FlipCardContainerState extends State<FlipCardContainer> {
  bool isFlipped = false;

  @override
  void didUpdateWidget(covariant FlipCardContainer oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    final controller = FlipCardController();
    bool isSaveButtonPressed = false;
    TextTheme textTheme = Theme.of(context).textTheme;

    final appProvider = Provider.of<AppProvider>(context, listen: false);

    return FlipCard(
      rotateSide: RotateSide.left,
      controller: controller,
      animationDuration: const Duration(milliseconds: 500),
      axis: FlipAxis.vertical,
      onTapFlipping: !isSaveButtonPressed,

      frontWidget: _fontWidget(appProvider, textTheme, () async {
        debugPrint("OnTAP save pressed");

        //Set this " isSaveButtonPressed " to true to avoid flipping the card
        setState(() {
          isSaveButtonPressed = true;
        });

        //Set this " isSaveButtonPressed " to false to allow flipping the card
        Future.delayed(const Duration(milliseconds: 300), () {
          setState(() {
            isSaveButtonPressed = false;
          });
        });

        //END of the callBack
      }),
      backWidget: _backWidget(textTheme),
    );
  }

  //For the front widget
  Container _fontWidget(
    AppProvider appProvider,
    TextTheme textTheme,
    VoidCallback onSavePressed,
  ) {
    return Container(
      //height: 350,
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color, //Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          //Like
          //Save the flash card component,
          GestureDetector(
            onTap: onSavePressed,
            child: CustomFavIcon(
              isFavorite: widget.flashCard.isFavorite,
              onPressed: () async {
                //Show a loading indicator
                customLoadingIconDialog(
                  context,
                  "Updating...",
                  "Saving the word as fave",
                );

                // debugPrint("OnPRESS  save pressed");
                /*  debugPrint(
                  "What is it before saving it ? ${widget.flashCard.isFavorite}",
                ); */

                //Get the FlashCard
                FlashCard flashCard = FlashCard(
                  id: widget.flashCard.id,
                  word: widget.flashCard.word,
                  imageURL: widget.flashCard.imageURL,
                  audio: widget.flashCard.audio,
                  definition: widget.flashCard.definition,
                  synonyms: widget.flashCard.synonyms,
                  stems: widget.flashCard.stems,
                  isFavorite: widget.flashCard.isFavorite,
                  isLearned: false,
                );

                //save the flash card to the favorites
                final Map<String, dynamic> response = await appProvider
                    .updateWord(flashCard);

                //Dismiss the loading dialog after the operation
                if (context.mounted) {
                  Navigator.of(context).pop();
                }

                if (response['status'] == "success") {
                  debugPrint("Status was 'success'  ... ");

                  if (response['message'] ==
                      'Word removed from the favorites') {
                    debugPrint("Word removed from the favorites ... ");
                    //Show the snackbar
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Word remove from favorites!"),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  } else if (response['message'] == 'Word saved as favorite') {
                    //Show the snackbar
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text("Saved to favorites!"),
                          duration: const Duration(seconds: 3),
                        ),
                      );
                    }
                  }
                } else {
                  debugPrint("Status was NOT 'success'  ... ");

                  //Show the snackbar
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Error: $response"),
                        duration: const Duration(seconds: 5),
                      ),
                    );
                  }
                }
              },
            ),
          ),
          //Spacing
          SizedBox(height: 10),
          Center(
            child: SizedBox(
              height: 250,
              width: 200,
              child: Image.network(
                widget.flashCard.imageURL!,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),
          //Text
          Text(
            capitalizeFirstLetter(widget.flashCard.word),
            style: textTheme.titleLarge /*TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: 'Poppins',
            ),  */,
          ),
          //Spacing
          SizedBox(height: 20),
        ],
      ),
    );
  }

  //For the back widget
  Container _backWidget(TextTheme textTheme) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color, //Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: SingleChildScrollView(
        child: Column(
          //crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Spacing
            SizedBox(height: 10),

            //Word
            Text(
              capitalizeFirstLetter(widget.flashCard.word),
              style: textTheme.titleLarge,
            ),

            //Spacing
            SizedBox(height: 5),
            Divider(),
            SizedBox(height: 5),

            //The example of the word
            Text(
              "Example",
              style: textTheme.headlineSmall /* TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ), */,
            ),
            //Spacing
            //Spacing
            SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Text(
                widget.flashCard.definition == null ||
                        widget.flashCard.definition!.isEmpty
                    ? "No definition found"
                    : capitalizeFirstLetter(widget.flashCard.definition![0]),
                style: textTheme.titleMedium /* TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Poppins',
                ) */,
              ),
            ),
            //Spacing
            SizedBox(height: 20),

            //Synonyms for the word
            widget.flashCard.synonyms == null ||
                    widget.flashCard.synonyms!.isEmpty
                ? Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [],
                )
                : Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    //Synonyms for the word
                    Text(
                      "Synonyms",
                      style: textTheme.headlineSmall /* TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ), */,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: _synonymsOrStems("Synonyms", textTheme),
                    ),
                    //Spacing
                    SizedBox(height: 10),
                  ],
                ),

            //Root of the word or STEMS
            widget.flashCard.stems == null || widget.flashCard.stems!.isEmpty
                ? Column(children: [
                    
                  ],
                )
                : Padding(
                  padding: const EdgeInsets.only(left: 15, right: 15),
                  child: Column(
                    children: [
                      Text(
                        "Root of the word",
                        style: textTheme.headlineSmall /* TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Poppins',
                        ), */,
                      ),
                      _synonymsOrStems("Stems", textTheme),
                    ],
                  ),
                ),
          ],
        ),
      ),
    );
  }

  SizedBox _synonymsOrStems(String title, TextTheme textTheme) {
    List<String>? myList = [];

    if (title == "Synonyms") {
      //debugPrint("-Synonyms-");
      myList = widget.flashCard.synonyms!;
    } else if (title == "Stems") {
      // debugPrint("-Stems-");
      if (widget.flashCard.stems!.isNotEmpty) {
        myList = widget.flashCard.stems;
      } else {
        myList = [];
      }
    }
    return SizedBox(
      height: 55,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: myList!.length, //widget.myListOfWords.synonyms!.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color:
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.blueAccent.withValues(alpha: 0.5)
                        : Colors.grey[200],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  //widget.myListOfWords.synonyms![index],
                  myList![index],
                  style: textTheme.titleMedium /* TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ), */,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
