
import 'package:hive/hive.dart';
part'notes_model.g.dart';

////flutter packages pub run build_runner build
@HiveType(typeId: 0)
class NotesModel
{
@HiveField(0)
String title;
@HiveField(1)
String desc;

NotesModel({required this.title,required this.desc});
}