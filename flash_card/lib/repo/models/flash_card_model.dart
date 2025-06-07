import 'package:objectbox/objectbox.dart';

@Entity()
class FlashCard {
  @Id(assignable: true)
  int id;
  String word;
  String? imageURL;
  String? audio;
  List<String>? definition;
  List<String>? synonyms;
  List<String>? antonyms;
  List<String>? stems;
  bool? isFavorite;
  bool? isLearned;

  FlashCard({
    this.id = 0,
    required this.word,
    this.imageURL,
    this.audio,
    this.definition,
    this.synonyms,
    this.antonyms,
    this.stems,
    this.isFavorite = false,
    this.isLearned = false,
  });

  //TO print the object
  Map<String, dynamic> toPrint() {
    return {
      'id': id,
      'word': word,
      'imageURL': imageURL,
      'audio': audio,
      'description': definition,
      'synonyms': synonyms,
      'antonyms': antonyms,
      'stems': stems,
      'isFavorite': isFavorite,
      'isLearned': isLearned,
    };
  }
}
