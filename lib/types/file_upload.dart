class FileUpload {
  final String base64;
  final String fileName;
  final String mediaType;
  final bool isText;
  final int? fileSize;

  FileUpload({
    required this.base64,
    required this.fileName,
    required this.mediaType,
    this.isText = false,
    this.fileSize,
  });
}
