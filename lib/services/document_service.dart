import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../interfaces/services/i_document_service.dart';

class DocumentService implements IDocumentService {
  @override
  Future<String> get localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  @override
  Future<File> getLocalFile(String fileName) async {
    final path = await localPath;
    return File('$path/$fileName');
  }

  @override
  Future<Directory> get documentsDir async {
    final path = await localPath;
    final dir = Directory('$path/documentos');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  @override
  Future<Directory> get bitacoraDocsDir async {
    final path = await localPath;
    final dir = Directory('$path/documentos/bitacoras');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  @override
  Future<File> saveDocument(String subfolder, String fileName, List<int> bytes) async {
    final path = await localPath;
    final dir = Directory('$path/documentos/$subfolder');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    final file = File('${dir.path}/$fileName');
    return file.writeAsBytes(bytes);
  }

  @override
  Future<File> saveBitacoraDocument(int bitacoraId, String fileName, List<int> bytes) async {
    return saveDocument('bitacoras/$bitacoraId', fileName, bytes);
  }

  @override
  Future<List<FileSystemEntity>> listDocuments({String? subfolder}) async {
    final path = await localPath;
    final dir = Directory(subfolder != null
        ? '$path/documentos/$subfolder'
        : '$path/documentos');
    if (!await dir.exists()) return [];
    return dir.list().toList();
  }

  @override
  Future<void> deleteDocument(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
    }
  }

  @override
  Future<void> deleteBitacoraDocuments(int bitacoraId) async {
    final path = await localPath;
    final dir = Directory('$path/documentos/bitacoras/$bitacoraId');
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }
}
