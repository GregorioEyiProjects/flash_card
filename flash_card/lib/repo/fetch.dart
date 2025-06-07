//get the iamges
import 'dart:convert';
import 'dart:isolate';

import 'package:flash_card/helper/constants/consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

//Search for images
Future<Map<String, dynamic>> searchImagesAndAudio(String query) async {
  debugPrint("Seaching for images ... ");
  try {
    final respose = await http.get(
      Uri.parse('https://api.pexels.com/v1/search?query=$query&per_page=1'),
      headers: {'Authorization': pexelapiKey},
    );
    //debugPrint("Here is the response from searchImages: ${respose.body}");

    if (respose.statusCode == 200) {
      //print(respose.body);
      //Decode the json
      //final data = json.decode(response.body);
      final data = jsonDecode(respose.body);
      // print("Here is the ${data['photos'][0]['src']['original']}");
      debugPrint("Done searching for images. Now returning ...");

      //Get the image url
      final imageUrl = data['photos'][0]['src']['original'];

      //Search for an audion in 'https://dictionaryapi.dev/'
      final audioUrl = await searchForAudio(query);
      debugPrint("Here is the audioUrl form searchForAudio: $audioUrl");

      //Check if the audioUrl is successful
      if (audioUrl['status'] == 'error') {
        return {'status': 'error', 'message': 'Failed to load audio'};
      }

      //Create the response data
      final responseData = {'imageUrl': imageUrl, 'audioUrl': audioUrl['data']};

      //Return the data
      return {'status': 'success', 'data': responseData};
    } else {
      debugPrint("Failed to load images");
      return {'status': 'error', 'message': 'The response was not successful'};
    }
  } catch (e) {
    debugPrint("Here is the error from searchImagesAndAudio: $e");
    return {'status': 'error', 'message': 'Failed to load images'};
  }
}

//GEt the audio url
Future<Map<String, dynamic>> searchForAudio(String query) async {
  debugPrint("Searching for audio ... ");

  String audioUrl = '';

  //URL
  final url = "https://api.dictionaryapi.dev/api/v2/entries/en/$query";
  //debugPrint("Here is the url: $url");

  try {
    final response = await http.get(Uri.parse(url));
    //debugPrint("Here is the response from searchForAudio: ${response.body}");

    //Check if the response is successful
    if (response.statusCode != 200) {
      debugPrint("Response is not successful");
      return {'status': 'error', 'message': 'Failed to load audio'};
    }

    //Else ...

    //Decode the json
    final List<dynamic> jsonResponse = jsonDecode(response.body);

    final List<dynamic> audioList = jsonResponse[0]['phonetics'];
    debugPrint("Here is the audioList: $audioList");

    for (var phonetic in audioList) {
      //Check if the audio key exists and is not null
      if (phonetic.containsKey('audio') &&
          phonetic['audio'] != null &&
          phonetic['audio'].toString().isNotEmpty) {
        //Get the audio url
        audioUrl = phonetic['audio'];
        debugPrint("Audio found. Now returning ...");
        return {'status': 'success', 'data': audioUrl};
      }
    }
    return {'status': 'error', 'message': 'No audio found'};
  } catch (e) {
    debugPrint("Here is the error from searchForAudio: $e");
    return {'status': 'error', 'message': 'No audio found'};
  }
}

// Search for meanings (Isolate function in case the search for meanings takes too long)
Future<void> searchForMeaningsInIsolate(Map<String, dynamic> args) async {
  debugPrint("Searching for meanings in isolate 2 ... ");

  //gGet the send port and word from the args
  final sendPort = args['sendPort'] as SendPort;
  final word = args['word'] as String;

  debugPrint("Here is the word: $word");

  //Contruct the url
  final url =
      "https://www.dictionaryapi.com/api/v3/references/ithesaurus/json/$word?key=$meriamApiKey";
  debugPrint("Here is the url: $url");

  try {
    //Fetch the data from the Oxford API
    final response = await http.get(Uri.parse(url));

    //Check the response status code
    if (response.statusCode == 200) {
      final List<dynamic> dataResponse = jsonDecode(response.body);

      //Parse the response
      if (dataResponse.isNotEmpty && dataResponse[0].containsKey('meta')) {
        debugPrint("dataResponse is not empty and contains meta");

        //Parse the response
        final Map<String, dynamic> parsedResponse = parseResponse(
          dataResponse,
          word,
        );

        if (parsedResponse['status'] == 'success') {
          sendPort.send({'status': 'success', 'data': parsedResponse['data']});
          return;
        } else {
          sendPort.send({
            'status': 'error',
            'message': 'Failed to parse response',
          });
          return;
        }
      } else {
        sendPort.send({'status': 'error', 'message': 'No valid data found'});
        return;
      }
    } else {
      sendPort.send({
        'status': 'error',
        'message': 'API request failed with status: ${response.statusCode}',
      });
      return;
    }
  } catch (e) {
    debugPrint("Error in searchForMeaningsInIsolate: $e");
    sendPort.send({
      'status': 'error',
      'message': 'An error occurred while fetching data',
    });
  }
}

//Parse the response (used in searchForMeaningsInIsolate)
Map<String, dynamic> parseResponse(List<dynamic> responseBody, String word) {
  debugPrint("Now in parseResponse ...");

  List<String> stemsList = [];
  List<String> synonymsList = [];
  List<String> antonymsList = [];
  List<String> definitions = [];

  final Map<String, dynamic> firstElement = responseBody[0];

  // Access the 'meta' key from the first element
  final Map<String, dynamic>? meta =
      firstElement['meta'] as Map<String, dynamic>?;

  //Get the 'shortdef' key from the first element
  final List<dynamic>? def = firstElement['shortdef'] as List<dynamic>?;

  //------  //------

  if (meta != null) {
    debugPrint(
      "Meta is NOT null, so getting the 'stems', 'syns', and 'ants' ... ",
    );

    //debugPrint("Here is the meta: $meta");
    //debugPrint("Here is the def: $def");

    // Get Stems (list of strings)
    final List<String>? stems =
        meta['stems'] != null
            ? List<String>.from(meta['stems'].map((item) => item.toString()))
            : [];

    if (stems != null) {
      debugPrint("Stems is NOT null");

      // Convert dynamic list to List<String>
      stemsList = List<String>.from(stems.map((item) => item.toString()));
    }

    // Get Synonyms (list of lists of strings)
    final List<dynamic>? syns = meta['syns'] as List<dynamic>?;

    if (syns != null && syns.isNotEmpty && syns[0] is List<dynamic>) {
      debugPrint("syns is NOT null");

      // Take the first list of synonyms
      final List<dynamic> firstSynList = syns[0];
      synonymsList = List<String>.from(
        firstSynList.map((item) => item.toString()),
      );
    }

    // Get Antonyms (list of lists of strings - often empty)
    final List<dynamic>? ants = meta['ants'] as List<dynamic>?;
    if (ants != null && ants.isNotEmpty && ants[0] is List<dynamic>) {
      debugPrint("ants is NOT null");

      // Take the first list of antonyms
      final List<dynamic> firstAntList = ants[0];
      antonymsList = List<String>.from(
        firstAntList.map((item) => item.toString()),
      );
    }

    if (def != null) {
      debugPrint("def is NOT null");
      // Convert dynamic list to List<String>
      definitions = List<String>.from(def.map((item) => item.toString()));
    }

    debugPrint("Here is the stems: $stemsList");
    debugPrint("Here is the synonyms: $synonymsList");
    debugPrint("Here is the antonyms: $antonymsList");
    debugPrint("Here is the definitions: $definitions");
    debugPrint("Here is the word: $word");

    final data = {
      'stems': stemsList,
      'synonyms': synonymsList,
      'antonyms': antonymsList,
      'definitions': definitions,
      'word': word,
    };

    //Return the data
    return {'status': 'success', 'data': data};
  } else {
    //--- ERROR RESPONSE
    debugPrint(
      "Warning: 'meta' or 'shortdef' section not found in the response element.",
    );

    //Create the error data
    final errorData = {
      'stems': [],
      'synonyms': [],
      'antonyms': [],
      'definitions': [],
      'word': word,
    };

    //Return the data
    return {'status': 'error', 'data': errorData};
  }
}

//Get the user's country and the language spoken in that country
Future<Map<String, dynamic>> getUserCountryAndLanguage() async {
  debugPrint("Getting user's country and language ...");

  const url = "https://api.ipgeolocation.io/ipgeo?apiKey=$ipgeolocationApiKey";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      debugPrint("API request failed with status: ${response.statusCode}");
      return {
        'status': 'error',
        'message': 'Failed to get user country and language',
      };
    }

    final data = jsonDecode(response.body);

    // Validate required fields
    if (!data.containsKey('country_name') || !data.containsKey('languages')) {
      debugPrint("Required fields missing in API response");
      return {'status': 'error', 'message': 'Invalid response format from API'};
    }

    // Get the data with null safety
    final countryName = data['country_name']?.toString() ?? '';
    final languages = data['languages']?.toString() ?? '';

    if (countryName.isEmpty || languages.isEmpty) {
      debugPrint("Country name or languages is empty");
      return {'status': 'error', 'message': 'Required data is missing'};
    }

    // Extract first language more robustly
    final language = languages.split(',').first.trim();

    // Additional data (optional)
    final continentName = data['continent_name']?.toString() ?? '';
    final countryCapital = data['country_capital']?.toString() ?? '';
    final city = data['city']?.toString() ?? '';
    final latitude = data['latitude']?.toString() ?? '';
    final longitude = data['longitude']?.toString() ?? '';
    final currency = data['currency']?['code']?.toString() ?? '';

    final responseData = {
      'country': countryName,
      'language': language,
      'continent': continentName,
      'capital': countryCapital,
      'city': city,
      'coordinates': {'latitude': latitude, 'longitude': longitude},
      'currency': currency,
    };

    // Save to SharedPreferences
    try {
      final prefs = await SharedPreferences.getInstance();
      final currentCountry = prefs.getString('country');
      final currentLanguage = prefs.getString('language');

      if (currentCountry != countryName || currentLanguage != language) {
        await prefs.setString('country', countryName);
        await prefs.setString('language', language);
        debugPrint("Location data saved to SharedPreferences");
      }
    } catch (e) {
      debugPrint("Error saving to SharedPreferences: $e");
      // Continue execution even if saving fails
    }

    debugPrint("Here is the responseData: $responseData");
    return {'status': 'success', 'data': responseData};
  } on http.ClientException catch (e) {
    debugPrint("Network error: $e");
    return {'status': 'error', 'message': 'Network error occurred'};
  } on FormatException catch (e) {
    debugPrint("JSON parsing error: $e");
    return {'status': 'error', 'message': 'Invalid response format'};
  } catch (e) {
    debugPrint("Unexpected error in getUserCountryAndLanguage: $e");
    return {'status': 'error', 'message': 'An unexpected error occurred'};
  }
}

//Translate the text
Future<Map<String, dynamic>> translateText(
  String text,
  String from,
  String to,
) async {
  debugPrint("Translating this text $text from $from to $to ...");

  // Validate input parameters
  if (text.isEmpty) {
    debugPrint("Text to translate is empty");
    return {'status': 'error', 'message': 'Text to translate cannot be empty'};
  }

  if (from.isEmpty || to.isEmpty) {
    debugPrint("Language codes are empty");
    return {'status': 'error', 'message': 'Language codes cannot be empty'};
  }

  // Construct the URL with proper encoding
  final encodedText = Uri.encodeComponent(text);
  debugPrint("Here is the encodedText: $encodedText");

  //Contruct the url
  final url =
      "https://api.mymemory.translated.net/get?q=$encodedText&langpair=$from|$to";

  try {
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      debugPrint("API request failed with status: ${response.statusCode}");
      return {
        'status': 'error',
        'message':
            'Translation service unavailable. Status: ${response.statusCode}',
      };
    }

    //Decode the response
    final data = jsonDecode(response.body);

    // Check for quota finished
    if (data['quotaFinished'] == true) {
      debugPrint("Translation quota exceeded");
      return {'status': 'error', 'message': 'Translation quota exceeded'};
    }

    // Check if we have response data
    if (!data.containsKey('responseData') || data['responseData'] == null) {
      debugPrint("No translation data in response");
      return {'status': 'error', 'message': 'No translation data available'};
    }

    //Get the translated text
    final responseData = data['responseData'];
    final translatedText = responseData['translatedText']?.toString() ?? '';

    if (translatedText.isEmpty) {
      debugPrint("No translation found");
      return {'status': 'error', 'message': 'No translation available'};
    }

    debugPrint("Translation successful: $translatedText");

    //Return the result
    final result = {'translatedText': translatedText};
    return {'status': 'success', 'data': result};
  } on http.ClientException catch (e) {
    debugPrint("Network error: $e");
    return {'status': 'error', 'message': 'Network error occurred'};
  } on FormatException catch (e) {
    debugPrint("JSON parsing error: $e");
    return {'status': 'error', 'message': 'Invalid response format'};
  } catch (e) {
    debugPrint("Unexpected error in translateText: $e");
    return {'status': 'error', 'message': 'An unexpected error occurred'};
  }
}
