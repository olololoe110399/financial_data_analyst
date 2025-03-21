import 'dart:convert';
import 'package:anthropic_sdk_dart/anthropic_sdk_dart.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:mime/mime.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:uuid/uuid.dart';

import 'package:financial_data_analyst/configs/constants.dart';
import 'package:financial_data_analyst/modules/finance/services/finance_service.dart';
import 'package:financial_data_analyst/types/file_upload.dart';
import 'package:financial_data_analyst/types/message.dart';
import 'package:financial_data_analyst/types/toast.dart';
import 'package:financial_data_analyst/utils/file.dart';

@immutable
class ChatComposable {
  final uuid = Uuid();
  final financeService = FinanceService(
    client: AnthropicClient(apiKey: 'YOUR_API_KEY'),
  );

  final messagesController = ScrollController();

  final isLoading = Signal(false);
  final inputSignal = Signal('');
  final selectedModel = Signal(models.first);
  final isUploading = Signal(false);
  final currentUpload = Signal<FileUpload?>(null);
  final messages = ListSignal(<MyMessage>[]);
  final toast = Signal<Toast?>(null);
  Computed<bool> get isMessageEmpty => Computed(() => messages.isEmpty);
  Computed<bool> get hasChartDataComputed =>
      Computed(() => messages.any((msg) => msg.isChartNotNull));

  void addMessage(MyMessage message) {
    messages.add(message);
  }

  void updateLastMessage(MyMessage message) {
    messages[messages.length - 1] = message;
  }

  Future<void> handleFileSelect() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
      withData: true,
    );
    final file = result?.files.first;
    if (file == null) return;

    isUploading.set(true);

    final mimeType = lookupMimeType(file.name) ?? "";
    if (mimeType == "application/pdf") {
      toast.set(
        Toast(
          title: "Processing PDF",
          description: "Extracting text content...",
          duration: Duration(hours: 1),
        ),
      );
    }
    try {
      final fileUpload = await _processFile(file, mimeType);
      if (fileUpload == null) return;
      currentUpload.set(fileUpload);
    } catch (e) {
      toast.set(
        Toast(
          title: "Upload failed",
          description: "Failed to process the file",
          variant: ShadToastVariant.destructive,
        ),
      );
    } finally {
      isUploading.set(false);
      if (mimeType == "application/pdf") {
        toast.set(null);
        toast.set(
          Toast(
            title: "PDF Processed",
            description: "Text extracted successfully",
          ),
        );
      }
    }
  }

  Future<FileUpload?> _processFile(PlatformFile file, String mimeType) async {
    final bool isImage = mimeType.startsWith("image/");
    final bool isPdf = mimeType == "application/pdf";
    String base64Data = "";
    bool isText = false;

    if (isImage) {
      base64Data = base64Encode(file.bytes!);
    } else if (isPdf) {
      try {
        final pdfText = await readFileAsPDFTextIsolate(file.bytes);
        base64Data = base64Encode(utf8.encode(pdfText));
        isText = true;
      } catch (e) {
        toast.set(
          Toast(
            title: "PDF parsing failed",
            description: "Unable to extract text from the PDF",
            variant: ShadToastVariant.destructive,
          ),
        );
        return null;
      }
    } else {
      try {
        final text = await file.xFile.readAsString();
        base64Data = base64Encode(utf8.encode(text));
        isText = true;
      } catch (e) {
        debugPrint(e.toString());
        toast.set(
          Toast(
            title: "Invalid file type",
            description: "File must be readable as text, PDF, or be an image",
            variant: ShadToastVariant.destructive,
          ),
        );
        return null;
      }
    }
    return FileUpload(
      base64: base64Data,
      fileName: file.name,
      mediaType: isText ? "text/plain" : mimeType,
      isText: isText,
      fileSize: file.size,
    );
  }

  Future<void> handleSubmit() async {
    if (inputSignal.value.trim().isEmpty && currentUpload.value == null) {
      return;
    }
    if (isLoading.value) return;
    isLoading.set(true);
    MyMessage userMessage = MyMessage(
      id: uuid.v4(),
      role: "user",
      content: inputSignal.value,
      file: currentUpload.value,
    );
    MyMessage thinkingMessage = MyMessage(
      id: uuid.v4(),
      role: "assistant",
      content: "thinking",
    );
    addMessage(userMessage);
    final oldMessages = [...messages.value];
    addMessage(thinkingMessage);
    inputSignal.set('');
    isLoading.set(true);
    try {
      final apiMessages = oldMessages.map((msg) {
        final role =
            msg.role == "user" ? MessageRole.user : MessageRole.assistant;
        final file = msg.file;
        if (file == null) {
          return Message(content: MessageContent.text(msg.content), role: role);
        }
        if (file.isText) {
          final decodedText = utf8.decode(base64.decode(file.base64));
          return Message(content: MessageContent.text(decodedText), role: role);
        } else {
          return Message(
            content: MessageContent.blocks([
              Block.image(
                source: ImageBlockSource.fromJson({
                  "type": "base64",
                  "media_type": file.mediaType,
                  "data": file.base64,
                }),
              ),
              Block.text(text: msg.content),
            ]),
            role: role,
          );
        }
      });
      final data = await financeService.sendRequest(
        messages: apiMessages.toList(),
        model: selectedModel.value.model,
      );
      updateLastMessage(MyMessage.fromJson(uuid.v4(), data));
      currentUpload.value = null;
    } catch (e) {
      updateLastMessage(
        MyMessage(
          id: uuid.v4(),
          role: "assistant",
          content: "I apologize, but I encountered an error. Please try again.",
        ),
      );
    } finally {
      isLoading.set(false);
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (messagesController.hasClients) {
          messagesController.animateTo(
            messagesController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeOut,
          );
        }
      });
    }
  }

  void dispose() {
    isLoading.dispose();
    messagesController.dispose();
    selectedModel.dispose();
    isUploading.dispose();
    currentUpload.dispose();
    messages.dispose();
    toast.dispose();
    isMessageEmpty.dispose();
    hasChartDataComputed.dispose();
    inputSignal.dispose();
  }
}
