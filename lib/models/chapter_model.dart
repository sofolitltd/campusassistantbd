class ChapterModel {
  final String courseCode;
  final int chapterNo;
  final String chapterTitle;
  final List<dynamic> batches;

  ChapterModel({
    required this.courseCode,
    required this.chapterNo,
    required this.chapterTitle,
    required this.batches,
  });

  // fetch
  factory ChapterModel.fromJson(var json) {
    return ChapterModel(
      courseCode: json['courseCode']! as String,
      chapterNo: json['chapterNo']! as int,
      chapterTitle: json['chapterTitle']! as String,
      batches: (json['batches']! as List).cast<String>(),
    );
  }

  // upload
  Map<String, dynamic> toJson() {
    return {
      'courseCode': courseCode,
      'chapterNo': chapterNo,
      'chapterTitle': chapterTitle,
      'batches': batches,
    };
  }
}
