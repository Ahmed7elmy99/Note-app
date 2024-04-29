import 'package:flutter/material.dart';

import 'package:glass_login/components/cardnote.dart';
import 'package:glass_login/components/crud.dart';
import 'package:glass_login/constant/linkapi.dart';
import 'package:glass_login/main.dart';
import 'package:glass_login/model/notemodel.dart';
import 'package:glass_login/notes/add.dart';
import 'package:glass_login/notes/edit.dart';


class Home extends StatefulWidget {
const  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with Crud {
  bool isLoading = false;

  getNotes() async {
    var response =
        await postRequest(linkViewNotes, {"id": sharedPref.getString("id")});
    return response;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:const Text(
          "Home",
          style: TextStyle(color: Colors.white),
        ),
        actions: [
          IconButton(
              onPressed: () {
                sharedPref.clear();
                Navigator.of(context)
                    .pushNamedAndRemoveUntil("login", (route) => false);
              },
              icon:const Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ))
        ],
      ),
      floatingActionButton: ClipOval(
        child: FloatingActionButton(
          backgroundColor: Colors.blue,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNotes()),
            );
          },
          child:const Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading == true
          ?const Center(child: CircularProgressIndicator())
          : Container(
              padding:const EdgeInsets.all(10),
              child: ListView(
                children: [
                  FutureBuilder(
                      future: getNotes(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data['status'] == 'failure')
                            return  Center(
                                child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "لا يوجد ملاحظات",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ));
                          return ListView.builder(
                              itemCount: snapshot.data['data'].length,
                              shrinkWrap: true,
                              physics:const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, i) {
                                return CardNotes(
                                    onDelete: () async {
                                      var response =
                                          await postRequest(linkDeleteNotes, {
                                        "id": snapshot.data['data'][i]
                                                ['notes_id']
                                            .toString(),
                                        "imagename": snapshot.data['data'][i]
                                                ['notesimage']
                                            .toString()
                                      });
                                      if (response['status'] == "success") {
                                        setState(() {});
                                        //  Navigator.push(
                                        // context,
                                        // MaterialPageRoute(builder: (context) => Home()),
                                        // );
                                      }
                                    },
                                    ontap: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) => EditNotes(
                                                  notes: snapshot.data['data']
                                                      [i])));
                                    },
                                    notemodel: NoteModel.fromJson(
                                        snapshot.data['data'][i]));
                              });
                        }
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(child: Text("Loading ..."));
                        }
                        return const Center(child: Text("Loading ..."));
                      })
                ],
              ),
            ),
    );
  }
}
