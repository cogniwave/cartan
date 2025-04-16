class CardFormatValidator {
  bool isValidFormat(String code, List<String> formats) {
    if (code.isEmpty) return false;
    
    for (final formatPattern in formats) {
      final RegExp regex = RegExp(formatPattern);
      if (regex.hasMatch(code)) {
        return true;
      }
    }
    
    return false;
  }
}
