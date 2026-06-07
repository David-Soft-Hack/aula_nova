import 'dart:io';

abstract class IDocumentService {
  Future<String> get localPath;
  Future<File> getLocalFile(String fileName);
  Future<Directory> get documentsDir;
  Future<Directory> get bitacoraDocsDir;
  Future<File> saveDocument(String subfolder, String fileName, List<int> bytes);
  Future<File> saveBitacoraDocument(int bitacoraId, String fileName, List<int> bytes);
  Future<List<FileSystemEntity>> listDocuments({String? subfolder});
  Future<void> deleteDocument(String filePath);
  Future<void> deleteBitacoraDocuments(int bitacoraId);
}
