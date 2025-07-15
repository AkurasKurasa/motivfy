import 'package:flutter/material.dart';
import 'package:motiv_fy/core/widgets/action_button.dart';
import 'package:motiv_fy/core/widgets/glassmorphic_button.dart';
import 'package:motiv_fy/core/widgets/ui_format_selector_with_indicator.dart';
import 'package:motiv_fy/features/noteflow/data/services/note_flow_service.dart';
import 'package:motiv_fy/features/noteflow/data/services/note_service.dart';

/// Represents the content page for note flow.
class NoteFlowContentPage extends StatefulWidget {
  const NoteFlowContentPage({super.key});

  @override
  State<NoteFlowContentPage> createState() => _NoteFlowContentPageState();
}

class _NoteFlowContentPageState extends State<NoteFlowContentPage> {
  int _selectedFormatIndex = 0;
  final TextEditingController _textController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final NoteFlowService _noteFlowService = NoteFlowService();
  final NoteService _noteService = NoteService();
  bool _isSaving = false;

  final GlobalKey _animationTargetKey = GlobalKey();

  /// Get the text alignment based on the selected format index.
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
  void initState() {
    super.initState();
    // Restore saved text and alignment when page initializes
    _textController.text = _noteFlowService.noteText;
    _selectedFormatIndex = _noteFlowService.textAlignment;

    // Add listener to save text when it changes
    _textController.addListener(() {
      _noteFlowService.saveState(
        text: _textController.text,
        alignment: _selectedFormatIndex,
      );
    });
  }

  /// Save the current note to the note service.
  void _saveNote() async {
    if (_textController.text.trim().isEmpty) {
      // Don't save empty notes
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cannot save empty note'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() {
      _isSaving = true;
    });

    try {
      // Create a temporary container with the note text for animation
      final RenderBox renderBox = context.findRenderObject() as RenderBox;
      final screenSize = MediaQuery.of(context).size;
      final noteTextWidget = Material(
        elevation: 8.0,
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade800,
        shadowColor: Colors.black.withOpacity(0.5),
        child: Container(
          width: screenSize.width * 0.8,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10, width: 1),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _textController.text,
                style: const TextStyle(color: Colors.white, fontSize: 16),
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(
                  'Just now',
                  style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      );

      // Define a late variable to hold the overlay entry
      late OverlayEntry overlayEntry;

      // Function to complete the save process after animation
      void completeNoteSave() async {
        // Remove the overlay
        overlayEntry.remove();

        // Add note to the note service
        await _noteService.addNote(_textController.text);

        // Clear the text area
        if (mounted) {
          setState(() {
            _textController.clear();
            _isSaving = false;
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Note saved successfully'),
              duration: Duration(seconds: 2),
            ),
          );
        }
      }

      // Create the animation overlay
      overlayEntry = OverlayEntry(
        builder: (context) {
          return Stack(
            children: [
              // Note container with pop animation and movement to top left corner
              TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.0, end: 1.0),
                duration: const Duration(milliseconds: 850),
                curve: Curves.easeOutQuint,
                builder: (context, value, child) {
                  // Multi-stage animation based on progress value
                  double scale;
                  double opacity;
                  Offset position;

                  if (value < 0.12) {
                    // Stage 1: Pop out (expand)
                    final expandProgress = value / 0.12;
                    scale = 1.0 + (0.2 * expandProgress);
                    opacity = 1.0;
                    position = Offset(
                      renderBox.size.width * 0.5,
                      renderBox.size.height * 0.4,
                    );
                  } else if (value < 0.22) {
                    // Stage 2: Pop in (contract)
                    final contractProgress = (value - 0.12) / 0.1;
                    scale = 1.2 - (0.1 * contractProgress);
                    opacity = 1.0;
                    position = Offset(
                      renderBox.size.width * 0.5,
                      renderBox.size.height * 0.4,
                    );
                  } else {
                    // Stage 3: Move to top left corner
                    final moveProgress = (value - 0.22) / 0.78;

                    final startPos = Offset(
                      renderBox.size.width * 0.5,
                      renderBox.size.height * 0.4,
                    );

                    final RenderBox? targetBox =
                        _animationTargetKey.currentContext?.findRenderObject()
                            as RenderBox?;
                    final targetPos = targetBox != null
                        ? targetBox.localToGlobal(Offset.zero)
                        : const Offset(40, 80);

                    final endPos = targetPos;
                    final controlPoint = Offset(
                      startPos.dx * 0.3,
                      startPos.dy - 150,
                    );

                    final t = moveProgress;
                    final mt = 1 - t;
                    position = Offset(
                      mt * mt * startPos.dx +
                          2 * mt * t * controlPoint.dx +
                          t * t * endPos.dx,
                      mt * mt * startPos.dy +
                          2 * mt * t * controlPoint.dy +
                          t * t * endPos.dy,
                    );

                    scale = 1.1 - (0.9 * moveProgress);
                    opacity = 1.0 - (moveProgress * 0.9);
                  }

                  return Positioned(
                    left: position.dx,
                    top: position.dy,
                    child: AnimatedOpacity(
                      opacity: opacity,
                      duration: Duration.zero,
                      child: Transform.scale(scale: scale, child: child),
                    ),
                  );
                },
                child: noteTextWidget,
                onEnd: completeNoteSave,
              ),
            ],
          );
        },
      );

      // Add the overlay
      Overlay.of(context).insert(overlayEntry);
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error saving note: $e'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  @override
  void dispose() {
    // Make sure we save state before disposing
    _noteFlowService.saveState(
      text: _textController.text,
      alignment: _selectedFormatIndex,
    );
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).requestFocus(_focusNode);
      },
      child: Stack(
        children: [
          // Invisible marker for animation target
          Positioned(
            top: 10,
            left: 40,
            child: SizedBox(key: _animationTargetKey, width: 1, height: 1),
          ),
          Positioned.fill(
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(21, 16, 21, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    TextField(
                      controller: _textController,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Start typing here...',
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
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      textCapitalization: TextCapitalization.sentences,
                      cursorColor: Colors.white,
                      autofocus: true,
                      textAlign: _getTextAlignment(),
                    ),
                    const SizedBox(height: 200),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.0),
                        Colors.black.withOpacity(0.9),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 16.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Align(
                                alignment: Alignment.center,
                                child: FormatSelectorWithIndicator(
                                  selectedFormatIndex: _selectedFormatIndex,
                                  onFormatSelected: (index) {
                                    setState(() {
                                      _selectedFormatIndex = index;
                                      _noteFlowService.saveState(
                                        text: _textController.text,
                                        alignment: index,
                                      );

                                      final currentText = _textController.text;
                                      _textController.text = currentText;

                                      _textController.selection =
                                          TextSelection.fromPosition(
                                            TextPosition(
                                              offset: currentText.length,
                                            ),
                                          );
                                    });
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GlassmorphicButton(
                              icon: _isSaving
                                  ? Icons.hourglass_empty
                                  : Icons.check,
                              onPressed: _isSaving ? () {} : () => _saveNote(),
                              size: 48,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade900,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ActionButton(
                              icon: Icons.autorenew,
                              label: 'Reorganize',
                            ),
                            ActionButton(
                              icon: Icons.lightbulb_outline,
                              label: 'Smart Suggest',
                            ),
                            ActionButton(
                              icon: Icons.add_task,
                              label: 'Create as a Task',
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
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
}
