import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import 'package:resume_builder/auth/auth_provider.dart'; // Import the AuthProvider class
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:resume_builder/auth/auth_provider.dart';
import 'package:provider/provider.dart';


class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late Future<String?> userIdFuture;

  @override
  void initState() {
    super.initState();
    userIdFuture = getUserIdFromToken();
  }

  Future<String?> getUserIdFromToken() async {
    final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
    print(userIdFuture);
    return _secureStorage.read(key: 'userId');
  }


  PreferredSizeWidget? buildAppBar() {
    return PreferredSize(
      preferredSize: Size.fromHeight(kToolbarHeight),
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return AppBar(
            title: RichText(
              text: TextSpan(
                text: 'Resem',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                children: [
                  TextSpan(
                    text: 'U',
                    style: TextStyle(
                      color: Colors.orange,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.grey,
            actions: [
              if (authProvider.isLoggedIn)
                IconButton(
                  icon: Icon(Icons.logout),
                  onPressed: () => logout(), // Call the logout method
                ),
            ],
          );
        },
      ),
    );
  }

  void logout() {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    authProvider.logout();
    Navigator.pushNamedAndRemoveUntil(context, '/login_screen', (route) => false);
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: Center(
        child: FutureBuilder<String?>(
          future: getUserIdFromToken(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final userId = snapshot.data;
              return Stack(
                children: [
                  Positioned.fill(
                    child: Opacity(
                      opacity: 0.5,
                      child: Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage('assets/homepic.jpg'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Transform.translate(
                        offset: Offset(0, -140),
                        child: RichText(
                          text: TextSpan(

                            children: [
                              TextSpan(
                                style: TextStyle(fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.deepPurple),
                                text: 'Welcome to Resem',
                              ),
                              TextSpan(
                                text: 'U',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 200.0,
                          left: 180,
                          right: 50,
                          top: 150,
                        ),
                        child: SizedBox(
                          width: 220,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/builder',
                                arguments: {'userId': userId},
                              );
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                'Create\nResume',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple,
                              shape: StadiumBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),

                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          bottom: 200.0,
                          right: 220,
                          left: 20,
                          top: 150,
                        ),
                        child: SizedBox(
                          width: 150,
                          height: 64,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                context,
                                '/user_resumes',
                                arguments: {'userId': userId},
                              );
                            },
                            child: Text(
                              'My\nResumes',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              primary: Colors.deepPurple,
                              shape: StadiumBorder(),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
      backgroundColor: Colors.grey,
    );
  }
}

//   Widget build(BuildContext context) {
//     final authProvider = Provider.of<AuthProvider>(context);
//
//     // String userId ='64394c93b69525deada7c087';
//     return Scaffold(
//       appBar: AppBar(
//         title: RichText(
//           text: TextSpan(
//             text: 'Resem',
//             style: TextStyle(
//               color: Colors.black,
//               fontSize: 22,
//               fontWeight: FontWeight.bold,
//             ),
//             children: [
//               TextSpan(
//                 text: 'U',
//                 style: TextStyle(
//                   color: Colors.orange,
//                   fontSize: 22,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               TextSpan(
//
//                 text:
//                   'Logged In: ${authProvider.isLoggedIn}',
//                 ),
//
//
//
//
//             ],
//           ),
//         ),
//
//         backgroundColor: Colors.grey,
//
//       ),
//       body: Center(
//         child: Stack(
//           children: [
//
//             Positioned.fill(
//               child: Opacity(
//                 opacity: 0.5, // set the opacity value between 0.0 and 1.0
//                 child: Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/homepic.jpg'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Transform.translate(
//                   offset: Offset(0, -140), // adjust the y-offset value as needed
//                   child: RichText(
//                     text: TextSpan(
//
//                       children: [
//                         TextSpan(
//                           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.deepPurple),
//                           text: 'Welcome to Resem',
//                         ),
//                         TextSpan(
//                           text: 'U',
//                           style: TextStyle(
//                             color: Colors.orange,
//                             fontSize: 22,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//
//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 200.0, left: 200,right:20,top:150),
//                   child: SizedBox(
//                     width: 220,
//                     height: 64,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pushNamed(
//                         context,
//                         '/builder',
//                         arguments: {'userId': userId},
//                       );
//                         },
//                       child: Text(
//                         'Create Resume',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.deepPurple,
//                         shape: StadiumBorder(),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             Positioned.fill(
//               child: Align(
//                 alignment: Alignment.center,
//                 child: Padding(
//                   padding: const EdgeInsets.only(bottom: 200.0, right: 200,left:20,top:150),
//                   child: SizedBox(
//                     width: 150,
//                     height: 64,
//                     child: ElevatedButton(
//                       onPressed: () {
//                         Navigator.pushNamed(
//                           context,
//                           '/user_resumes',
//                           arguments: {'userId': userId},
//                         );
//
//
//                       },
//                       child: Text(
//                         'My Resumes',
//                         style: TextStyle(
//                           fontSize: 20,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         primary: Colors.deepPurple,
//                         shape: StadiumBorder(),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       backgroundColor: Colors.grey,
//     );
//   }
// }
