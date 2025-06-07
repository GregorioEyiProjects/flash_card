String capitalizeFirstLetter(String? word) {
  if (word == null || word.isEmpty) return "";
  return word[0].toUpperCase() + word.substring(1);
}
