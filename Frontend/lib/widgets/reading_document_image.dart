import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';

/// Retain decoded bytes across timer ticks and refreshed JSON responses.
/// A new Uint8List on every build changes MemoryImage identity and briefly
/// removes the image's height, which clamps the reading scroll position.
class ReadingDocumentImage extends StatefulWidget {
  const ReadingDocumentImage({super.key, this.encoded, this.url})
    : assert(encoded != null || url != null);
  final String? encoded;
  final String? url;

  @override
  State<ReadingDocumentImage> createState() => _ReadingDocumentImageState();
}

class _ReadingDocumentImageState extends State<ReadingDocumentImage> {
  Uint8List? bytes;

  @override
  void initState() {
    super.initState();
    if (widget.encoded != null) bytes = base64Decode(widget.encoded!);
  }

  @override
  void didUpdateWidget(covariant ReadingDocumentImage oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.encoded != widget.encoded) {
      bytes = widget.encoded == null ? null : base64Decode(widget.encoded!);
    }
  }

  @override
  Widget build(BuildContext context) => widget.url != null
      ? Image.network(
          widget.url!,
          gaplessPlayback: true,
          errorBuilder: (_, error, stack) =>
              const Text('Không hiển thị được ảnh.'),
        )
      : Image.memory(
          bytes!,
          gaplessPlayback: true,
          errorBuilder: (_, error, stack) =>
              const Text('Không hiển thị được ảnh.'),
        );
}
