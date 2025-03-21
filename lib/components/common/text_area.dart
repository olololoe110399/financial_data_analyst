import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:shadcn_ui/shadcn_ui.dart';

class TextArea extends StatefulWidget {
  final Signal<String> inputSignal;

  const TextArea({super.key, required this.inputSignal});

  @override
  State<TextArea> createState() => _TextAreaState();
}

class _TextAreaState extends State<TextArea> {
  final editController = TextEditingController();

  @override
  void initState() {
    editController.text = widget.inputSignal.value;
    widget.inputSignal.observe((previousValue, value) {
      if (previousValue != value) {
        editController.text = value;
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    widget.inputSignal.dispose();
    editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ShadInput(
      controller: editController,
      placeholder: const Text('Type your message...'),
      minLines: 1,
      maxLines: 14,
      onChanged: (value) {
        widget.inputSignal.value = value;
      },
    );
  }
}
