String simpleHash(String input) {
  int hash = 5381;
  for (int i = 0; i < input.length; i++) {
    hash = ((hash << 5) + hash) ^ input.codeUnitAt(i);
    hash = hash & 0x7FFFFFFF;
  }
  return hash.toRadixString(36);
}
