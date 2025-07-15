import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import 'glassmorphic_container.dart';

class ChatInputBar extends StatefulWidget {
  final TextEditingController controller;
  final bool isLoading;
  final VoidCallback onSend;
  final bool autoFocus;

  const ChatInputBar({
    super.key,
    required this.controller,
    required this.isLoading,
    required this.onSend,
    this.autoFocus = false,
  });

  @override
  State<ChatInputBar> createState() => _ChatInputBarState();
}

class _ChatInputBarState extends State<ChatInputBar>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _pulseController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _pulseAnimation;
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();

    // Main focus animation controller
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    // Pulse animation for send button
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.03).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutCubic),
    );

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.1).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });

    // Auto focus when page loads
    if (widget.autoFocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _pulseController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 650),
                child: GlassmorphicContainer(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  opacity: 0.18,
                  blur: 25,
                  borderColor: AppColors.white.withOpacity(0.35),
                  borderWidth: 1.2,
                  child: Row(
                    crossAxisAlignment:
                        CrossAxisAlignment.center, // Fixed alignment to center
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text input
                      Expanded(
                        child: Container(
                          constraints: const BoxConstraints(
                            minHeight: 54,
                            maxHeight: 140,
                          ),
                          child: TextField(
                            controller: widget.controller,
                            focusNode: _focusNode,
                            maxLines: null,
                            style: AppTextStyles.body16Regular.copyWith(
                              color: AppColors.white,
                              fontWeight: FontWeight.w500,
                              height: 1.4,
                            ),
                            decoration: InputDecoration(
                              hintText: "Ask Motiv-fy Assistant...",
                              hintStyle: AppTextStyles.body16Regular.copyWith(
                                color: AppColors.white.withOpacity(0.65),
                                fontWeight: FontWeight.w400,
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 24,
                                vertical: 18,
                              ),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Send button with enhanced animations
                      AnimatedBuilder(
                        animation: _pulseController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: widget.isLoading
                                ? 1.0
                                : _pulseAnimation.value,
                            child: Container(
                              width: 52,
                              height: 52,
                              alignment: Alignment.center, // Fixed alignment
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: widget.isLoading
                                    ? LinearGradient(
                                        colors: [
                                          AppColors.white.withOpacity(0.15),
                                          AppColors.white.withOpacity(0.05),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      )
                                    : LinearGradient(
                                        colors: [
                                          AppColors.white.withOpacity(0.25),
                                          AppColors.white.withOpacity(0.08),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                border: Border.all(
                                  color: AppColors.white.withOpacity(0.35),
                                  width: 1.5,
                                ),
                                boxShadow: widget.isLoading
                                    ? []
                                    : [
                                        BoxShadow(
                                          color: AppColors.primaryYellow
                                              .withOpacity(0.15),
                                          blurRadius: 10,
                                          spreadRadius: 2,
                                        ),
                                      ],
                              ),
                              child: Material(
                                color: Colors.transparent,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(26),
                                  onTap: widget.isLoading
                                      ? null
                                      : () {
                                          _pulseController.forward().then((_) {
                                            _pulseController.reverse();
                                          });
                                          widget.onSend();
                                        },
                                  child: Container(
                                    width: 52,
                                    height: 52,
                                    alignment: Alignment.center,
                                    child: widget.isLoading
                                        ? SizedBox(
                                            width: 22,
                                            height: 22,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2.5,
                                              color: AppColors.white
                                                  .withOpacity(0.8),
                                              strokeCap: StrokeCap.round,
                                            ),
                                          )
                                        : Icon(
                                            Icons.arrow_upward_rounded,
                                            color: AppColors.white,
                                            size: 26,
                                          ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
