class ProfileData {
  final String uid;
  final String university;
  final String department;
  final String profession;
  final String name;
  final String mobile;
  final String email;
  final String image;
  final Information information;
  final String token;

  ProfileData({
    required this.uid,
    required this.university,
    required this.department,
    required this.profession,
    required this.name,
    required this.mobile,
    required this.email,
    required this.image,
    required this.information,
    required this.token,
  });

  factory ProfileData.fromJson(var json) {
    return ProfileData(
      uid: json['uid'] as String,
      university: json['university'] as String,
      department: json['department'] as String,
      profession: json['profession'] as String,
      name: json['name'] as String,
      mobile: json['mobile'] as String,
      email: json['email'] as String,
      image: json['image'] as String,
      information:
          Information.fromJson(json['information'] as Map<String, dynamic>),
      token: json['token'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'university': university,
      'department': department,
      'profession': profession,
      'name': name,
      'mobile': mobile,
      'email': email,
      'image': image,
      'information': information.toJson(),
      'token': token,
    };
  }
}

class Information {
  String? batch;
  String? id;
  String? session;
  String? hall;
  String? blood;
  Status? status;

  Information({
    this.batch,
    this.id,
    this.session,
    this.hall,
    this.blood,
    this.status,
  });

  factory Information.fromJson(Map<String, dynamic> json) {
    return Information(
        batch: json['batch'] ?? '',
        id: json['id'] ?? '',
        session: json['session'] ?? '',
        hall: json['hall'] ?? '',
        blood: json['blood'] ?? '',
        status: Status.fromJson(
          json['status'] ?? {},
        ));
  }

  Map<String, dynamic> toJson() {
    return {
      'batch': batch,
      'id': id,
      'session': session,
      'hall': hall,
      'blood': blood,
      'status': status!.toJson(),
    };
  }
}

class Status {
  String? subscriber;
  bool? moderator;
  bool? admin;
  bool? cr;

  Status({
    this.subscriber,
    this.moderator,
    this.admin,
    this.cr,
  });

  factory Status.fromJson(Map<String, dynamic> json) {
    return Status(
      subscriber: json['subscriber'] ?? '',
      moderator: json['moderator'] ?? false,
      admin: json['admin'] ?? false,
      cr: json['cr'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'subscriber': subscriber,
      'moderator': moderator,
      'admin': admin,
      'cr': cr,
    };
  }
}
