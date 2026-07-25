// class ManagerModel {
//   final String uid;
//   final String name;
//   final String email;
//   final String phone;
//   final bool isVerified;
//   final bool venueSubmitted;
//   final String verificationStatus;

//   ManagerModel({
//     required this.uid,
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.isVerified,
//     required this.venueSubmitted,
//     required this.verificationStatus,
//   });

//   Map<String, dynamic> toMap() {
//     return {
//       "uid": uid,
//       "name": name,
//       "email": email,
//       "phone": phone,
//       "isVerified": isVerified,
//       "venueSubmitted": venueSubmitted,
//       "verificationStatus": verificationStatus,
//     };
//   }
// }

class ManagerModel {
  final String uid;
  final String name;
  final String email;
  final String phone;
  final bool isVerified;
  final bool venueSubmitted;
  final String verificationStatus;

  const ManagerModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.isVerified,
    required this.venueSubmitted,
    required this.verificationStatus,
  });

  Map<String, dynamic> toMap() {
    return {
      "uid": uid,
      "name": name,
      "email": email,
      "phone": phone,
      "isVerified": isVerified,
      "venueSubmitted": venueSubmitted,
      "verificationStatus": verificationStatus,
    };
  }

  factory ManagerModel.fromMap(Map<String, dynamic> map) {
    return ManagerModel(
      uid: map["uid"]?.toString() ?? "",
      name: map["name"]?.toString() ?? "",
      email: map["email"]?.toString() ?? "",
      phone: map["phone"]?.toString() ?? "",
      isVerified: map["isVerified"] as bool? ?? false,
      venueSubmitted: map["venueSubmitted"] as bool? ?? false,
      verificationStatus:
          map["verificationStatus"]?.toString() ?? "not_submitted",
    );
  }
}