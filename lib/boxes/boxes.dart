import 'package:hive_1/model/notes_model.dart';
import 'package:hive/hive.dart';

class Boxes {

  static Box<NotesModel> getData()=>Hive.box<NotesModel>('notes');
}