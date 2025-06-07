import 'dart:isolate';

import 'package:flash_card/app_colors.dart';
import 'package:flash_card/provider/app_provider.dart';
import 'package:flash_card/repo/fetch.dart';
import 'package:flash_card/repo/models/flash_card_model.dart';
import 'package:flash_card/screens/widgets/dialogs/show_error_dialog.dart';
import 'package:flash_card/screens/widgets/dialogs/show_loading_dialog.dart';
import 'package:flash_card/screens/widgets/dialogs/show_success_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewWord extends StatelessWidget {
  //final AppProvider? provider;
  const AddNewWord({super.key});

  // Close the LoadingDialog
  void closeLoadingDialog() {
    if (dialogContext != null && Navigator.canPop(dialogContext!)) {
      debugPrint("Closing the loading dialog ...");
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pop(dialogContext!);
      });
    }
  }

  //Show the bottom sheet mehtod
  Future<dynamic> _showBottomSheet(BuildContext context) {
    //Variables
    String? word;
    //Text controller
    final TextEditingController constroller = TextEditingController();

    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        // Detect keyboard height
        final double keyboardHeight = MediaQuery.of(context).viewInsets.bottom;
        return StatefulBuilder(
          builder: (context, setState) {
            return Container(
              height: 210 + keyboardHeight,
              decoration: BoxDecoration(
                color: AppColors.backgroundColorWhite,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(50),
                  topRight: Radius.circular(50),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                //mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Close button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Container(
                          height: 30,
                          width: 30,
                          decoration: BoxDecoration(
                            color: AppColors.greyColor,
                            borderRadius: BorderRadius.circular(50),
                          ),
                          child: Icon(
                            Icons.close,
                            size: 30,
                            color: AppColors.blackColor,
                          ),
                        ),
                      ),
                    ],
                  ),

                  //Add new word
                  const Text(
                    'Add new word!',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Poppins",
                    ),
                  ),
                  //Text field
                  Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30),
                    child: TextField(
                      controller: constroller,
                      decoration: InputDecoration(
                        hintText: 'Enter the word',
                        label: Text(
                          'Enter the word',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.blackColor,
                            fontWeight: FontWeight.w500,
                            fontFamily: "Poppins",
                          ),
                        ),
                        hintStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          fontFamily: "Poppins",
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),

                  //Spacing
                  SizedBox(height: 20),

                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //Add button
                        GestureDetector(
                          onTap: () async {
                            setState(() {
                              word = constroller.text;
                            });
                            debugPrint(word);

                            // Show loading dialog
                            showLoadingIconDialog(context);

                            //Get the provider
                            final provider = Provider.of<AppProvider>(
                              context,
                              listen: false,
                            );

                            //Seach for the image
                            Map<String, dynamic> response =
                                await searchImagesAndAudio(word!);
                            debugPrint("Here is the image $response");

                            if (response['status'] == 'error') {
                              if (context.mounted) {
                                showErrorDialog(
                                  context,
                                  "Sorry pal, word no found ❌",
                                  () {
                                    Navigator.pop(context);
                                  },
                                );
                              }
                              return;
                            }

                            //Else ...

                            //Start the search for meanings
                            if (context.mounted) {
                              await startSearchForMeaningsInIsolate(
                                context,
                                word!,
                                response['data']['imageUrl'],
                                response['data']['audioUrl'],
                                provider,
                                () {
                                  Navigator.pop(context);
                                },
                                () {
                                  Navigator.pop(context);
                                },
                              );
                            }
                          },
                          child: Container(
                            height: 50,
                            width: 70,
                            decoration: BoxDecoration(
                              color: AppColors.blackColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Center(
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  color: AppColors.whiteColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  fontFamily: "Poppins",
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  //Start the search for meanings in the isolate
  Future<void> startSearchForMeaningsInIsolate(
    BuildContext context,
    String word,
    String imageURL,
    String audioURL,
    AppProvider provider,
    VoidCallback onSuccess,
    VoidCallback onError,
  ) async {
    //Create the receive port
    final receivePort = ReceivePort();

    //Create the isolate
    await Isolate.spawn(searchForMeaningsInIsolate, {
      'sendPort': receivePort.sendPort,
      'word': word,
    });

    debugPrint("Isolate created. Now listening for response ...");

    //Listen for the response
    receivePort.listen((message) async {
      debugPrint("Done listening for response ...");

      //Close the loading dialog
      if (context.mounted) {
        Navigator.of(context).pop(); // Close the loading dialog
      }

      debugPrint("Here is the word searched: $word");
      debugPrint("Here is the response from the Isolate: $message");

      //Error message
      final responseStatus = message['status'];
      debugPrint("Here is the response status: $responseStatus");

      //Return if the error variable  has a value
      if (responseStatus == 'error') {
        if (context.mounted) {
          showErrorDialog(context, "Sorry pal, word no found ❌", onError);
        }
        return;
      }

      //ELSE ...

      //Get the data
      final responseData = message as Map<String, dynamic>;

      final Map<String, dynamic> data = responseData['data'];

      debugPrint("Here is the data: $data");
      debugPrint("Here is the imageURL: $imageURL");
      debugPrint("Here is the stems: ${data['stems']}");
      debugPrint("Type of stems: ${data['stems'].runtimeType}");
      debugPrint("Type of synonyms: ${data['synonyms'].runtimeType}");

      FlashCard flashCard = FlashCard(
        word: word,
        imageURL: imageURL,
        audio: audioURL,
        definition: data['definitions'] ?? [],
        synonyms: data['synonyms'] ?? [],
        antonyms: data['antonyms'] ?? [],
        stems: data['stems'] ?? [],
      );
      debugPrint("Here is the FlashCard data: ${flashCard.toPrint()}");

      //Save the word
      try {
        await provider.saveWord(flashCard);
        if (context.mounted) {
          showSuccessDialog(context, "Word saved successfully! ✅", onSuccess);
        }
      } catch (e) {
        if (context.mounted) {
          showErrorDialog(context, "Failed to save word! ❌", onError);
        }
      }

      //Close the receive port
      receivePort.close();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundColorWhite,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        onPressed: () async {
          //debugPrint("Add button clicked");
          await _showBottomSheet(context);
        },
        icon: Icon(Icons.add, size: 30, color: AppColors.blackColor),
      ),
    );
  }
}
