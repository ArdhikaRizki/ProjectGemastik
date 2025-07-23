class UserModel {
  String name, email, urlfoto, phoneNumber;

  UserModel({
    required this.name,
    required this.email,
    required this.urlfoto,
    this.phoneNumber = "",
  });
}
