class User {
  String? imageUrl;
  final String nameSurname;
  final int birthDateInMillis;
  final String location;
  final String email;
  final String phoneNumber;
  final String password;
  final List<String>? myJobs;
  final List<String>? savedCrafts;
  final List<String>? chats;

  User({
    this.imageUrl,
    required this.nameSurname,
    required this.birthDateInMillis,
    required this.email,
    required this.location,
    required this.password,
    required this.phoneNumber,
    this.myJobs = const [],
    this.savedCrafts = const [],
    this.chats = const [],
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        imageUrl: json['imageUrl'],
        nameSurname: json['nameSurname'],
        birthDateInMillis: json['birthDateInMillis'],
        email: json['email'],
        location: json['location'],
        password: json['password'],
        phoneNumber: json['phoneNumber'],
        myJobs: (json['myJobs'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        savedCrafts: (json['savedCrafts'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
        chats: (json['chats'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            const [],
      );

  Map<String, dynamic> toJson() => {
        'imageUrl': imageUrl,
        'nameSurname': nameSurname,
        'birthDateInMillis': birthDateInMillis,
        'email': email,
        'location': location,
        'password': password,
        'phoneNumber': phoneNumber,
        'myJobs': myJobs?.toList(),
        'savedCrafts': savedCrafts?.toList(),
        'chats': chats?.toList(),
      };

  User copyWith({
    String? imageUrl,
    List<String>? myJobs = const [],
    List<String>? savedCrafts = const [],
    List<String>? chats = const [],
  }) =>
      User(
        imageUrl: imageUrl ?? this.imageUrl,
        nameSurname: nameSurname,
        birthDateInMillis: birthDateInMillis,
        email: email,
        location: location,
        password: password,
        phoneNumber: phoneNumber,
        myJobs: myJobs ?? this.myJobs,
        savedCrafts: savedCrafts ?? this.savedCrafts,
        chats: chats ?? this.chats,
      );
}
