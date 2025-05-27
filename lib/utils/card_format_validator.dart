class CardFormatValidator {
  bool isValidFormat(String code, List<String> formats) {
    if (code.isEmpty) {
      return false;
    }

    // If no specific patterns provided, allow any alphanumeric non-empty string
    if (formats.isEmpty) {
      final defaultRegex = RegExp(r'^[A-Za-z0-9]+$');
      return defaultRegex.hasMatch(code);
    }

    // Validate against each defined pattern
    for (final pattern in formats) {
      final regex = RegExp(pattern);
      if (regex.hasMatch(code)) {
        return true;
      }
    }

    return false;
  }
}
