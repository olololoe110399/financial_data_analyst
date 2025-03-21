import 'dart:convert';
import 'dart:typed_data';

import 'package:financial_data_analyst/types/file_upload.dart';
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

enum FilePreviewSize { small, large }

class FilePreview extends StatelessWidget {
  final FileUpload file;
  final VoidCallback? onRemove;
  final FilePreviewSize size;

  const FilePreview({
    super.key,
    required this.file,
    this.onRemove,
    this.size = FilePreviewSize.large,
  });

  @override
  Widget build(BuildContext context) {
    final theme = ShadTheme.of(context);
    final bool isImage = file.mediaType.startsWith('image/');
    final Uint8List? imageBytes =
        isImage ? _decodeImageBytes(file.base64) : null;
    final String truncatedName = _getTruncatedFileName(file.fileName);
    final String fileExtension = _getFileExtension(file.fileName);

    return size == FilePreviewSize.small
        ? _buildSmallPreview(theme, isImage, imageBytes, truncatedName)
        : _buildLargePreview(theme, isImage, imageBytes, fileExtension);
  }

  Uint8List? _decodeImageBytes(String base64String) {
    try {
      return base64Decode(base64String);
    } catch (_) {
      return null;
    }
  }

  String _getTruncatedFileName(String fileName) {
    if (fileName.length <= 7) return fileName;
    final int extIndex = fileName.lastIndexOf('.');
    if (extIndex == -1) return fileName;
    return '${fileName.substring(0, 7)}...${fileName.substring(extIndex)}';
  }

  String _getFileExtension(String fileName) {
    return fileName.split('.').last.toLowerCase();
  }

  Widget _buildSmallPreview(
    ShadThemeData theme,
    bool isImage,
    Uint8List? imageBytes,
    String truncatedName,
  ) {
    return ShadCard(
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      radius: BorderRadius.circular(4),
      backgroundColor: theme.secondaryButtonTheme.backgroundColor,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          isImage && imageBytes != null
              ? ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: Image.memory(
                  imageBytes,
                  width: 16,
                  height: 16,
                  fit: BoxFit.cover,
                ),
              )
              : const Icon(Icons.description, size: 16),
          const SizedBox(width: 4),
          Text(truncatedName, style: const TextStyle(fontSize: 10)),
        ],
      ),
    );
  }

  Widget _buildLargePreview(
    ShadThemeData theme,
    bool isImage,
    Uint8List? imageBytes,
    String fileExtension,
  ) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        ShadCard(
          width: 64,
          height: 64,
          padding: EdgeInsets.zero,
          rowMainAxisAlignment: MainAxisAlignment.center,
          rowCrossAxisAlignment: CrossAxisAlignment.center,
          backgroundColor:
              isImage && imageBytes != null
                  ? Colors.transparent
                  : theme.secondaryButtonTheme.backgroundColor,
          child:
              isImage && imageBytes != null
                  ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.memory(
                      imageBytes,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    ),
                  )
                  : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.description, size: 24),
                      const SizedBox(height: 4),
                      Text(
                        fileExtension.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
        ),
        if (onRemove != null)
          Positioned(
            top: -8,
            right: -8,
            child: ShadBadge.destructive(
              padding: const EdgeInsets.all(4),
              onPressed: onRemove!,
              shape: ShapeBorder.lerp(
                const CircleBorder(),
                const CircleBorder(),
                0,
              ),
              child: const Icon(Icons.close, size: 12, color: Colors.white),
            ),
          ),
      ],
    );
  }
}
