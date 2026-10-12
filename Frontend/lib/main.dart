import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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
        backgroundColor: Color(0xff142d32),
        foregroundColor: Colors.white,
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
  int index = 0, seconds = 4500;
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
      await req.send().timeout(const Duration(seconds: 15)),
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
        setState(() => error = e.toString().replaceFirst('Exception: ', ''));
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
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Điều hướng 100 câu', style: TextStyle(fontSize: 24)),
              const Text('Tô màu: đã chọn · Viền: chưa làm'),
              const SizedBox(height: 16),
              SizedBox(
                height: 470,
                child: GridView.count(
                  crossAxisCount: 5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  children: List.generate(
                    100,
                    (i) => FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        backgroundColor: selected[i + 101] != null
                            ? Theme.of(context).colorScheme.primaryContainer
                            : Colors.white,
                      ),
                      onPressed: () => Navigator.pop(c, i),
                      child: Text(
                        '${i + 101}',
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    if (n != null) setState(() => index = n);
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
      appBar: AppBar(
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

  Widget listView() => RefreshIndicator(
    onRefresh: load,
    child: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xff142d32),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'PHÒNG ĐỌC CÁ NHÂN',
                style: TextStyle(
                  color: Color(0xffd7b56d),
                  fontSize: 11,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Luyện tập tập trung.\nTiến bộ có chủ đích.',
                style: TextStyle(
                  fontFamily: 'Playfair Display',
                  fontSize: 30,
                  color: Colors.white,
                  height: 1.2,
                ),
              ),
              SizedBox(height: 14),
              Text(
                'Một không gian đọc rõ ràng, tĩnh lặng và không xao nhãng.',
                style: TextStyle(color: Color(0xffcddfd1), height: 1.6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'THƯ VIỆN ĐỀ',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 1.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text('${exams.length} bộ đề', style: const TextStyle(fontSize: 12)),
          ],
        ),
        const SizedBox(height: 10),
        if (exams.isEmpty)
          card(const Text('Chưa có đề. Giảng viên cần import file Word.')),
        for (final e in exams)
          card(
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.menu_book_rounded, color: Color(0xff087f69)),
                    SizedBox(width: 8),
                    Text(
                      'READING COLLECTION',
                      style: TextStyle(
                        fontSize: 11,
                        letterSpacing: 1,
                        color: Color(0xff087f69),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  e['name'],
                  style: const TextStyle(
                    fontSize: 29,
                    fontFamily: 'Playfair Display',
                  ),
                ),
                const SizedBox(height: 18),
                const Divider(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${e['durationMinutes']} phút'),
                    Text('${e['totalQuestions']} câu'),
                    const Text('3 phần thi'),
                  ],
                ),
                const Divider(),
                const SizedBox(height: 18),
                FilledButton(
                  onPressed: busy ? null : () => start(e),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Xem thông tin đề'),
                      SizedBox(width: 12),
                      Icon(Icons.arrow_forward_rounded, size: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
      ],
    ),
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
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Part ${p['number']} · ${index + 1}/100'),
              Text(
                '${(seconds ~/ 60).toString().padLeft(2, '0')}:${(seconds % 60).toString().padLeft(2, '0')}',
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                  color: seconds <= 300
                      ? Colors.red
                      : Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
        Text(
          '${selected.values.where((v) => v != null).length} đã chọn · ${pending.length} chờ gửi',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 5,
              value: selected.values.where((v) => v != null).length / 100,
            ),
          ),
        ),
        if (locked)
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              'Hết giờ. Bài thi đã khóa. Kết nối lại để xem kết quả.',
            ),
          ),
        Expanded(
          child: ListView(
            key: ValueKey(q['number']),
            padding: const EdgeInsets.all(24),
            children: [
              if (g != null)
                for (final d in g['documents'])
                  card(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tài liệu ${d['order']}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 12),
                        if (d['textWasEdited'] == true)
                          SelectableText(
                            d['text'],
                            style: const TextStyle(height: 1.7, fontSize: 16),
                          ),
                        if (d['image'] != null && d['textWasEdited'] != true)
                          GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (c) => Dialog(
                                child: InteractiveViewer(
                                  maxScale: 5,
                                  child: Image.memory(base64Decode(d['image'])),
                                ),
                              ),
                            ),
                            child: Image.memory(
                              base64Decode(d['image']),
                              errorBuilder: (_, e, s) =>
                                  const Text('Không hiển thị được ảnh.'),
                            ),
                          )
                        else if (d['textWasEdited'] != true)
                          SelectableText(
                            d['text'],
                            style: const TextStyle(height: 1.7, fontSize: 16),
                          ),
                        if (d['image'] != null && d['textWasEdited'] != true)
                          const Text(
                            'Chạm ảnh để phóng to',
                            style: TextStyle(fontSize: 12),
                          ),
                      ],
                    ),
                  ),
              Text(
                p['number'] == 6
                    ? 'Ô trống ${q['number']}'
                    : '${q['number']}. ${q['text']}',
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 16),
              for (final o in q['options'])
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.all(18),
                      alignment: Alignment.centerLeft,
                      backgroundColor: selected[q['number']] == o['letter']
                          ? Theme.of(context).colorScheme.primaryContainer
                          : Colors.white,
                    ),
                    onPressed: locked
                        ? null
                        : () => choose(
                            q['number'],
                            selected[q['number']] == o['letter']
                                ? null
                                : o['letter'],
                          ),
                    child: Text(
                      '(${o['letter']}) ${o['text']}',
                      style: const TextStyle(fontSize: 17),
                    ),
                  ),
                ),
              TextButton(
                onPressed: locked ? null : () => choose(q['number'], null),
                child: const Text('Hủy lựa chọn'),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Câu trước',
                onPressed: index == 0 ? null : () => setState(() => index--),
                icon: const Icon(Icons.arrow_back),
              ),
              Expanded(
                child: FilledButton.tonal(
                  onPressed: busy ? null : submit,
                  child: const Text('Nộp bài'),
                ),
              ),
              IconButton(
                tooltip: 'Câu tiếp theo',
                onPressed: index == 99 ? null : () => setState(() => index++),
                icon: const Icon(Icons.arrow_forward),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget resultView() {
    final s = result!['summary'];
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Icon(Icons.task_alt, size: 64, color: Color(0xff087f69)),
        const Text(
          'Đã hoàn thành bài thi',
          style: TextStyle(fontSize: 30, fontFamily: 'Playfair Display'),
        ),
        card(
          Column(
            children: [
              Text(
                '${s['correct']} câu đúng',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text('${s['wrong']} sai · ${s['skipped']} bỏ qua'),
              Text(
                'Tổng: ${(s['correct'] as int) + (s['wrong'] as int) + (s['skipped'] as int)} / 100',
              ),
            ],
          ),
        ),
        if (s['exam']['answerStatus'] != 'verified')
          card(
            const Text(
              'Kết quả theo bộ đáp án đề xuất. Chưa xác minh ETS; không quy đổi điểm TOEIC.',
            ),
          ),
        FilledButton(
          onPressed: () {
            setState(() {
              attempt = null;
              result = null;
              selected.clear();
            });
            load();
          },
          child: const Text('Về danh sách đề'),
        ),
        for (final q in result!['review'])
          ListTile(
            title: Text('Câu ${q['number']}'),
            subtitle: Text(
              'Chọn: ${q['selected'] ?? 'Bỏ qua'} · Đáp án: ${q['correctAnswer']}',
            ),
            trailing: Icon(
              q['selected'] == null
                  ? Icons.remove
                  : q['selected'] == q['correctAnswer']
                  ? Icons.check_circle
                  : Icons.cancel,
              color: q['selected'] == q['correctAnswer']
                  ? Colors.green
                  : Colors.grey,
            ),
          ),
      ],
    );
  }
}
