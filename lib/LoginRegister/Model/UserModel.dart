class UserModel {
  String name, email, urlfoto, phoneNumber,role;

  UserModel({
    required this.name,
    required this.email,
    required this.urlfoto,
    this.phoneNumber = "",
    required this.role,
  });
}
