String getRelativeUnitCode(String? fullCode) {
  if (fullCode == null || fullCode.isEmpty) return '\u2014';
  String part = fullCode;
  if (fullCode.contains('-')) part = fullCode.split('-').last.trim();
  if (part.startsWith('UD')) return part;
  if (part.startsWith('U')) return 'UD${part.substring(1)}';
  return part;
}

String getRelativeActivityCode(String? fullCode) {
  if (fullCode == null || fullCode.isEmpty) return '\u2014';
  final isCont = fullCode.contains('(Cont.)');
  String cleanCode = fullCode.replaceAll(' (Cont.)', '').trim();
  if (cleanCode.contains('-')) cleanCode = cleanCode.split('-').last.trim();
  return isCont ? '$cleanCode (Cont.)' : cleanCode;
}
