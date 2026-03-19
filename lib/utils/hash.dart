String simpleHash(String input) {
  int hash = 0;
  for (int i = 0; i < input.length; i++) {
    hash = ((hash << 5) - hash) + input.codeUnitAt(i);
    hash = hash & hash; // Convert to 32-bit integer
  }
  return hash.abs().toString();
}