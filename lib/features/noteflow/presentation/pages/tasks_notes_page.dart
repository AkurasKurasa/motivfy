import 'package:flutter/material.dart';
import 'package:motiv_fy/core/widgets/task_list.dart';
import 'package:motiv_fy/core/widgets/task_calendar.dart';
import 'package:motiv_fy/core/widgets/animated_filter_selector.dart';
import 'package:motiv_fy/features/tasks/data/services/task_service.dart';
import 'package:motiv_fy/features/noteflow/data/services/note_service.dart';
import 'package:motiv_fy/features/noteflow/presentation/pages/recently_deleted_notes_page.dart';
import 'package:motiv_fy/features/noteflow/presentation/pages/note_detail_page.dart';
import 'package:motiv_fy/features/tasks/presentation/pages/tasks_archive_page.dart';

class TasksNotesPage extends StatefulWidget {
  final String? initialDate;

  const TasksNotesPage({super.key, this.initialDate});

  @override
  State<TasksNotesPage> createState() => _TasksNotesPageState();
}

class _TasksNotesPageState extends State<TasksNotesPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool isTasksTab = true;
  final TaskService _taskService = TaskService();
  final NoteService _noteService = NoteService();

  // Date state variables
  late DateTime _selectedDate;
  late int _currentMonth;
  late int _currentYear;

  // Task filter state
  String _selectedFilter = 'All Tasks';

  // Note selection state
  bool _selectMode = false;
  Set<String> _selectedNoteIds = {};

  @override
  void initState() {
    super.initState();

    // Initialize date variables with current date
    final now = DateTime.now();
    _selectedDate = now;
    _currentMonth = now.month;
    _currentYear = now.year;

    _tabController = TabController(
      length: 2,
      vsync: this,
      animationDuration: const Duration(
        milliseconds: 200,
      ), // Reduced from default 300ms
    );
    _tabController.addListener(() {
      setState(() {
        isTasksTab = _tabController.index == 0;
      });
    });

    // Register to listen for changes in tasks
    _taskService.addListener(_onTasksChanged);

    // If initialDate is provided, use it to set the calendar date
    if (widget.initialDate != null) {
      _selectDateFromString(widget.initialDate!);
    }
  }

  void _onTasksChanged() {
    // Refresh the UI when tasks change
    if (mounted) {
      setState(() {
        // Just trigger a rebuild
      });
    }
  }

  void _selectDateFromString(String dateStr) {
    try {
      final parts = dateStr.split(' ');
      if (parts.length == 3) {
        final month = _getMonthNumber(parts[0]);
        final day = int.tryParse(parts[1]) ?? 1;
        final year = int.tryParse(parts[2]) ?? DateTime.now().year;

        setState(() {
          _selectedDate = DateTime(year, month, day);
          _currentMonth = month;
          _currentYear = year;
        });
      }
    } catch (e) {
      print('Error parsing date string: $dateStr');
    }
  }

  int _getMonthNumber(String monthName) {
    const months = {
      'January': 1,
      'February': 2,
      'March': 3,
      'April': 4,
      'May': 5,
      'June': 6,
      'July': 7,
      'August': 8,
      'September': 9,
      'October': 10,
      'November': 11,
      'December': 12,
    };
    return months[monthName] ?? 1;
  }

  @override
  void dispose() {
    _tabController.dispose();
    _taskService.removeListener(_onTasksChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF181818),
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final screenWidth = constraints.maxWidth;
            final horizontalPadding = screenWidth * 0.05;

            return Column(
              children: [
                // Header
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 20,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Left spacer (invisible button for symmetry)
                      SizedBox(
                        width: 48, // Same width as the return button
                        height: 48,
                        child: Container(), // Empty container for spacing
                      ),
                      // Custom Tab Selector
                      Flexible(
                        child: Hero(
                          tag: 'tasksNotesTabSelector',
                          child: TasksNotesTabSelector(
                            tabs: [
                              TasksNotesTabItem(
                                label: 'Tasks',
                                icon: Icons.task_alt,
                                selectedColor: Colors.white,
                                unselectedColor: Colors.white70,
                              ),
                              TasksNotesTabItem(
                                label: 'Notes',
                                icon: Icons.note_alt_outlined,
                                selectedColor: Colors.white,
                                unselectedColor: Colors.white70,
                              ),
                            ],
                            initialIndex: _tabController.index,
                            onTabChanged: (index) {
                              _tabController.animateTo(index);
                              setState(() {
                                isTasksTab = index == 0;
                              });
                            },
                            width: 220,
                            height: 36,
                            borderRadius: 20,
                            backgroundColor: const Color(0xFF333333),
                            selectedTabColor: const Color(0xFF505050),
                            borderColor: Colors.white.withOpacity(0.1),
                            borderWidth: 1.0,
                          ),
                        ),
                      ),
                      // Return button
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                          size: 22,
                        ),
                        onPressed: () => Navigator.pop(context),
                        tooltip: 'Back',
                      ),
                    ],
                  ),
                ),

                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      // Tasks Tab Content
                      _buildTasksContent(horizontalPadding),
                      // Notes Tab Content
                      _buildNotesContent(horizontalPadding),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTasksContent(double horizontalPadding) {
    return Column(
      children: [
        // Page title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: [
              const Expanded(
                child: Text(
                  'My Tasks',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              // Archive button
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                ),
                child: IconButton(
                  icon: Icon(
                    Icons.archive_outlined,
                    color: Colors.white.withOpacity(0.8),
                    size: 18,
                  ),
                  onPressed: () {
                    // Navigate to archive page
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TasksArchivePage(),
                      ),
                    );
                  },
                  tooltip: 'Archive',
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Calendar widget
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: TaskCalendar(
            selectedDate: _selectedDate,
            onDateChanged: (date) {
              setState(() {
                _selectedDate = date;
              });
            },
            currentMonth: _currentMonth,
            currentYear: _currentYear,
            onMonthChanged: (month, year) {
              setState(() {
                _currentMonth = month;
                _currentYear = year;
              });
            },
          ),
        ),

        const SizedBox(height: 20),

        // Filter selector for tasks
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: AnimatedFilterSelector(
            options: const ['All Tasks', 'Urgent', 'Important'],
            selectedOption: _selectedFilter,
            onOptionChanged: (option) {
              setState(() {
                _selectedFilter = option;
              });
            },
            optionColors: const {
              'All Tasks': Colors.white,
              'Urgent': Colors.red,
              'Important': Colors.amber,
            },
          ),
        ),

        const SizedBox(height: 16),

        // Task list
        Expanded(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
            child: RepaintBoundary(
              child: SingleChildScrollView(
                child: TaskList(
                  key: ValueKey(
                    'tasks_${_selectedFilter}_${_selectedDate.toIso8601String()}',
                  ),
                  filter: _selectedFilter,
                  selectedDate: _selectedDate,
                  taskCount: -1, // Show all available tasks
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildNotesContent(double horizontalPadding) {
    return Column(
      children: [
        // Page title
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: const Row(
            children: [
              Expanded(
                child: Text(
                  'All Notes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // Header with search bar and recently deleted button
        Padding(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          child: Row(
            children: [
              // Search bar (takes most of the space)
              Expanded(
                child: Container(
                  height: 50,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.grey.shade600),
                      hintText: 'Search',
                      hintStyle: TextStyle(color: Colors.grey.shade600),
                      border: InputBorder.none,
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              ),

              // Select multiple button
              const SizedBox(width: 12),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(Icons.select_all, color: Colors.grey.shade400),
                  tooltip: 'Select Multiple',
                  onPressed: () {
                    setState(() {
                      _selectMode = !_selectMode;
                      if (!_selectMode) {
                        _selectedNoteIds.clear();
                      }
                    });
                  },
                ),
              ),

              // Recently deleted button
              const SizedBox(width: 12),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(Icons.delete_outline, color: Colors.grey.shade400),
                  tooltip: 'Recently Deleted',
                  onPressed: () {
                    // Navigate to recently deleted notes
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const RecentlyDeletedNotesPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Notes list
        Expanded(child: _buildNotesList(horizontalPadding)),
      ],
    );
  }

  Widget _buildNotesList(double horizontalPadding) {
    return FutureBuilder<List<Note>>(
      future: _getNotes(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final notes = snapshot.data ?? [];

        if (notes.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.note_alt_outlined,
                  size: 48,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(height: 16),
                const Text(
                  'No Notes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Notes you create will appear here',
                  style: TextStyle(color: Colors.grey.shade500, fontSize: 14),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
          itemCount: notes.length,
          // Performance optimizations
          cacheExtent: 1000,
          addAutomaticKeepAlives: true,
          addRepaintBoundaries: true,
          addSemanticIndexes: true,
          itemBuilder: (context, index) {
            final note = notes[index];
            final isSelected = _selectedNoteIds.contains(note.id);

            return RepaintBoundary(
              key: ValueKey('note_${note.id}'),
              child: Container(
                margin: const EdgeInsets.only(bottom: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.grey.shade900,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.transparent,
                    width: 1,
                  ),
                ),
                child: ListTile(
                  leading: _selectMode
                      ? Checkbox(
                          value: isSelected,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedNoteIds.add(note.id);
                              } else {
                                _selectedNoteIds.remove(note.id);
                              }
                            });
                          },
                        )
                      : Icon(
                          Icons.note_alt_outlined,
                          color: Colors.grey.shade400,
                        ),
                  title: Text(
                    note.title.isEmpty ? 'Untitled Note' : note.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  subtitle: Text(
                    note.content.isEmpty ? 'No content' : note.content,
                    style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  trailing: Text(
                    _formatDate(note.createdAt),
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 11),
                  ),
                  onTap: () {
                    if (_selectMode) {
                      setState(() {
                        if (isSelected) {
                          _selectedNoteIds.remove(note.id);
                        } else {
                          _selectedNoteIds.add(note.id);
                        }
                      });
                    } else {
                      // Navigate to note detail page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => NoteDetailPage(
                            noteId: note.id,
                            initialContent: note.content,
                          ),
                        ),
                      ).then((result) {
                        // Refresh the notes list if note was deleted or modified
                        if (result == true) {
                          setState(() {
                            // Trigger rebuild to refresh notes list
                          });
                        }
                      });
                    }
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<List<Note>> _getNotes() async {
    try {
      final noteEntities = await _noteService.getNotes();
      return noteEntities
          .map(
            (entity) => Note(
              id: entity.id,
              title: _extractTitle(entity.content),
              content: entity.content,
              createdAt: entity.createdAt,
              updatedAt: entity
                  .createdAt, // Use createdAt as updatedAt if not available
            ),
          )
          .toList();
    } catch (e) {
      print('Error loading notes: $e');
      return [];
    }
  }

  String _extractTitle(String content) {
    if (content.isEmpty) return 'Untitled Note';
    final lines = content.split('\n');
    final firstLine = lines.first.trim();
    if (firstLine.length > 50) {
      return firstLine.substring(0, 50) + '...';
    }
    return firstLine.isEmpty ? 'Untitled Note' : firstLine;
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final noteDate = DateTime(date.year, date.month, date.day);

    if (noteDate == today) {
      return 'Today';
    } else if (noteDate == today.subtract(const Duration(days: 1))) {
      return 'Yesterday';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Custom Tab Selector Widget for Tasks and Notes
class TasksNotesTabSelector extends StatefulWidget {
  final List<TasksNotesTabItem> tabs;
  final Function(int) onTabChanged;
  final int initialIndex;
  final double width;
  final double height;
  final Color backgroundColor;
  final Color selectedTabColor;
  final Color borderColor;
  final double borderWidth;
  final double borderRadius;

  const TasksNotesTabSelector({
    super.key,
    required this.tabs,
    required this.onTabChanged,
    this.initialIndex = 0,
    this.width = 220,
    this.height = 36,
    this.backgroundColor = const Color(0xFF333333),
    this.selectedTabColor = const Color(0xFF505050),
    this.borderColor = Colors.white10,
    this.borderWidth = 1.0,
    this.borderRadius = 20,
  });

  @override
  State<TasksNotesTabSelector> createState() => _TasksNotesTabSelectorState();
}

class _TasksNotesTabSelectorState extends State<TasksNotesTabSelector>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: widget.tabs.length,
      vsync: this,
      initialIndex: widget.initialIndex,
    );

    _tabController.addListener(() {
      widget.onTabChanged(_tabController.index);
    });
  }

  @override
  void didUpdateWidget(TasksNotesTabSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialIndex != widget.initialIndex) {
      _tabController.animateTo(widget.initialIndex);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: Material(
        color: Colors.transparent,
        child: Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: widget.borderColor,
              width: widget.borderWidth,
            ),
          ),
          child: TabBar(
            controller: _tabController,
            indicator: BoxDecoration(
              color: widget.selectedTabColor,
              borderRadius: BorderRadius.circular(widget.borderRadius - 4),
            ),
            indicatorPadding: const EdgeInsets.symmetric(vertical: 4.0),
            dividerColor: Colors.transparent,
            tabs: widget.tabs.map((tab) => tab.buildTab()).toList(),
            labelColor: Colors.white,
            unselectedLabelColor: Colors.white70,
            labelStyle: const TextStyle(fontWeight: FontWeight.w500),
            unselectedLabelStyle: const TextStyle(
              fontWeight: FontWeight.normal,
            ),
            labelPadding: EdgeInsets.zero,
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}

/// Tab Item for Tasks and Notes Tab Selector
class TasksNotesTabItem {
  final String label;
  final IconData icon;
  final Color selectedColor;
  final Color unselectedColor;
  final double iconSize;
  final double fontSize;
  final FontWeight selectedFontWeight;
  final FontWeight unselectedFontWeight;
  final double height;

  const TasksNotesTabItem({
    required this.label,
    required this.icon,
    this.selectedColor = Colors.white,
    this.unselectedColor = Colors.white70,
    this.iconSize = 16,
    this.fontSize = 14,
    this.selectedFontWeight = FontWeight.w500,
    this.unselectedFontWeight = FontWeight.normal,
    this.height = 36,
  });

  Widget buildTab() {
    return Tab(
      height: height,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: unselectedColor, size: iconSize),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(color: unselectedColor, fontSize: fontSize),
            ),
          ],
        ),
      ),
    );
  }
}

// Note model (if not already defined elsewhere)
class Note {
  final String id;
  final String title;
  final String content;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.title,
    required this.content,
    required this.createdAt,
    required this.updatedAt,
  });
}
