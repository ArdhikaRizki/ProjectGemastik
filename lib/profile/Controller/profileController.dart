import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../LoginRegister/Model/UserModel.dart';

class profileController extends GetxController{
  FirebaseAuth auth = FirebaseAuth.instance;
  Stream<User?> get streamAuthStatus => auth.authStateChanges();

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
  }
 Future<UserModel> getUserData() async {
   final user = FirebaseAuth.instance.currentUser;
   if (user != null) {
     // Name, email address, and profile photo URL
     print(user.email);
     print(user.displayName);
     final nama = user.displayName;
     final email = user.email;
     final photoUrl = user.photoURL;

     UserModel userdata = UserModel(
       name: nama ?? '',
       email: email ?? '',
       urlfoto: photoUrl ?? '',
     );
     // Check if user's email is verified
     // The user's ID, unique to the Firebase project. Do NOT use this value to
     // authenticate with your backend server, if you have one. Use
     // User.getIdToken() instead.
     final uid = user.uid;
     return userdata;
   }
    else {
      // No user is signed in.
      print('No user is signed in.');
      return UserModel(name: '', email: '', urlfoto: '');
    }
  }

  Future<void> updateNama(String nama) async {
    final user = FirebaseAuth.instance.currentUser;
    print("Nama yang akan diupdate: $nama");
    await user?.updateDisplayName(nama);
  }
  Future<void> updateFoto(String urlFoto) async {
    final user = FirebaseAuth.instance.currentUser;
    await user?.updatePhotoURL(urlFoto);
  }


}