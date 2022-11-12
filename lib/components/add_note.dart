import 'package:flutter/material.dart';

import '../models/sql_db.dart';

class AddNote extends StatefulWidget {
  String? title;
  String? body;
  int? id;
  bool isUpdate = false;
  AddNote({Key? key}) : super(key: key);
  AddNote.update(
      {this.title, this.body, this.id, this.isUpdate = true, Key? key})
      : super(key: key);

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  final _formKey = GlobalKey<FormState>();
  bool canSave = false;
  bool saved = false;
  SQLDB db = SQLDB();
  Map<String, String> note = {'title': '', 'body': ''};
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
              actions: [
                if (widget.id != null)
                  IconButton(
                      onPressed: () async{
                        await db.deleteData(widget.id!);
                        Navigator.of(context).pop("added");
                      },  
                      icon: const Icon(Icons.delete_outline_rounded)),
                if (canSave)
                  IconButton(
                      onPressed: () {
                        _formKey.currentState!.save();
                        FocusManager.instance.primaryFocus?.unfocus();
                        if (widget.isUpdate) {
                          db.updateData(widget.id as int,
                              note['title'] as String, note['body'] as String);
                        } else {
                          db.insertData(
                              note['title'] as String, note['body'] as String);
                        }
                        saved = true;
                      },
                      icon: const Icon(
                        Icons.save_alt_rounded,
                        size: 30,
                      )),
              ],
              backgroundColor: Colors.black,
              leading: IconButton(
                  onPressed: () {
                    if (saved) {
                      Navigator.of(context).pop("added");
                    } else {
                      Navigator.of(context).pop("cancle");
                    }
                  },
                  icon: const Icon(Icons.arrow_back_ios_new))),
          backgroundColor: Colors.black,
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  TextFormField(
                    initialValue: widget.title,
                    onSaved: ((newValue) => note['title'] = newValue as String),
                    onChanged: ((value) {
                      note['title'] = value;
                      if (note['title']!.isNotEmpty ||
                          note['body']!.isNotEmpty) {
                        canSave = true;
                        setState(() {});
                      } else {
                        canSave = false;
                        setState(() {});
                      }
                    }),
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    cursorColor: Colors.transparent,
                    maxLines: 1,
                    decoration: const InputDecoration(
                      hintText: "Title",
                      hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                      border: InputBorder.none,
                    ),
                  ),
                  const Divider(color: Colors.grey, height: 0),
                  Expanded(
                    child: ListView(
                      children: [
                        TextFormField(
                          initialValue: widget.body,
                          onSaved: ((newValue) =>
                              note['body'] = newValue as String),
                          onChanged: ((value) {
                            note['body'] = value;
                            if (note['title']!.isNotEmpty ||
                                note['body']!.isNotEmpty) {
                              canSave = true;
                              setState(() {});
                            } else {
                              canSave = false;
                              setState(() {});
                            }
                          }),
                          cursorColor: Colors.grey,
                          keyboardType: TextInputType.multiline,
                          maxLines: 27,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 20),
                          decoration:
                              const InputDecoration(border: InputBorder.none),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
