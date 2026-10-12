import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Retain decoded bytes across timer ticks and refreshed JSON responses.
/// A new Uint8List on every build changes MemoryImage identity and briefly
/// removes the image's height, which clamps the reading scroll position.
class ReadingDocumentImage extends StatefulWidget {
  const ReadingDocumentImage({super.key, required this.encoded});
  final String encoded;

  @override
  State<ReadingDocumentImage> createState() => _ReadingDocumentImageState();
}

class _ReadingDocumentImageState extends State<ReadingDocumentImage> {
  late Uint8List bytes;

  @override
  void initState() {
    super.initState();
    bytes = base64Decode(widget.encoded);
  }

  @override
  void didUpdateWidget(covariant ReadingDocumentImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.encoded != widget.encoded) {
      bytes = base64Decode(widget.encoded);
    }
  }

  @override
  Widget build(BuildContext context) => Image.memory(
    bytes,
    gaplessPlayback: true,
    errorBuilder: (_, error, stack) => const Text('Không hiển thị được ảnh.'),
  );
}
