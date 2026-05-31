import 'dart:io';
import 'package:path_provider/path_provider.dart';

class DocumentService {
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> getLocalFile(String fileName) async {
    final path = await localPath;
    return File('$path/$fileName');
  }

  // Add methods to read/write documents here
}
