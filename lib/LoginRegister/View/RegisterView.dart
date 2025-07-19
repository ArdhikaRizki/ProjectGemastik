import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:project_gemastik/firebase_options.dart';
import '../Controlller/SignInUpController.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized(); // Required before Firebase.initializeApp()
  await Firebase.initializeApp( // Await the initialization
    options: DefaultFirebaseOptions.currentPlatform, // Use the auto-generated options
  );
  runApp(Registerview());
}

class Registerview extends StatelessWidget {
  final emailC = TextEditingController();
  final passwordC = TextEditingController();
  final confirmPasswordC = TextEditingController();
  final authC = Get.put(SignInUpController(), permanent: true);
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: authC.streamAuthStatus,
        builder: (context, snapshot) {
          print(snapshot);
          if (snapshot.connectionState == ConnectionState.active) {
            return GetMaterialApp(
                debugShowCheckedModeBanner: false,
                home: Scaffold(
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
                                        Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              SizedBox(height: 20,),
                                              Text("Sign In", style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,),),
                                              SizedBox(height: 40,),
                                              TextField(
                                                controller: emailC,
                                                decoration: InputDecoration(
                                                  border: OutlineInputBorder(),
                                                  labelText: 'Email',
                                                ),
                                              ),
                                              SizedBox(height: 20,),
                                              TextField(
                                                controller: passwordC,
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
                                                      authC.signIn(emailC.text,
                                                          passwordC.text),
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
                                        // Use Center for better visibility
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment
                                              .start,
                                          children: [
                                            SizedBox(height: 20,),
                                            Text("Sign Up", style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,),),
                                            SizedBox(height: 40,),
                                            TextField(
                                              controller: emailC,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Email',
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            TextField(
                                              controller: passwordC,
                                              obscureText: true,
                                              decoration: InputDecoration(
                                                border: OutlineInputBorder(),
                                                labelText: 'Password',
                                              ),
                                            ),
                                            SizedBox(height: 20,),
                                            TextField(
                                              controller: confirmPasswordC,
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
                                                onPressed: passwordC.text ==
                                                    confirmPasswordC.text
                                                    ? () =>authC.signUp(emailC.text,passwordC.text)
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
                )
            );
          }
          return CircularProgressIndicator();

        }


    );
  }
}
