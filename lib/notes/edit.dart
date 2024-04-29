import 'dart:io';

import 'package:flutter/material.dart';
import 'package:glass_login/components/crud.dart';
import 'package:glass_login/components/customtextform.dart';
import 'package:glass_login/components/valid.dart';
import 'package:glass_login/constant/linkapi.dart';

import 'package:image_picker/image_picker.dart';

class EditNotes extends StatefulWidget {
  final notes;
  EditNotes({Key? key, this.notes}) : super(key: key);

  @override
  State<EditNotes> createState() => _EditNotesState();
}

class _EditNotesState extends State<EditNotes> with Crud {
  File? myfile;

  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  bool isLoading = false;

  editNotes() async {
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response;

      if (myfile == null) {
        response = await postRequest(linkEditNotes, {
          "title": title.text,
          "content": content.text,
          "id": widget.notes['notes_id'].toString(),
          "imagename": widget.notes['notesimage'].toString(),
        });
      } else {
        response = await postRequestWithFile(
            linkEditNotes,
            {
              "title": title.text,
              "content": content.text,
              "imagename": widget.notes['notesimage'].toString(),
              "id": widget.notes['notes_id'].toString()
            },
            myfile!);
      }

      isLoading = false;
      setState(() {});
      if (response['status'] == "success") {
        Navigator.of(context).pushNamedAndRemoveUntil("home", (route) => false);
      } else {
        //
      }
    }
  }

  @override
  void initState() {
    title.text = widget.notes['notes_title'];
    content.text = widget.notes['notes_content'];
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title:const Text(
          "Edit Notes",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading == true
          ?const Center(child: CircularProgressIndicator())
          : Container(
              padding:const EdgeInsets.all(10),
              child: Form(
                key: formstate,
                child: ListView(
                  children: [
                    CustTextFormSign(
                        hint: "title",
                        mycontroller: title,
                        valid: (val) {
                          return validInput(val!, 1, 40);
                        }),
                    CustTextFormSign(
                        hint: "content",
                        mycontroller: content,
                        valid: (val) {
                          return validInput(val!, 10, 255);
                        }),
                    Container(height: 20),
                    MaterialButton(
                      onPressed: () {
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => SizedBox(
                                height: 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                  const  Padding(
                                      padding:  EdgeInsets.all(8.0),
                                      child: Text("Please Choose Image",
                                          style: TextStyle(fontSize: 22)),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        XFile? xfile = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        Navigator.of(context).pop();
                                        myfile = File(xfile!.path);
                                        setState(() {});
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding:const EdgeInsets.all(10),
                                        child:const Text(
                                          "From Gallery",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        XFile? xfile = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.camera);
                                        Navigator.of(context).pop();

                                        myfile = File(xfile!.path);
                                        setState(() {});
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        width: double.infinity,
                                        padding:const EdgeInsets.all(10),
                                        child:const Text(
                                          "From Camera",
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ),
                                    )
                                  ],
                                )));
                      },
                      textColor: Colors.white,
                      color: myfile == null ? Colors.blue : Colors.green,
                      child:const Text("Choose Image"),
                    ),
                    MaterialButton(
                      onPressed: () async {
                        await editNotes();
                      },
                      textColor: Colors.white,
                      color: Colors.blue,
                      child:const Text("Save"),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
