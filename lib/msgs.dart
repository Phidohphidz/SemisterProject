class MSG {
  dynamic StudentID;
  dynamic inbox;
  dynamic messages;

  MSG({required this.StudentID, required this.inbox, required this.messages});

  factory MSG.fromJson(Map<String, dynamic> Json) {
    return MSG(
        inbox: Json['inbox'],
        StudentID: Json['StudentID'],
        messages: Json['inbox']['messages']);
  }
}
