class Post {
  final Id;
  final name;
  dynamic profile;
  dynamic post;

  Post(
      {required this.Id,
      required this.name,
      required this.profile,
      required this.post});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        Id: json['studentID'],
        name: json['name'],
        profile: 'Halla',
        post: json['post']);
  }
}
