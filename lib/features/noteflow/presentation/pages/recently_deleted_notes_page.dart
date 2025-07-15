import 'package:flutter/material.dart';
import 'package:motiv_fy/features/noteflow/data/services/note_service.dart';

class RecentlyDeletedNotesPage extends StatefulWidget {
  const RecentlyDeletedNotesPage({super.key});

  @override
  State<RecentlyDeletedNotesPage> createState() =>
      _RecentlyDeletedNotesPageState();
}

class _RecentlyDeletedNotesPageState extends State<RecentlyDeletedNotesPage> {
  final NoteService _noteService = NoteService();
  final Set<String> _selectedNotes = {};
  bool _isSelectionMode = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      appBar: AppBar(
        backgroundColor: const Color(0xFF181818),
        title: const Text(
          'Recently Deleted',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (_isSelectionMode)
            TextButton(
              onPressed: _selectedNotes.isEmpty ? null : _confirmDeleteSelected,
              child: Text(
                'Delete All',
                style: TextStyle(
                  color: _selectedNotes.isEmpty
                      ? Colors.grey.shade600
                      : Colors.red.shade400,
                ),
              ),
            ),
          if (_isSelectionMode)
            TextButton(
              onPressed: _selectedNotes.isEmpty ? null : _restoreSelected,
              child: Text(
                'Restore',
                style: TextStyle(
                  color: _selectedNotes.isEmpty
                      ? Colors.grey.shade600
                      : Colors.green.shade400,
                ),
              ),
            ),
          IconButton(
            icon: Icon(
              _isSelectionMode ? Icons.close : Icons.select_all,
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSelectionMode = !_isSelectionMode;
                if (!_isSelectionMode) {
                  _selectedNotes.clear();
                }
              });
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _noteService.getDeletedNotes(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(color: Colors.white),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading deleted notes: ${snapshot.error}',
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final deletedNotes = snapshot.data ?? [];

          if (deletedNotes.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.delete_outline, size: 80, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No recently deleted notes',
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Deleted notes are automatically removed after 30 days',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: deletedNotes.length,
            itemBuilder: (context, index) {
              final note = deletedNotes[index];
              final isSelected = _selectedNotes.contains(note.id);
              final deletedDate = note.deletedAt!;
              final daysAgo = DateTime.now().difference(deletedDate).inDays;

              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue.shade900.withOpacity(0.3)
                      : Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? Colors.blue.shade400
                        : Colors.grey.shade700,
                    width: isSelected ? 2 : 1,
                  ),
                ),
                child: ListTile(
                  leading: _isSelectionMode
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedNotes.add(note.id);
                              } else {
                                _selectedNotes.remove(note.id);
                              }
                            });
                          },
                          activeColor: Colors.blue.shade400,
                        )
                      : const Icon(Icons.note_outlined, color: Colors.grey),
                  title: Text(
                    note.content.length > 50
                        ? '${note.content.substring(0, 50)}...'
                        : note.content,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Text(
                    daysAgo == 0
                        ? 'Deleted today'
                        : daysAgo == 1
                        ? 'Deleted 1 day ago'
                        : 'Deleted $daysAgo days ago',
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                  ),
                  trailing: _isSelectionMode
                      ? null
                      : PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert, color: Colors.grey),
                          color: Colors.grey.shade800,
                          onSelected: (String action) async {
                            switch (action) {
                              case 'restore':
                                await _restoreNote(note.id);
                                break;
                              case 'delete':
                                await _confirmDeleteNote(note.id);
                                break;
                            }
                          },
                          itemBuilder: (BuildContext context) => [
                            PopupMenuItem<String>(
                              value: 'restore',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.restore,
                                    color: Colors.green.shade400,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Restore',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                            PopupMenuItem<String>(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.delete_forever,
                                    color: Colors.red.shade400,
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Delete Permanently',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                  onTap: _isSelectionMode
                      ? () {
                          setState(() {
                            if (isSelected) {
                              _selectedNotes.remove(note.id);
                            } else {
                              _selectedNotes.add(note.id);
                            }
                          });
                        }
                      : null,
                ),
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _restoreNote(String noteId) async {
    try {
      await _noteService.restoreNote(noteId);
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Note restored successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error restoring note: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmDeleteNote(String noteId) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Delete Permanently',
          style: TextStyle(color: Colors.white),
        ),
        content: const Text(
          'This note will be permanently deleted and cannot be recovered.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _noteService.permanentlyDeleteNote(noteId);
        setState(() {});
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Note deleted permanently'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting note: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _restoreSelected() async {
    try {
      await _noteService.restoreMultipleNotes(_selectedNotes.toList());
      setState(() {
        _selectedNotes.clear();
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Notes restored successfully'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error restoring notes: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _confirmDeleteSelected() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Delete Permanently',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Delete ${_selectedNotes.length} notes permanently? This action cannot be undone.',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text('Delete', style: TextStyle(color: Colors.red.shade400)),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await _noteService.permanentlyDeleteMultipleNotes(
          _selectedNotes.toList(),
        );
        setState(() {
          _selectedNotes.clear();
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Notes deleted permanently'),
            backgroundColor: Colors.red,
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error deleting notes: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
