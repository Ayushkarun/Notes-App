// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:hive_1/model/notes_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'boxes/boxes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notepad'),
        backgroundColor: Colors.blue,
      ),
      body: ValueListenableBuilder<Box<NotesModel>>(
        valueListenable: Boxes.getData().listenable(),
        builder: (context, box, _) {
          var data = box.values.toList().cast<NotesModel>();
          return ListView.builder(
              itemCount: box.length,
              reverse: true,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 15,
                      horizontal: 10,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              data[index].title.toString(),
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w500),
                            ),
                            Spacer(),
                            InkWell(
                                onTap: () {
                                  delete(data[index]);
                                },
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                )),
                            SizedBox(
                              width: 10,
                            ),
                            InkWell(
                              onTap: () {
                                _editDialog(data[index], 
                                data[index].title.toString(),
                                 data[index].desc.toString());
                              },
                              child: Icon(Icons.edit)),
                          ],
                        ),
                        Text(
                          data[index].desc.toString(),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showMyDialog();
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void delete(NotesModel notesModel) async {
    await notesModel.delete();
  }

    Future<void> _editDialog(NotesModel notesModel,
    String title,
    String desc) async {

      titleController.text=title;
      descriptionController.text=desc;
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('edit note'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: 'Enter Title', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: 'Enter desc', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel')),
              TextButton(
                  onPressed: () {
                    notesModel.title=titleController.text.toString();
                    notesModel.desc=descriptionController.text.toString();
                    notesModel.save();

                    titleController.clear();
                    descriptionController.clear();

                    Navigator.pop(context);
                  },
                  child: Text('edit')),
            ],
          );
        }
        );
  }

  Future<void> _showMyDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('add note'),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  TextFormField(
                    controller: titleController,
                    decoration: InputDecoration(
                        hintText: 'Enter Title', border: OutlineInputBorder()),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                        hintText: 'Enter desc', border: OutlineInputBorder()),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('cancel')),
              TextButton(
                  onPressed: () {
                    final data = NotesModel(
                        title: titleController.text,
                        desc: descriptionController.text);
                    final box = Boxes.getData();
                    box.add(data);
                    //data.save();

                    print(box);

                    titleController.clear();
                    descriptionController.clear();

                    Navigator.pop(context);
                  },
                  child: Text('add')),
            ],
          );
        }
        );
  }
}
