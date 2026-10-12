import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'widgets/reading_document_image.dart';

void main() => runApp(const ReadingApp());

class ReadingApp extends StatelessWidget {
  const ReadingApp({super.key});
  @override
  Widget build(BuildContext c) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'TOEIC Reading',
    theme: ThemeData(
      useMaterial3: true,
      fontFamily: 'DM Sans',
      colorScheme: ColorScheme.fromSeed(
        seedColor: const Color(0xff087f69),
        primary: const Color(0xff087f69),
        primaryContainer: const Color(0xffe7f0e8),
        onSurface: const Color(0xff142d32),
        surface: Colors.white,
      ),
      scaffoldBackgroundColor: const Color(0xfff6f7f4),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.white,
        foregroundColor: Color(0xff142d32),
        elevation: 0,
        centerTitle: false,
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          side: const BorderSide(color: Color(0xffdfe5df)),
          minimumSize: const Size(48, 52),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          minimumSize: const Size(48, 52),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    ),
    home: const ReadingHome(),
  );
}

class ReadingHome extends StatefulWidget {
  const ReadingHome({super.key});
  @override
  State<ReadingHome> createState() => _Home();
}

class _Home extends State<ReadingHome> with WidgetsBindingObserver {
  final server = TextEditingController(
    text: const String.fromEnvironment(
      'API_URL',
      defaultValue: 'http://10.0.2.2:5100',
    ),
  );
  final secure = const FlutterSecureStorage();
  SharedPreferences? prefs;
  String? sessionKey, error;
  List<dynamic> exams = [];
  Map<String, dynamic>? attempt, result;
  final Map<int, String?> selected = {}, pending = {};
  bool busy = false, syncing = false, warned = false;
  int index = 0, seconds = 4500, documentIndex = 0;
  String search = '', reviewFilter = 'Tất cả';
  bool showReading = false;
  DateTime? serverAt;
  final elapsed = Stopwatch();
  Timer? timer, poll;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    guard(restore);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    timer?.cancel();
    poll?.cancel();
    server.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState s) {
    if (s == AppLifecycleState.resumed) refresh();
  }

  Future<void> restore() async {
    prefs = await SharedPreferences.getInstance();
    server.text = prefs!.getString('server') ?? server.text;
    sessionKey = await secure.read(key: 'readingSession');
    if (sessionKey == null) {
      final random = Random.secure();
      sessionKey = List.generate(
        32,
        (_) => random.nextInt(256).toRadixString(16).padLeft(2, '0'),
      ).join();
      await secure.write(key: 'readingSession', value: sessionKey);
    }
    {
      await load();
      final id = prefs!.getString('attempt');
      if (id != null) {
        await guard(() async {
          final raw = prefs!.getString('pending');
          if (raw != null) {
            (jsonDecode(raw) as Map).forEach(
              (k, v) => pending[int.parse(k)] = v,
            );
          }
          accept(await api('GET', 'attempts/$id'));
          if (attempt!['status'] == 'inProgress') {
            await sync();
          } else {
            await showResult();
          }
        });
      }
    }
    if (mounted) setState(() {});
  }

  Future<dynamic> api(String method, String path, [Object? body]) async {
    final req =
        http.Request(
            method,
            Uri.parse(
              '${server.text.trim().replaceAll(RegExp(r'/$'), '')}/api/reading/$path',
            ),
          )
          ..headers.addAll({
            'Content-Type': 'application/json',
            'X-Reading-Session': ?sessionKey,
          });
    if (body != null) req.body = jsonEncode(body);
    final r = await http.Response.fromStream(
      await req.send().timeout(const Duration(seconds: 45)),
    );
    dynamic j;
    try {
      j = jsonDecode(r.body);
    } catch (_) {
      throw Exception('Máy chủ không trả dữ liệu hợp lệ.');
    }
    if (r.statusCode >= 400 || j is Map && j['success'] == false) {
      throw Exception(
        j is Map
            ? (j['error']?['message'] ?? 'Yêu cầu thất bại.')
            : 'Yêu cầu thất bại.',
      );
    }
    return j is Map && j.containsKey('result') ? j['result'] : j;
  }

  Future<void> guard(Future<void> Function() fn) async {
    if (mounted) {
      setState(() {
        busy = true;
        error = null;
      });
    }
    try {
      await fn();
    } catch (e) {
      if (mounted) {
        setState(
          () => error = e is TimeoutException
              ? 'Máy chủ phản hồi chậm. Vui lòng thử lại.'
              : e.toString().replaceFirst('Exception: ', ''),
        );
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  Future<void> load() async {
    try {
      final data = await api('GET', 'exams');
      if (mounted) setState(() => exams = data as List);
    } catch (e) {
      if (mounted) {
        setState(
          () => error = 'Không tải được thư viện. Kiểm tra kết nối máy chủ.',
        );
      }
    }
  }

  List<dynamic> get questions => attempt == null
      ? []
      : (attempt!['exam']['parts'] as List)
            .expand((p) => p['questions'] as List)
            .toList();
  DateTime utc(String v) =>
      DateTime.parse(v.endsWith('Z') ? v : '${v}Z').toUtc();
  void accept(dynamic data) {
    attempt = Map<String, dynamic>.from(data);
    serverAt = utc(attempt!['serverNow']);
    elapsed
      ..reset()
      ..start();
    selected.clear();
    for (final a in attempt!['answers']) {
      selected[a['number']] = a['letter'];
    }
    pending.forEach((k, v) => selected[k] = v);
    timer ??= Timer.periodic(const Duration(seconds: 1), (_) => tick());
    poll ??= Timer.periodic(const Duration(seconds: 15), (_) => refresh());
    tick();
    if (mounted) setState(() {});
  }

  void tick() {
    if (attempt == null || serverAt == null) return;
    final left = utc(attempt!['deadline'])
        .difference(serverAt!.add(elapsed.elapsed))
        .inSeconds;
    if (mounted) setState(() => seconds = left.clamp(0, 4500));
    if (left <= 300 &&
        left > 0 &&
        !warned &&
        attempt!['status'] == 'inProgress') {
      warned = true;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Bạn còn 5 phút. Kiểm tra câu chưa trả lời.'),
          ),
        );
      }
    }
    if (left <= 0 && attempt!['status'] == 'inProgress' && !syncing && !busy) {
      autoSubmit();
    }
  }

  Future<void> persist() async {
    await prefs?.setString(
      'pending',
      jsonEncode(pending.map((k, v) => MapEntry(k.toString(), v))),
    );
  }

  Future<void> choose(int n, String? v) async {
    if (seconds == 0 || attempt!['status'] != 'inProgress') return;
    setState(() {
      selected[n] = v;
      pending[n] = v;
    });
    await persist();
    await sync();
  }

  Future<void> sync() async {
    if (syncing || attempt == null) return;
    syncing = true;
    try {
      while (pending.isNotEmpty &&
          seconds > 0 &&
          attempt!['status'] == 'inProgress') {
        final n = pending.keys.first, v = pending[n];
        final data = await api('PUT', 'attempts/${attempt!['id']}/answer', {
          'number': n,
          'letter': v,
        });
        if (pending.containsKey(n) && pending[n] == v) pending.remove(n);
        await persist();
        accept(data);
      }
      if (mounted) setState(() => error = null);
    } catch (e) {
      if (mounted) {
        setState(
          () => error = 'Lựa chọn chưa gửi. Kết nối lại trước khi hết giờ.',
        );
      }
    } finally {
      syncing = false;
    }
  }

  Future<void> refresh() async {
    if (attempt == null || busy || syncing || result != null) return;
    try {
      await sync();
      accept(await api('GET', 'attempts/${attempt!['id']}'));
      if (attempt!['status'] != 'inProgress') await showResult();
    } catch (e) {
      if (mounted) {
        setState(() => error = 'Kết nối gián đoạn. Đồng hồ vẫn tiếp tục.');
      }
    }
  }

  Future<void> start(dynamic e) async {
    final yes = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (c) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(c).height * .82,
          child: ListView(
            padding: const EdgeInsets.all(24),
            children: [
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: const Color(0xff142d32),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'READING COLLECTION',
                      style: TextStyle(
                        color: Color(0xffd7b56d),
                        letterSpacing: 2,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      e['name'],
                      style: const TextStyle(
                        fontFamily: 'Playfair Display',
                        fontSize: 36,
                        color: Colors.white,
                        height: 1.15,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      '${e['durationMinutes']} phút · ${e['totalQuestions']} câu',
                      style: const TextStyle(color: Color(0xffcddfd1)),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              for (final part in [
                'Part 5 · Incomplete Sentences\n101–130 / 30 câu',
                'Part 6 · Text Completion\n131–146 / 16 câu',
                'Part 7 · Reading Comprehension\n147–200 / 54 câu',
              ])
                card(Text(part, style: const TextStyle(height: 1.6))),
              card(
                Text(
                  'Đồng hồ bắt đầu khi bạn bắt đầu thi. Có thể đổi hoặc hủy lựa chọn trước khi nộp.\n\nĐáp án: ${e['answerStatus'] == 'verified' ? 'đã xác minh' : 'đề xuất, chưa xác minh ETS'}',
                  style: const TextStyle(height: 1.6),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(c, false),
                child: const Text('Quay lại'),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(c, true),
                child: const Text('Bắt đầu thi'),
              ),
            ],
          ),
        ),
      ),
    );
    if (yes != true) return;
    await guard(() async {
      pending.clear();
      selected.clear();
      warned = false;
      index = 0;
      result = null;
      accept(await api('POST', 'exams/${e['id']}/start'));
      await prefs!.setString('attempt', attempt!['id']);
      await persist();
    });
  }

  Future<void> submit() async {
    final n = 100 - selected.values.where((v) => v != null).length;
    final yes = await showDialog<bool>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Nộp bài thi?'),
        content: Text(
          'Còn $n câu chưa trả lời. Không thể sửa sau khi nộp.${pending.isNotEmpty ? '\nCó ${pending.length} lựa chọn đang chờ gửi.' : ''}',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c, false),
            child: const Text('Quay lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, true),
            child: const Text('Xác nhận nộp'),
          ),
        ],
      ),
    );
    if (yes == true) {
      await guard(() async {
        await sync();
        if (pending.isNotEmpty && seconds > 0) {
          throw Exception('Chưa gửi hết lựa chọn. Kết nối lại rồi nộp.');
        }
        accept(await api('POST', 'attempts/${attempt!['id']}/submit'));
        await showResult();
      });
    }
  }

  Future<void> autoSubmit() => guard(() async {
    accept(await api('POST', 'attempts/${attempt!['id']}/submit'));
    await showResult();
  });
  Future<void> showResult() async {
    result = Map<String, dynamic>.from(
      await api('GET', 'attempts/${attempt!['id']}/result'),
    );
    pending.clear();
    await persist();
    await prefs!.remove('attempt');
    if (mounted) setState(() {});
  }

  Future<void> navigate() async {
    final n = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (c) => SafeArea(
        child: SizedBox(
          height: MediaQuery.sizeOf(c).height * .8,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Điều hướng 100 câu',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Đóng điều hướng',
                      onPressed: () => Navigator.pop(c),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Expanded(child: questionGrid(sheet: true)),
              ],
            ),
          ),
        ),
      ),
    );
    if (n != null) goQuestion(n);
  }

  Widget card(Widget w) => Card(
    elevation: 0,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(18),
      side: const BorderSide(color: Color(0xffdfe5df)),
    ),
    margin: const EdgeInsets.symmetric(vertical: 8),
    child: Padding(padding: const EdgeInsets.all(20), child: w),
  );
  @override
  Widget build(BuildContext context) {
    final active = attempt != null && result == null;
    return Scaffold(
      appBar: kIsWeb
          ? null
          : AppBar(
              title: Text(
                active
                    ? 'TOEIC Reading'
                    : result != null
                    ? 'Kết quả Reading'
                    : 'Reading Studio',
              ),
              actions: [
                if (active)
                  IconButton(
                    tooltip: 'Điều hướng 100 câu',
                    onPressed: navigate,
                    icon: const Icon(Icons.grid_view_rounded),
                  ),
                if (!active)
                  IconButton(
                    tooltip: 'Cài đặt kết nối',
                    onPressed: connectionSettings,
                    icon: const Icon(Icons.tune_rounded),
                  ),
              ],
            ),
      body: SafeArea(
        child: Column(
          children: [
            if (busy) const LinearProgressIndicator(),
            if (error != null)
              MaterialBanner(
                content: Text(error!),
                actions: [
                  TextButton(
                    onPressed: () => guard(() async {
                      await refresh();
                      await load();
                    }),
                    child: const Text('Thử lại'),
                  ),
                ],
              ),
            Expanded(
              child: result != null
                  ? resultView()
                  : active
                  ? examView()
                  : listView(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> connectionSettings() async {
    final controller = TextEditingController(text: server.text);
    final value = await showDialog<String>(
      context: context,
      builder: (c) => AlertDialog(
        title: const Text('Kết nối thư viện'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(labelText: 'Địa chỉ máy chủ'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(c),
            child: const Text('Quay lại'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(c, controller.text.trim()),
            child: const Text('Lưu kết nối'),
          ),
        ],
      ),
    );
    controller.dispose();
    if (value == null) return;
    final parsed = Uri.tryParse(value);
    if (parsed == null ||
        !['http', 'https'].contains(parsed.scheme) ||
        parsed.host.isEmpty) {
      setState(() => error = 'Địa chỉ máy chủ không hợp lệ.');
      return;
    }
    if (value != server.text) {
      await prefs?.remove('attempt');
      await prefs?.remove('pending');
    }
    server.text = value;
    await prefs?.setString('server', value);
    await guard(load);
  }

  // Layout and tokens transferred from Figma Make V2 Library / ExamHeader.
  Widget badge(String text, {IconData? icon, Color? color}) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
    decoration: BoxDecoration(
      color: (color ?? const Color(0xff087f69)).withValues(alpha: .09),
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 18, color: color ?? const Color(0xff087f69)),
          const SizedBox(width: 7),
        ],
        Text(
          text,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color ?? const Color(0xff087f69),
          ),
        ),
      ],
    ),
  );
  Widget listView() => LayoutBuilder(
    builder: (context, bounds) {
      final filtered = exams
          .where(
            (e) => e['name'].toString().toLowerCase().contains(
              search.toLowerCase(),
            ),
          )
          .toList();
      final wide = bounds.maxWidth > 900;
      return RefreshIndicator(
        onRefresh: load,
        child: ListView(
          padding: EdgeInsets.symmetric(
            horizontal: max(20, (bounds.maxWidth - 1280) / 2),
            vertical: 32,
          ),
          children: [
            const Text(
              'THƯ VIỆN ĐỀ',
              style: TextStyle(
                color: Color(0xff087f69),
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Chọn đề để bắt đầu',
              style: TextStyle(
                fontFamily: 'Playfair Display',
                fontSize: 36,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Luyện Reading theo cấu trúc 100 câu trong 75 phút.',
              style: TextStyle(color: Color(0xff41575b), height: 1.6),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                badge('1  Chọn đề', icon: Icons.library_books_outlined),
                badge('2  Làm bài', icon: Icons.edit_note),
                badge('3  Xem kết quả', icon: Icons.task_alt),
              ],
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) => setState(() => search = value),
                    decoration: InputDecoration(
                      hintText: 'Tìm theo tên đề...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Color(0xffdce3dc)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: busy ? null : () => guard(load),
                  tooltip: 'Làm mới thư viện',
                  icon: const Icon(Icons.refresh),
                ),
                IconButton(
                  onPressed: connectionSettings,
                  tooltip: 'Cài đặt kết nối',
                  icon: const Icon(Icons.tune_rounded),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              '${filtered.length} đề thi',
              style: const TextStyle(color: Color(0xff41575b)),
            ),
            if (filtered.isEmpty)
              card(
                Column(
                  children: [
                    const Icon(Icons.search_off, size: 40),
                    const SizedBox(height: 12),
                    Text(
                      exams.isEmpty
                          ? 'Chưa có đề thi. Giảng viên cần import file Word.'
                          : 'Không tìm thấy đề phù hợp. Hãy thử từ khóa khác.',
                    ),
                  ],
                ),
              ),
            for (final e in filtered)
              Padding(
                padding: const EdgeInsets.only(top: 18),
                child: Container(
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xffdce3dc)),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0a142d32),
                        blurRadius: 24,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: wide
                      ? IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SizedBox(width: 280, child: examCover(e)),
                              Expanded(child: examInfo(e)),
                            ],
                          ),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [examCover(e), examInfo(e)],
                        ),
                ),
              ),
          ],
        ),
      );
    },
  );
  Widget examCover(dynamic e) => Container(
    padding: const EdgeInsets.all(28),
    color: const Color(0xff142d32),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'TOEIC READING',
          style: TextStyle(
            color: Color(0xffd7b56d),
            letterSpacing: 2,
            fontSize: 11,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 22),
        const Text(
          'Reading\nPractice',
          style: TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 34,
            color: Colors.white,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 28),
        const Text(
          'Part 5 · Part 6 · Part 7',
          style: TextStyle(color: Color(0xffcce0d1), fontSize: 12),
        ),
      ],
    ),
  );
  Widget examInfo(dynamic e) => Padding(
    padding: const EdgeInsets.all(28),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        badge('Sẵn sàng làm bài', icon: Icons.check_circle_outline),
        const SizedBox(height: 16),
        Text(
          e['name'],
          style: const TextStyle(
            fontFamily: 'Playfair Display',
            fontSize: 25,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        const Text(
          'Câu đơn, điền đoạn văn và đọc hiểu tài liệu.',
          style: TextStyle(color: Color(0xff41575b), height: 1.6),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: [
            badge('${e['durationMinutes']} phút', icon: Icons.schedule),
            badge(
              '${e['totalQuestions']} câu',
              icon: Icons.description_outlined,
            ),
            badge('3 Part', icon: Icons.layers_outlined),
          ],
        ),
        const SizedBox(height: 24),
        FilledButton(
          onPressed: busy ? null : () => start(e),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Xem đề & bắt đầu'),
              SizedBox(width: 12),
              Icon(Icons.arrow_forward, size: 20),
            ],
          ),
        ),
      ],
    ),
  );
  void goQuestion(int value) => setState(() {
    index = value;
    documentIndex = 0;
    showReading = false;
  });
  Widget questionGrid({bool sheet = false}) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      const Text(
        'ĐIỀU HƯỚNG CÂU HỎI',
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      ),
      const SizedBox(height: 8),
      const Text(
        '101–200 · Chọn số để chuyển câu',
        style: TextStyle(fontSize: 12, color: Color(0xff41575b)),
      ),
      const SizedBox(height: 12),
      Wrap(
        spacing: 6,
        runSpacing: 6,
        children: [
          badge('Đã làm', color: const Color(0xff087f69)),
          badge('Chưa làm', color: const Color(0xff41575b)),
        ],
      ),
      const SizedBox(height: 12),
      Expanded(
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 5,
            crossAxisSpacing: 6,
            mainAxisSpacing: 6,
          ),
          itemCount: 100,
          itemBuilder: (c, i) => Tooltip(
            message:
                'Câu ${i + 101}${selected[i + 101] != null ? ' · Đã chọn ${selected[i + 101]}' : ' · Chưa làm'}',
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                backgroundColor: i == index
                    ? const Color(0xff087f69)
                    : selected[i + 101] != null
                    ? const Color(0xffe7f0e8)
                    : Colors.white,
                foregroundColor: i == index
                    ? Colors.white
                    : const Color(0xff142d32),
                side: BorderSide(
                  color: i == index
                      ? const Color(0xff087f69)
                      : const Color(0xffdce3dc),
                ),
              ),
              onPressed: () {
                if (sheet) {
                  Navigator.pop(context, i);
                } else {
                  goQuestion(i);
                }
              },
              child: Text(
                '${i + 101}',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),
      ),
    ],
  );
  Widget documentPane(dynamic g) {
    final docs = g['documents'] as List;
    final current = documentIndex.clamp(0, docs.length - 1);
    final d = docs[current];
    return ColoredBox(
      color: const Color(0xffedf0ec),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    'Bài đọc',
                    style: TextStyle(
                      fontFamily: 'Playfair Display',
                      fontSize: 22,
                    ),
                  ),
                ),
                Text(
                  '${docs.length} tài liệu',
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xff41575b),
                  ),
                ),
              ],
            ),
          ),
          if (docs.length > 1)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: List.generate(
                  docs.length,
                  (i) => ChoiceChip(
                    label: Text('Tài liệu ${i + 1}'),
                    selected: current == i,
                    onSelected: (_) => setState(() => documentIndex = i),
                  ),
                ),
              ),
            ),
          Expanded(
            child: ListView(
              key: ValueKey('document-${d['id']}'),
              padding: const EdgeInsets.all(20),
              children: [
                card(
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Tài liệu ${d['order']}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 12),
                      if ((d['image'] != null || d['imageUrl'] != null) &&
                          d['textWasEdited'] != true) ...[
                        GestureDetector(
                          onTap: () => showDialog(
                            context: context,
                            builder: (c) => Dialog(
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        tooltip: 'Đóng ảnh',
                                        onPressed: () => Navigator.pop(c),
                                        icon: const Icon(Icons.close),
                                      ),
                                    ],
                                  ),
                                  Flexible(
                                    child: InteractiveViewer(
                                      minScale: .5,
                                      maxScale: 5,
                                      child: ReadingDocumentImage(
                                        encoded: d['image'],
                                        url: d['imageUrl'] == null
                                            ? null
                                            : Uri.parse(server.text)
                                                  .resolve(d['imageUrl'])
                                                  .toString(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          child: ReadingDocumentImage(
                            key: ValueKey(d['id']),
                            encoded: d['image'],
                            url: d['imageUrl'] == null
                                ? null
                                : Uri.parse(server.text)
                                      .resolve(d['imageUrl'])
                                      .toString(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Chạm vào ảnh để phóng to',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xff41575b),
                          ),
                        ),
                      ] else
                        SelectableText(
                          d['text'],
                          style: const TextStyle(fontSize: 16, height: 1.8),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget answerPane(dynamic q, dynamic p, bool locked) => ListView(
    key: ValueKey('question-${q['number']}'),
    padding: const EdgeInsets.all(28),
    children: [
      Text(
        'CÂU ${q['number']}',
        style: const TextStyle(
          color: Color(0xff087f69),
          fontWeight: FontWeight.bold,
          letterSpacing: 1.5,
        ),
      ),
      const SizedBox(height: 18),
      Text(
        p['number'] == 6 ? 'Chọn đáp án cho ô trống ${q['number']}' : q['text'],
        style: const TextStyle(
          fontSize: 23,
          fontWeight: FontWeight.w500,
          height: 1.6,
        ),
      ),
      const SizedBox(height: 24),
      for (final o in q['options'])
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.all(16),
              backgroundColor: selected[q['number']] == o['letter']
                  ? const Color(0xffe7f0e8)
                  : Colors.white,
              side: BorderSide(
                color: selected[q['number']] == o['letter']
                    ? const Color(0xff087f69)
                    : const Color(0xffdce3dc),
                width: selected[q['number']] == o['letter'] ? 2 : 1,
              ),
            ),
            onPressed: locked
                ? null
                : () => choose(
                    q['number'],
                    selected[q['number']] == o['letter'] ? null : o['letter'],
                  ),
            child: Row(
              children: [
                Container(
                  width: 34,
                  height: 34,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: selected[q['number']] == o['letter']
                        ? const Color(0xff087f69)
                        : const Color(0xffedf0ec),
                  ),
                  child: Text(
                    o['letter'],
                    style: TextStyle(
                      color: selected[q['number']] == o['letter']
                          ? Colors.white
                          : const Color(0xff142d32),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    o['text'],
                    style: const TextStyle(
                      fontSize: 17,
                      height: 1.5,
                      color: Color(0xff142d32),
                    ),
                  ),
                ),
                if (selected[q['number']] == o['letter'])
                  const Icon(Icons.check_circle, size: 20),
              ],
            ),
          ),
        ),
      Row(
        children: [
          Expanded(
            child: Text(
              selected[q['number']] == null
                  ? 'Chưa chọn đáp án'
                  : 'Đã chọn ${selected[q['number']]}',
              style: const TextStyle(fontSize: 13, color: Color(0xff41575b)),
            ),
          ),
          TextButton(
            onPressed: locked || selected[q['number']] == null
                ? null
                : () => choose(q['number'], null),
            child: const Text('Hủy lựa chọn'),
          ),
        ],
      ),
      const Divider(),
      const Text(
        'Có thể đổi hoặc hủy lựa chọn trước khi nộp bài.',
        style: TextStyle(fontSize: 12, color: Color(0xff41575b), height: 1.5),
      ),
    ],
  );
  Widget examView() {
    final qs = questions;
    if (qs.isEmpty) return const Center(child: Text('Không có câu hỏi.'));
    final q = qs[index], parts = attempt!['exam']['parts'] as List;
    final p = parts.firstWhere(
      (p) => (p['questions'] as List).any((x) => x['number'] == q['number']),
    );
    final g = q['groupId'] == null
        ? null
        : (p['groups'] as List).firstWhere((g) => g['id'] == q['groupId']);
    final locked = seconds == 0 || attempt!['status'] != 'inProgress';
    final done = selected.values.where((v) => v != null).length;
    return LayoutBuilder(
      builder: (context, bounds) {
        final wide = bounds.maxWidth >= 1050;
        final time =
            '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}';
        return Column(
          children: [
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Part ${p['number']} · Câu ${q['number']}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                  ),
                  badge(
                    time,
                    icon: Icons.schedule,
                    color: seconds <= 300
                        ? const Color(0xffb84b43)
                        : const Color(0xff142d32),
                  ),
                  const SizedBox(width: 8),
                  if (wide)
                    FilledButton(
                      onPressed: busy ? null : submit,
                      child: const Text('Nộp bài'),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '$done/100 đã làm · ${100 - done} chưa làm',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                  badge(
                    pending.isEmpty
                        ? 'Đã lưu'
                        : syncing
                        ? 'Đang lưu'
                        : 'Chờ kết nối',
                    icon: pending.isEmpty
                        ? Icons.cloud_done_outlined
                        : Icons.cloud_upload_outlined,
                    color: pending.isEmpty
                        ? const Color(0xff087f69)
                        : const Color(0xff9b6b18),
                  ),
                ],
              ),
            ),
            LinearProgressIndicator(value: done / 100, minHeight: 3),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                children: [
                  for (final part in [5, 6, 7])
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Text('Part $part'),
                        selected: p['number'] == part,
                        onSelected: (_) => goQuestion(
                          part == 5
                              ? 0
                              : part == 6
                              ? 30
                              : 46,
                        ),
                      ),
                    ),
                  const Spacer(),
                  if (!wide)
                    IconButton(
                      tooltip: 'Điều hướng 100 câu',
                      onPressed: navigate,
                      icon: const Icon(Icons.grid_view_rounded),
                    ),
                ],
              ),
            ),
            if (locked)
              const Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  'Hết giờ. Bài thi đã khóa. Kết nối lại để xem kết quả.',
                ),
              ),
            if (!wide && g != null)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
                child: SizedBox(
                  width: double.infinity,
                  child: SegmentedButton<bool>(
                    segments: const [
                      ButtonSegment(
                        value: true,
                        label: Text('Bài đọc'),
                        icon: Icon(Icons.menu_book_outlined),
                      ),
                      ButtonSegment(
                        value: false,
                        label: Text('Câu hỏi'),
                        icon: Icon(Icons.edit_note),
                      ),
                    ],
                    selected: {showReading},
                    onSelectionChanged: (v) =>
                        setState(() => showReading = v.first),
                  ),
                ),
              ),
            Expanded(
              child: wide
                  ? Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Container(
                          width: 225,
                          color: Colors.white,
                          padding: const EdgeInsets.all(16),
                          child: questionGrid(),
                        ),
                        if (g != null)
                          Expanded(flex: 11, child: documentPane(g)),
                        Expanded(
                          flex: g != null ? 10 : 20,
                          child: answerPane(q, p, locked),
                        ),
                      ],
                    )
                  : g != null && showReading
                  ? documentPane(g)
                  : answerPane(q, p, locked),
            ),
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                children: [
                  OutlinedButton.icon(
                    onPressed: index == 0 ? null : () => goQuestion(index - 1),
                    icon: const Icon(Icons.arrow_back, size: 18),
                    label: const Text('Câu trước'),
                  ),
                  const Spacer(),
                  if (!wide)
                    TextButton(
                      onPressed: busy ? null : submit,
                      child: const Text('Nộp bài'),
                    ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: index == 99 ? null : () => goQuestion(index + 1),
                    icon: const Icon(Icons.arrow_forward, size: 18),
                    label: const Text('Câu sau'),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget resultView() {
    final s = result!['summary'];
    final rows = (result!['review'] as List)
        .where(
          (q) =>
              reviewFilter == 'Tất cả' ||
              (reviewFilter == 'Đúng' && q['selected'] == q['correctAnswer']) ||
              (reviewFilter == 'Sai' &&
                  q['selected'] != null &&
                  q['selected'] != q['correctAnswer']) ||
              (reviewFilter == 'Bỏ qua' && q['selected'] == null),
        )
        .toList();
    return LayoutBuilder(
      builder: (context, bounds) => ListView(
        padding: EdgeInsets.symmetric(
          horizontal: max(20, (bounds.maxWidth - 1050) / 2),
          vertical: 32,
        ),
        children: [
          Container(
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: const Color(0xff142d32),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: [
                const Icon(Icons.task_alt, size: 48, color: Color(0xffd7b56d)),
                const SizedBox(height: 16),
                const Text(
                  'Đã hoàn thành bài thi',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Playfair Display',
                    fontSize: 30,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  s['exam']['name'],
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Color(0xffcce0d1), height: 1.5),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              for (final item in [
                ('Đúng', s['correct'], const Color(0xff087f69)),
                ('Sai', s['wrong'], const Color(0xffb84b43)),
                ('Bỏ qua', s['skipped'], const Color(0xff41575b)),
              ])
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: card(
                      Column(
                        children: [
                          Text(
                            '${item.$2}',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: item.$3,
                            ),
                          ),
                          Text(item.$1, style: const TextStyle(fontSize: 13)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          Text(
            'Tỷ lệ đúng ${s['correct']}% · Tổng 100 câu',
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 13),
          ),
          if (s['exam']['answerStatus'] != 'verified')
            card(
              const Text(
                'Kết quả theo bộ đáp án đề xuất. Chưa xác minh ETS; không quy đổi điểm TOEIC.',
                style: TextStyle(fontSize: 13, height: 1.6),
              ),
            ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              setState(() {
                attempt = null;
                result = null;
                selected.clear();
                reviewFilter = 'Tất cả';
              });
              load();
            },
            icon: const Icon(Icons.library_books_outlined),
            label: const Text('Về danh sách đề'),
          ),
          const SizedBox(height: 28),
          const Text(
            'Chi tiết câu trả lời',
            style: TextStyle(fontFamily: 'Playfair Display', fontSize: 25),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              for (final filter in ['Tất cả', 'Đúng', 'Sai', 'Bỏ qua'])
                ChoiceChip(
                  label: Text(filter),
                  selected: reviewFilter == filter,
                  onSelected: (_) => setState(() => reviewFilter = filter),
                ),
            ],
          ),
          const SizedBox(height: 12),
          if (rows.isEmpty) card(const Text('Không có câu trong mục này.')),
          for (final q in rows)
            card(
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: const Color(0xffedf0ec),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '${q['number']}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          q['selected'] == null
                              ? 'Bỏ qua'
                              : 'Đã chọn ${q['selected']}',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Đáp án: ${q['correctAnswer']}',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Color(0xff41575b),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    q['selected'] == null
                        ? Icons.remove_circle_outline
                        : q['selected'] == q['correctAnswer']
                        ? Icons.check_circle
                        : Icons.cancel,
                    color: q['selected'] == null
                        ? const Color(0xff41575b)
                        : q['selected'] == q['correctAnswer']
                        ? const Color(0xff087f69)
                        : const Color(0xffb84b43),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
