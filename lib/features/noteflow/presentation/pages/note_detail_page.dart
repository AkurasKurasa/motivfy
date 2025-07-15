import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:motiv_fy/features/noteflow/data/services/note_service.dart';
import 'package:motiv_fy/features/noteflow/domain/entities/note_entity.dart';
import 'package:motiv_fy/features/noteflow/domain/usecases/update_note_usecase.dart';
import 'package:motiv_fy/features/noteflow/domain/usecases/delete_note_usecase.dart';
import 'package:motiv_fy/features/noteflow/data/repositories/note_repository.dart';

/// Note Detail Page with Glassmorphic Design
class NoteDetailPage extends StatefulWidget {
  final String noteId;
  final String? initialContent;

  const NoteDetailPage({super.key, required this.noteId, this.initialContent});

  @override
  State<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends State<NoteDetailPage>
    with SingleTickerProviderStateMixin {
  late TextEditingController _contentController;
  late FocusNode _focusNode;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final NoteService _noteService = NoteService();
  late final UpdateNoteUseCase _updateNoteUseCase;
  late final DeleteNoteUseCase _deleteNoteUseCase;

  NoteEntity? _note;
  bool _isLoading = true;
  bool _isEditing = false;
  bool _hasUnsavedChanges = false;
  String _originalContent = '';

  int _selectedFormatIndex = 0; // 0: left, 1: center, 2: right, 3: justify

  @override
  void initState() {
    super.initState();

    // Initialize use cases
    final repository = NoteRepository(_noteService);
    _updateNoteUseCase = UpdateNoteUseCase(repository);
    _deleteNoteUseCase = DeleteNoteUseCase(repository);

    // Initialize controllers
    _contentController = TextEditingController(
      text: widget.initialContent ?? '',
    );
    _focusNode = FocusNode();

    // Initialize animations
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Curves.easeOutCubic,
          ),
        );

    // Listen for content changes
    _contentController.addListener(_onContentChanged);

    // Load note data
    _loadNote();
  }

  void _onContentChanged() {
    final hasContentChanges = _contentController.text != _originalContent;
    final hasAlignmentChanges =
        _note != null && _selectedFormatIndex != _note!.textAlignment;
    final hasChanges = hasContentChanges || hasAlignmentChanges;

    if (hasChanges != _hasUnsavedChanges) {
      setState(() {
        _hasUnsavedChanges = hasChanges;
      });
    }
  }

  Future<void> _loadNote() async {
    try {
      final note = await _noteService.getNoteById(widget.noteId);
      if (note != null) {
        setState(() {
          _note = note;
          _originalContent = note.content;
          _selectedFormatIndex = note.textAlignment; // Load saved alignment
          if (widget.initialContent == null) {
            _contentController.text = note.content;
          }
          _isLoading = false;
        });
        _animationController.forward();
      } else {
        // Note not found, go back
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      debugPrint('Error loading note: $e');
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _saveNote() async {
    if (_note == null || !_hasUnsavedChanges) return;

    try {
      final updatedNote = _note!.copyWith(
        content: _contentController.text.trim(),
        textAlignment: _selectedFormatIndex, // Save the text alignment
      );
      await _updateNoteUseCase.execute(updatedNote);

      setState(() {
        _note = updatedNote;
        _originalContent = updatedNote.content;
        _hasUnsavedChanges = false;
        _isEditing = false;
      });

      _showSnackBar(
        'Note saved successfully',
        Icons.check_circle,
        Colors.green,
      );
    } catch (e) {
      _showSnackBar('Failed to save note', Icons.error, Colors.red);
      debugPrint('Error saving note: $e');
    }
  }

  Future<void> _deleteNote() async {
    if (_note == null) return;

    final confirmed = await _showDeleteConfirmation();
    if (!confirmed) return;

    try {
      await _deleteNoteUseCase.execute(_note!.id);
      _showSnackBar('Note deleted', Icons.delete, Colors.orange);
      Navigator.pop(context, true); // Return true to indicate deletion
    } catch (e) {
      _showSnackBar('Failed to delete note', Icons.error, Colors.red);
      debugPrint('Error deleting note: $e');
    }
  }

  Future<bool> _showDeleteConfirmation() async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => _GlassmorphicDialog(
            title: 'Delete Note',
            content:
                'Are you sure you want to delete this note? It will be moved to Recently Deleted.',
            onConfirm: () => Navigator.pop(context, true),
            onCancel: () => Navigator.pop(context, false),
          ),
        ) ??
        false;
  }

  Future<bool> _showUnsavedChangesDialog() async {
    if (!_hasUnsavedChanges) return true;

    return await showDialog<bool>(
          context: context,
          builder: (context) => _GlassmorphicDialog(
            title: 'Unsaved Changes',
            content:
                'You have unsaved changes. Do you want to save them before leaving?',
            onConfirm: () async {
              await _saveNote();
              Navigator.pop(context, true);
            },
            onCancel: () => Navigator.pop(context, true),
            confirmText: 'Save',
            cancelText: 'Discard',
          ),
        ) ??
        false;
  }

  void _showSnackBar(String message, IconData icon, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(message),
          ],
        ),
        backgroundColor: Colors.black.withOpacity(0.8),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  TextAlign _getTextAlignment() {
    switch (_selectedFormatIndex) {
      case 0:
        return TextAlign.left;
      case 1:
        return TextAlign.center;
      case 2:
        return TextAlign.right;
      case 3:
        return TextAlign.justify;
      default:
        return TextAlign.left;
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _focusNode.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await _showUnsavedChangesDialog();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF181818),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : _buildContent(),
      ),
    );
  }

  Widget _buildContent() {
    return SafeArea(
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: Stack(
                children: [
                  // Text area behind everything
                  Column(
                    children: [
                      const SizedBox(height: 16), // Add top spacing
                      _buildHeader(),
                      _buildNoteContent(),
                    ],
                  ),
                  // Format selector overlay - only when editing
                  if (_isEditing)
                    Positioned(
                      bottom: 173, // Restored to original
                      left: 0,
                      right: 0,
                      child: _buildFormatSelector(),
                    ),
                  // Bottom actions overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildBottomActions(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ), // Add left/right spacing
      child: _GlassmorphicContainer(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        child: Row(
          children: [
            // Back button
            _GlassmorphicButton(
              icon: Icons.arrow_back_ios,
              onPressed: () async {
                final canPop = await _showUnsavedChangesDialog();
                if (canPop) Navigator.pop(context);
              },
            ),
            const SizedBox(width: 16),
            // Title
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _isEditing ? 'Edit Note' : 'Note Details',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_note != null)
                    Text(
                      _formatDate(_note!.createdAt),
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.6),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            // Action buttons
            if (_hasUnsavedChanges && _isEditing) ...[
              _GlassmorphicButton(
                icon: Icons.save,
                onPressed: _saveNote,
                backgroundColor: Colors.green.withOpacity(0.2),
                borderColor: Colors.green.withOpacity(0.3),
              ),
              const SizedBox(width: 12),
            ],
            _GlassmorphicButton(
              icon: _isEditing ? Icons.close : Icons.edit,
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                  if (_isEditing) {
                    _focusNode.requestFocus();
                  }
                });
              },
            ),
            const SizedBox(width: 12),
            _GlassmorphicButton(
              icon: Icons.delete_outline,
              onPressed: _deleteNote,
              backgroundColor: Colors.red.withOpacity(0.2),
              borderColor: Colors.red.withOpacity(0.3),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNoteContent() {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (!_isEditing) {
            setState(() {
              _isEditing = true;
            });
          }
          FocusScope.of(context).requestFocus(_focusNode);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              24,
              16,
              24,
              120, // Restored to original
            ), // Reduce bottom padding to match format selector position
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: _contentController,
                  focusNode: _focusNode,
                  decoration: InputDecoration(
                    hintText: _isEditing
                        ? 'Start typing your note...'
                        : 'Tap to edit this note...',
                    hintStyle: TextStyle(
                      color: Colors.grey.withOpacity(0.7),
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    errorBorder: InputBorder.none,
                    disabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    height: 1.5,
                  ),
                  maxLines: null,
                  keyboardType: TextInputType.multiline,
                  textCapitalization: TextCapitalization.sentences,
                  cursorColor: Colors.white,
                  textAlign: _getTextAlignment(),
                  readOnly: !_isEditing,
                ),
                const SizedBox(height: 200),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatSelector() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
      child: Center(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
            child: Container(
              width: 180,
              height: 48,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 20,
                    spreadRadius: 0,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Animated indicator
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeInOut,
                    left: _selectedFormatIndex * 43.0 + 4.0,
                    child: Container(
                      width: 39,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.white.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                  // Format buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildFormatButton(Icons.format_align_left, 0),
                      _buildFormatButton(Icons.format_align_center, 1),
                      _buildFormatButton(Icons.format_align_right, 2),
                      _buildFormatButton(Icons.format_align_justify, 3),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFormatButton(IconData icon, int index) {
    final isSelected = _selectedFormatIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedFormatIndex = index;
        });
        _onContentChanged(); // Check for unsaved changes when format changes
      },
      child: SizedBox(
        width: 39,
        height: 36,
        child: Icon(
          icon,
          color: isSelected ? Colors.white : Colors.white60,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildBottomActions() {
    return Container(
      margin: const EdgeInsets.all(24), // Restored to original
      child: Column(
        children: [
          // Character count and save status
          _GlassmorphicContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ), // Restored to original
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome,
                  color: Colors.white.withOpacity(0.6),
                  size: 14, // Restored to original
                ),
                const SizedBox(width: 8), // Restored to original
                Text(
                  _hasUnsavedChanges
                      ? 'Unsaved changes'
                      : 'Last saved ${_formatDate(_note?.createdAt ?? DateTime.now())}',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11, // Restored to original
                  ),
                ),
                const Spacer(),
                Text(
                  '${_contentController.text.length} characters',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.6),
                    fontSize: 11, // Restored to original
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8), // Restored to original
          // Action buttons bar
          _GlassmorphicContainer(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ), // Restored to original
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.auto_fix_high,
                  label: 'Reorganize',
                  onPressed: _reorganizeNote,
                ),
                _buildActionButton(
                  icon: Icons.lightbulb_outline,
                  label: 'Smart Suggest',
                  onPressed: _smartSuggest,
                ),
                _buildActionButton(
                  icon: Icons.task_alt,
                  label: 'Create as a Task',
                  onPressed: _createAsTask,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 14,
                horizontal: 10,
              ), // Restored to original
              margin: const EdgeInsets.symmetric(
                horizontal: 6,
              ), // Restored to original
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    spreadRadius: 0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    icon,
                    color: Colors.white.withOpacity(0.9),
                    size: 20,
                  ), // Restored to original
                  const SizedBox(height: 4), // Restored to original
                  Text(
                    label,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 10, // Restored to original
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _reorganizeNote() {
    _showSnackBar('Reorganizing note...', Icons.auto_fix_high, Colors.blue);
    // TODO: Implement note reorganization logic
  }

  void _smartSuggest() {
    _showSnackBar(
      'Getting smart suggestions...',
      Icons.lightbulb_outline,
      Colors.amber,
    );
    // TODO: Implement smart suggestion logic
  }

  void _createAsTask() {
    _showSnackBar('Creating task from note...', Icons.task_alt, Colors.purple);
    // TODO: Implement create task from note logic
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays}d ago';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

/// Glassmorphic Container Widget
class _GlassmorphicContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;

  const _GlassmorphicContainer({required this.child, this.padding});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Container(
          padding: padding ?? const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.2), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 30,
                spreadRadius: 0,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}

/// Glassmorphic Button Widget
class _GlassmorphicButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? borderColor;

  const _GlassmorphicButton({
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.borderColor,
  }) : size = 40;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
          child: Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              color: backgroundColor ?? Colors.white.withOpacity(0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: borderColor ?? Colors.white.withOpacity(0.25),
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 15,
                  spreadRadius: 0,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, color: Colors.white, size: size * 0.5),
            ),
          ),
        ),
      ),
    );
  }
}

/// Glassmorphic Dialog Widget
class _GlassmorphicDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback onConfirm;
  final VoidCallback onCancel;
  final String confirmText;
  final String cancelText;

  const _GlassmorphicDialog({
    required this.title,
    required this.content,
    required this.onConfirm,
    required this.onCancel,
    this.confirmText = 'Confirm',
    this.cancelText = 'Cancel',
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      child: _GlassmorphicContainer(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              content,
              style: TextStyle(
                color: Colors.white.withOpacity(0.8),
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: onCancel,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.red.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          cancelText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: GestureDetector(
                    onTap: onConfirm,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: Colors.green.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          confirmText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
