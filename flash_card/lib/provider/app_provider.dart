import 'package:flash_card/repo/models/flash_card_model.dart';
import 'package:flash_card/repo/objectBox/object_box.dart';
import 'package:flutter/widgets.dart';

class AppProvider with ChangeNotifier {
  //ObjectBox store
  final ObjectBox _objectBox;

  //Constructor
  AppProvider(this._objectBox);

  //Private list
  List<FlashCard> _listOfWords = [];
  List<FlashCard> _userFavoriteWords = [];

  //Public list
  List<FlashCard> get listOfWords => _listOfWords;
  List<FlashCard> get userFavoriteWords => _userFavoriteWords;

  //Fetch the list of words
  Future<void> fetchListOfWords() async {
    //Get the list of words
    _listOfWords = await _objectBox.wordRepo.getWords();

    if (_listOfWords.isEmpty) {
      debugPrint("List of words is empty");
      notifyListeners();
      return;
    }

    debugPrint(
      "Lenght of the entire list of all words: ${_listOfWords.length}",
    );

    /**/
    debugPrint("Here is the first of word: ${listOfWords.first.word}");
    debugPrint("is first word favorite?: ${listOfWords.last.isFavorite}");

    //Get the list of favorite words
    _userFavoriteWords =
        _listOfWords.where((word) => word.isFavorite == true).toList();
    debugPrint(
      "Lenght of the entire list of all favorite words: ${_userFavoriteWords.length}",
    );

    notifyListeners();
  }

  //Save the word
  Future<void> saveWord(FlashCard flashCard) async {
    debugPrint("Saving the word in Provider ... ");
    //Save the word
    await _objectBox.wordRepo.saveWord(flashCard);
    //Fetch the list of words
    await fetchListOfWords();
  }

  //Update the word
  Future<Map<String, dynamic>> updateWord(FlashCard flashCard) async {
    debugPrint("Updating the word in Provider ... ");
    //Update the word
    final Map<String, dynamic> response = await _objectBox.wordRepo
        .saveAsFavOrDeleteWord(flashCard);

    if (response['status'] == 'success') {
      debugPrint("Word updated successfully in Provider ... ");
      //Else ...
      //Fetch the list of words
      await fetchListOfWords();

      debugPrint("Word updated successfully in Provider ... ");
      debugPrint("Message: ${response['message']}");

      return response;
    }

    //Else ...
    debugPrint("Error updating the word in Provider ... ");
    return response;
  }
}
