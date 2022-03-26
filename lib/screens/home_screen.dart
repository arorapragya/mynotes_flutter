import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:newnotes/model/user_model.dart';
import 'package:newnotes/screens/addnote_screen.dart';
import 'package:newnotes/screens/login_screen.dart';
import 'package:newnotes/screens/viewnote_screen.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  User? user = FirebaseAuth.instance.currentUser;
  UserModel loggedInUser = UserModel();

  @override
  void initState() {
    super.initState();
    FirebaseFirestore.instance
        .collection("users")
        .doc(user!.uid)
        .get()
        .then((value) {
      this.loggedInUser = UserModel.fromMap(value.data());
      setState(() {});
    });
  }

  CollectionReference ref = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('notes');

  List myColors = [
    Colors.tealAccent[200],
    Colors.yellow[200],
    Colors.red[200],
    Colors.deepPurple[200],
    Colors.green[200],
    Colors.pink[200],
    Colors.cyan[200],
    Colors.purple[200],
    Colors.teal[200],
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context)
              .push(
            MaterialPageRoute(
              builder: (context) => AddNote(),
            ),
          )
              .then((value) {
            print("Calling Set  State !");
            setState(() {});
          });
        },
        child: Icon(
          Icons.add,
          color: Colors.white70,
        ),
        backgroundColor: Colors.grey[700],
      ),
      //
      appBar: AppBar(
        title: Text(
          "Notes",
          style: TextStyle(
            fontSize: 32.0,
            fontFamily: "lato",
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.logout_rounded,
              color: Colors.white,
            ),
            onPressed: () {
              logout(context);
            },
          )
        ],
        elevation: 100.0,
        backgroundColor: Colors.white12,
      ),
      //
      body: FutureBuilder<QuerySnapshot>(
        future: ref.get(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data.docs.length == 0) {
              return Center(
                child: Text(
                  "Add a note!",
                  style: TextStyle(
                    fontSize: 32.0,
                    fontFamily: "lato",
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
              );
            }

            return ListView.builder(
              itemCount: snapshot.data.docs.length,
              itemBuilder: (context, index) {
                Random random = new Random();
                Color bg = myColors[index];
                Map data = snapshot.data!.docs[index].data();
                DateTime mydateTime = data['created'].toDate();
                String formattedTime =
                    DateFormat.yMMMd().add_jm().format(mydateTime);

                return InkWell(
                  onTap: () {
                    Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => ViewNote(
                          data,
                          formattedTime,
                          snapshot.data.docs[index].reference,
                        ),
                      ),
                    )
                        .then((value) {
                      setState(() {});
                    });
                  },
                  child: Card(
                    color: bg,
                    child: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${data["title"]}",
                            style: TextStyle(
                              fontSize: 24.0,
                              fontFamily: "lato",
                              fontWeight: FontWeight.bold,
                              color: Colors.black87,
                            ),
                          ),
                          //
                          Container(
                            alignment: Alignment.centerRight,
                            child: Text(
                              formattedTime,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontFamily: "lato",
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text("Loading..."),
            );
          }
        },
      ),
    );
  }


Future<void> logout(BuildContext context) async {
  await FirebaseAuth.instance.signOut();
  Navigator.of(context)
      .pushReplacement(MaterialPageRoute(builder: (context) => LoginScreen()));
}
}
//   Widget build(BuildContext context) {
//      return Scaffold(
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){
//           Navigator.of(context).push(
//             MaterialPageRoute(builder: (context) => AddNote(),
//             ),
//           );
//         },
//         child: Icon(
//           Icons.add,
//           color: Colors.white,
//         ),
//         backgroundColor: Colors.grey[700],
//        ),

//        appBar: AppBar(
//         title: Text(
//           "Notes",
//           style: TextStyle(
//             fontSize: 32.0,
//             fontFamily: "lato",
//             fontWeight: FontWeight.bold,
//             color: Colors.white70,
//           ),
//         ),
//         elevation: 0.0,
//         backgroundColor: Color(0xff070706),
//       ),
//       // body:FutureBuilder<QuerySnapshot>(
//       //   future : ref.get(),
//       //   builder: (context, snapshot) {
//       //     if(snapshot.hasData){
//       //     return ListView.builder(
//       //       itemCount:snapshot.data.docs.length ,
//       //       itemBuilder: (BuildContext context, int index){
//       //       Random random = new Random();
//       //       Color bg = myColors[random.nextInt(4)];
//       //       Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//       //         return Card(
//       //           child: Column(
//       //             children: [
//       //               Text(
//       //                 "${data['title']}",
//       //                 ),
//       //             ],

//       //           ),
//       //           );
//       //       }

//       //     );
//       //   }else{
//       //     return Center(
//       //       child: Text("Loading..."),
//       //     );
//       //   }
//       //   },
//       //   ),
//       body: StreamBuilder(
//         stream: FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser?.uid).collection('notes').snapshots(),
//         builder: (context,snapshot){
//           if(snapshot.hasData){
//             return ListView.builder(
//               shrinkWrap: true,
//               itemCount:snapshot.data!.notes.length,
//               itemBuilder: (context,index){
//               Random random = new Random();
//               Color bg = myColors[random.nextInt(4)];
//               DocumentSnapshot documentSnapshot = snapshot.data.docs[index];
//             // Map<String, dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
//               return Card(
//                 child: Column(
//                   children: [
//                     Text(documentSnapshot
//                       ['title'],
//                       ),
//                   ],

//                 ),
//                 );
//             }

//           );
//         }else{
//           return Center(
//             child: Text("Loading..."),
//           );
//         }
//         },
//         ),
//      );
//   }
// }

