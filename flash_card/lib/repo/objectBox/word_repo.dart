import 'package:flash_card/repo/models/flash_card_model.dart';
import 'package:flutter/material.dart';
import 'package:objectbox/objectbox.dart';

class WordRepo {
  //Conection to my entity
  final Box<FlashCard> _wordBox;

  WordRepo(Store store) : _wordBox = store.box<FlashCard>();

  //Add
  Future<void> saveWord(FlashCard word) async {
    _wordBox.put(word);
    debugPrint("Word saved in the WordRepo. Now returning ... ");
  }

  //Get
  Future<List<FlashCard>> getWords() async {
    return _wordBox.getAll();
  }

  //Update
  Future<Map<String, dynamic>> saveAsFavOrDeleteWord(
    FlashCard flashCard,
  ) async {
    debugPrint(' is it fave before saving it ? ${flashCard.isFavorite}');

    //Set {isFavorite} to false  if the word is already in the box
    // final existingWord = _wordBox.get(flashCard.id);
    if (flashCard.isFavorite == true) {
      debugPrint("Word is FAV. So setting it back to NOT fav ...");

      FlashCard flashCardObject = FlashCard(
        id: flashCard.id,
        word: flashCard.word,
        imageURL: flashCard.imageURL,
        audio: flashCard.audio,
        definition: flashCard.definition,
        synonyms: flashCard.synonyms,
        stems: flashCard.stems,
        isFavorite: false,
        isLearned: false,
      );

      //Save the new state
      final int index = await _wordBox.putAsync(flashCardObject);

      debugPrint("Word updated with index: $index");
      return {
        'status': 'success',
        'message': 'Word removed from the favorites',
        'data': index,
      };
    }

    //Else, update the word

    FlashCard flashCardObject = FlashCard(
      id: flashCard.id,
      word: flashCard.word,
      imageURL: flashCard.imageURL,
      audio: flashCard.audio,
      definition: flashCard.definition,
      synonyms: flashCard.synonyms,
      stems: flashCard.stems,
      isFavorite: true,
      isLearned: false,
    );
    final int index = await _wordBox.putAsync(flashCardObject);
    debugPrint("Word updated with index: $index");

    if (index == -1) {
      debugPrint("Word not updated");
      final errorData = {'status': 'error', 'message': 'Word not updated'};

      return errorData;
    }

    //Else ...
    final successData = {
      'status': 'success',
      'message': 'Word saved as favorite',
      'data': index,
    };

    return successData;
  }

  //Delete
}
