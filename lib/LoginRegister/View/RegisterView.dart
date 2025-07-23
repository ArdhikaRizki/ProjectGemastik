import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../firebase_options.dart';
import '../Controlller/SignInUpController.dart';

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
        child: SafeArea(child:
        SizedBox(
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
                            overlayColor:
                            WidgetStateProperty.resolveWith<Color?>(
                                  (Set<WidgetState> states) {
                                // Use transparent for overlay states to further suppress any visual feedback
                                return Colors.transparent;
                              },
                            ),
                            tabs: [
                              Tab(child: Text("Login")),
                              Tab(child: Text("Register")),
                            ]),
                        // Wrap TabBarView with Expanded
                        Expanded(
                          child: TabBarView(children: [
                            SingleChildScrollView(
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment
                                      .start,
                                  children: [
                                    SizedBox(height: 20,),
                                    Text("Sign In", style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,),),
                                    SizedBox(height: 40,),
                                    TextField(
                                      controller: loginemailC,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Email',
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    TextField(
                                      controller: loginpasswordC,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        labelText: 'Password',
                                      ),
                                    ),
                                    SizedBox(height: 20,),
                                    Container(
                                      width: double.infinity,
                                      child: TextButton(
                                        onPressed: () =>
                                            authC.signIn(loginemailC.text,
                                                loginpasswordC.text),
                                        child: Text("Login",
                                            style: TextStyle(
                                                color: Colors.white)),
                                        style: TextButton.styleFrom(
                                          backgroundColor: Color
                                              .fromRGBO(
                                              1, 130, 65, 1.0),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius
                                                .circular(6),
                                          ),
                                        ),),
                                    )
                                  ]),
                            ),
                            // Use Center for better visibility
                            SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment
                                    .start,
                                children: [
                                  SizedBox(height: 20,),
                                  Text("Sign Up", style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,),),
                                  SizedBox(height: 40,),
                                  TextField(
                                    controller: regisemailC,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Email',
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  TextField(
                                    controller: regispasswordC,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Password',
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  TextField(
                                    controller: regisconfirmPasswordC,
                                    obscureText: true,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      labelText: 'Confirm Password',
                                    ),
                                  ),
                                  SizedBox(height: 20,),
                                  Container(
                                    width: double.infinity,
                                    child: TextButton(
                                      onPressed: regispasswordC.text ==
                                          regisconfirmPasswordC.text
                                          ? () =>authC.signUp(regisemailC.text,regispasswordC.text,"", "") // Add name and phoneNumber if needed
                                          : () {
                                        Get.snackbar("Error",
                                            "Password tidak sama");
                                      },
                                      child: Text("Register",
                                          style: TextStyle(
                                              color: Colors.white)),
                                      style: TextButton.styleFrom(
                                        backgroundColor: Color
                                            .fromRGBO(
                                            1, 130, 65, 1.0),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius
                                              .circular(6),
                                        ),
                                      ),),
                                  )
                                ],
                              ),
                            )
                            // Use Center for better visibility
                          ]),
                        ),
                      ],
                    ),
                  ),
                )
              ]
          ),
        )
        ),
      ),
    );
  }
}
