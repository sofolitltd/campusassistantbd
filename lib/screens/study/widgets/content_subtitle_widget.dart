String contentSubtitleWidget({required String courseType}) {
  switch (courseType.toLowerCase()) {
    case 'notes':
      {
        return 'Creator';
      }
    case 'books':
      {
        return 'Author';
      }
  }
  return 'Year';
}
