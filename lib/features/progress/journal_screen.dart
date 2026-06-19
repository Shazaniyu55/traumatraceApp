import 'package:flutter/material.dart';
import '../../core/api_client.dart';

/// Free-writing journal. Backed by GET/POST/PATCH/DELETE /journal.
class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});
  @override
  State<JournalScreen> createState() => _JournalScreenState();
}

class _JournalScreenState extends State<JournalScreen> {
  List<dynamic> _entries = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() => _loading = true);
    try {
      final res = await ApiClient.instance.get('/journal');
      final list = (res as List?) ?? [];
      // Pinned first, then newest.
      list.sort((a, b) {
        final pa = (a['pinned'] == true) ? 0 : 1;
        final pb = (b['pinned'] == true) ? 0 : 1;
        if (pa != pb) return pa - pb;
        return (b['createdAt'] ?? '').toString().compareTo((a['createdAt'] ?? '').toString());
      });
      setState(() => _entries = list);
    } catch (_) {
      setState(() => _entries = []);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _openEditor([Map<String, dynamic>? entry]) async {
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (_) => JournalEditorScreen(entry: entry)),
    );
    if (saved == true) _load();
  }

  Future<void> _togglePin(Map<String, dynamic> e) async {
    try {
      await ApiClient.instance.patch('/journal/${e['id']}', {'pinned': !(e['pinned'] == true)});
      _load();
    } catch (_) {}
  }

  Future<void> _delete(Map<String, dynamic> e) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete entry?'),
        content: const Text('This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete')),
        ],
      ),
    );
    if (ok == true) {
      try {
        await ApiClient.instance.delete('/journal/${e['id']}');
        _load();
      } catch (_) {}
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Journal')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openEditor(),
        child: const Icon(Icons.edit_outlined),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _entries.isEmpty
              ? const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Your journal is empty.\nTap the pencil to write your first entry.',
                      textAlign: TextAlign.center,
                      style: TextStyle(height: 1.4, color: Colors.black54),
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _load,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _entries.length,
                    itemBuilder: (context, i) {
                      final e = _entries[i] as Map<String, dynamic>;
                      final pinned = e['pinned'] == true;
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        elevation: 0,
                        color: Theme.of(context).colorScheme.surfaceContainerHighest,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.fromLTRB(16, 8, 8, 8),
                          title: Text(
                            (e['title'] ?? '').toString().isEmpty ? 'Untitled' : e['title'],
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          subtitle: Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(e['body'] ?? '',
                                maxLines: 2, overflow: TextOverflow.ellipsis),
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (v) {
                              if (v == 'pin') _togglePin(e);
                              if (v == 'edit') _openEditor(e);
                              if (v == 'delete') _delete(e);
                            },
                            itemBuilder: (_) => [
                              PopupMenuItem(value: 'pin', child: Text(pinned ? 'Unpin' : 'Pin')),
                              const PopupMenuItem(value: 'edit', child: Text('Edit')),
                              const PopupMenuItem(value: 'delete', child: Text('Delete')),
                            ],
                            icon: Icon(pinned ? Icons.push_pin : Icons.more_vert),
                          ),
                          onTap: () => _openEditor(e),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}

class JournalEditorScreen extends StatefulWidget {
  final Map<String, dynamic>? entry;
  const JournalEditorScreen({super.key, this.entry});
  @override
  State<JournalEditorScreen> createState() => _JournalEditorScreenState();
}

class _JournalEditorScreenState extends State<JournalEditorScreen> {
  late final TextEditingController _title;
  late final TextEditingController _body;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.entry?['title'] ?? '');
    _body = TextEditingController(text: widget.entry?['body'] ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_body.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Write something first.')));
      return;
    }
    setState(() => _saving = true);
    try {
      final payload = {'title': _title.text.trim(), 'body': _body.text.trim()};
      if (widget.entry == null) {
        await ApiClient.instance.post('/journal', payload);
      } else {
        await ApiClient.instance.patch('/journal/${widget.entry!['id']}', payload);
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Could not save: $e')));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.entry == null ? 'New entry' : 'Edit entry'),
        actions: [
          IconButton(
            onPressed: _saving ? null : _save,
            icon: _saving
                ? const SizedBox(
                    height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: _title,
              decoration: const InputDecoration(
                hintText: 'Title (optional)',
                border: InputBorder.none,
              ),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const Divider(),
            Expanded(
              child: TextField(
                controller: _body,
                expands: true,
                maxLines: null,
                textAlignVertical: TextAlignVertical.top,
                decoration: const InputDecoration(
                  hintText: 'Write freely. No one else sees this.',
                  border: InputBorder.none,
                ),
                style: const TextStyle(height: 1.5),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
