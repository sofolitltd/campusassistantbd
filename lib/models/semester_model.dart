class SemesterModel {
  final String title;
  final String courses;
  final String credits;
  final String marks;
  final List<dynamic> batches;

  SemesterModel({
    required this.title,
    required this.courses,
    required this.credits,
    required this.marks,
    required this.batches,
  });

  // fetch
  factory SemesterModel.fromJson(var json) {
    return SemesterModel(
      title: json['title']! as String,
      courses: json['courses']! as String,
      credits: json['credits']! as String,
      marks: json['marks']! as String,
      batches: json['batches']! as List<dynamic>,
    );
  }

  // upload
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'courses': courses,
      'credits': credits,
      'marks': marks,
      'batches': batches,
    };
  }
}
