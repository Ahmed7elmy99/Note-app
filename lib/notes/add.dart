import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';

import 'package:flutter/material.dart';
import 'package:glass_login/components/crud.dart';
import 'package:glass_login/components/customtextform.dart';
import 'package:glass_login/components/valid.dart';
import 'package:glass_login/constant/linkapi.dart';

import 'package:glass_login/main.dart';

import 'package:image_picker/image_picker.dart';

class AddNotes extends StatefulWidget {
  AddNotes({Key? key}) : super(key: key);

  @override
  State<AddNotes> createState() => _AddNotesState();
}

class _AddNotesState extends State<AddNotes> with Crud {
  File? myfile;
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  TextEditingController title = TextEditingController();
  TextEditingController content = TextEditingController();

  bool isLoading = false;

  addNotes() async {
    if (myfile == null)
      return AwesomeDialog(
          context: context,
          title: "هام",
          body: Text("الرجاء اضافة الصورة الخاصة بالملاحظة"))
        ..show();
    if (formstate.currentState!.validate()) {
      isLoading = true;
      setState(() {});
      var response = await postRequestWithFile(
          linkAddNotes,
          {
            "title": title.text,
            "content": content.text,
            "id": sharedPref.getString("id")
          },
          myfile!);
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.white,
            )),
        backgroundColor: Colors.blue,
        title: const Text(
          "Add Notes",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(10),
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
                            builder: (context) => Container(
                                height: 160,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
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
                                        padding: EdgeInsets.all(10),
                                        child: const Text(
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
                                        padding: const EdgeInsets.all(10),
                                        child: const Text(
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
                      child: const Text("Choose Image"),
                    ),
                    Container(height: 20),
                    MaterialButton(
                      onPressed: () async {
                        await addNotes();
                      },
                      textColor: Colors.white,
                      color: Colors.blue,
                      child: const Text("Add"),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}
