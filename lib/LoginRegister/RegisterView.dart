import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_gemastik/LoginRegister/SignInUpController.dart';

class Registerview extends GetView<SignInUpController> {
  final loginemailC = TextEditingController();
  final regisemailC = TextEditingController();
  final loginpasswordC = TextEditingController();
  final regispasswordC = TextEditingController();
  final regisconfirmPasswordC = TextEditingController();
  final authC = Get.find<SignInUpController>();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 159,
        backgroundColor: Color.fromRGBO(1, 130, 65, 1.0),
      ),
      body: Center(
        child: SafeArea(
          child: SizedBox(
            width: 280,
            child: Column(
              children: [
                SizedBox(height: 40),
                Expanded(
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      children: [
                        TabBar(
                          splashFactory: NoSplash.splashFactory,
                          overlayColor: WidgetStateProperty.resolveWith<
                            Color?
                          >((Set<WidgetState> states) {
                            // Use transparent for overlay states to further suppress any visual feedback
                            return Colors.transparent;
                          }),
                          tabs: [
                            Tab(child: Text("Login")),
                            Tab(child: Text("Register")),
                          ],
                        ),
                        // Wrap TabBarView with Expanded
                        Expanded(
                          child: TabBarView(
                            children: [
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20),
                                    Text(
                                      "Sign In",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    TextField(
                                      controller: loginemailC,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Email',
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      controller: loginpasswordC,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Password',
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    Container(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed:
                                            () => authC.signIn(
                                              loginemailC.text,
                                              loginpasswordC.text,
                                            ),
                                        child: Text(
                                          "Login",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color.fromRGBO(
                                            1,
                                            130,
                                            65,
                                            1.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Use Center for better visibility
                              SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 20),
                                    Text(
                                      "Sign Up",
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(height: 40),
                                    TextField(
                                      controller: regisemailC,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Email',
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      controller: regispasswordC,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Password',
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    TextField(
                                      controller: regisconfirmPasswordC,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Confirm Password',
                                      ),
                                    ),
                                    SizedBox(height: 20),
                                    DropdownButtonFormField<String>(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Kamu siapa?',
                                      ),
                                      value:
                                          authC
                                              .selectedRole
                                              .value, // Nilai yang sedang aktif
                                      items:
                                          authC.roles.map((String role) {
                                            return DropdownMenuItem<String>(
                                              value: role,
                                              child: Text(
                                                role.capitalizeFirst ?? role,
                                              ), // Membuat huruf pertama besar
                                            );
                                          }).toList(),
                                      onChanged: (String? newValue) {
                                        // Panggil fungsi di controller untuk update nilai
                                        authC.updateRole(newValue);
                                      },
                                    ),
                                    SizedBox(height: 20),

                                    // Di dalam Registerview.dart
                                    Container(
                                      width: double.infinity,
                                      child: TextButton(
                                        // Buat satu callback onPressed
                                        onPressed: () {
                                          // Pindahkan pengecekan ke dalam sini
                                          final email = regisemailC.text;
                                          final password = regispasswordC.text;
                                          final confirmPassword =
                                              regisconfirmPasswordC.text;
                                          if (!GetUtils.isEmail(email)) {
                                            Get.snackbar(
                                              "Registrasi Gagal",
                                              "Format email yang Anda masukkan tidak valid.",
                                              snackPosition:SnackPosition.BOTTOM,
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white, 
                                            );
                                          }
                                          // Jika email valid, baru cek password
                                          else if (password !=
                                              confirmPassword) {
                                            Get.snackbar(
                                              "Registrasi Gagal",
                                              "Password dan Konfirmasi Password tidak sama.",
                                              snackPosition:SnackPosition.BOTTOM,
                                              backgroundColor: Colors.red,
                                              colorText: Colors.white, 
                                            );
                                          } else {
                                            // Jika password sama, panggil signUp
                                            authC.signUp(
                                              regisemailC.text,
                                              regispasswordC.text,
                                              "", // name
                                              "", // phoneNumber
                                              authC.selectedRole.value,
                                            );
                                          }
                                        },
                                        child: Text(
                                          "Register",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color.fromRGBO(
                                            1,
                                            130,
                                            65,
                                            1.0,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // Use Center for better visibility
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
