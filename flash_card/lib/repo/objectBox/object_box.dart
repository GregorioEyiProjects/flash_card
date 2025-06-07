import 'package:path/path.dart' as p;
import 'package:flash_card/objectbox.g.dart';
import 'package:flash_card/repo/objectBox/word_repo.dart';
import 'package:path_provider/path_provider.dart';

class ObjectBox {
  //Init the Store
  late final Store _store;

  //ini the WORDS repo
  late final WordRepo wordRepo;

  //Private constructor
  ObjectBox._create(this._store) {
    wordRepo = WordRepo(_store);
  }

  //Create the ObjectBox to be used in the app
  static Future<ObjectBox> create() async {
    //Create the store
    final store = await openStore(
      directory: p.join(
        (await getApplicationDocumentsDirectory()).path,
        "flash_card",
      ),
    );
    return ObjectBox._create(store);
  }
}
