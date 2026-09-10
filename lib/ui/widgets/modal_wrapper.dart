import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_typography.dart';
import '../../core/theme/app_spacing.dart';

/// Full-screen modal wrapper with slide up animation.
class ModalWrapper extends StatefulWidget {
  final String title;
  final Widget child;
  final Widget? rightIcon;

  const ModalWrapper({
    super.key,
    required this.title,
    required this.child,
    this.rightIcon,
  });

  @override
  State<ModalWrapper> createState() => _ModalWrapperState();
}

class _ModalWrapperState extends State<ModalWrapper> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _close() {
    _controller.reverse().then((_) {
      Navigator.of(context).pop();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: Scaffold(
        
        body: SafeArea(
          child: Column(
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.only(
                  top: AppSpacing.modalPaddingTop,
                  left: AppSpacing.modalPaddingSide,
                  right: AppSpacing.modalPaddingSide,
                  bottom: 16,
                ),
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(PhosphorIcons.caretLeft()),
                      onPressed: _close,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                    Expanded(
                      child: Text(
                        widget.title,
                        textAlign: TextAlign.center,
                        style: AppTypography.modalTitle,
                      ),
                    ),
                    if (widget.rightIcon != null)
                      widget.rightIcon!
                    else
                      const SizedBox(width: 24), // Balance the flex
                  ],
                ),
              ),
              // Content
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(
                    bottom: AppSpacing.modalPaddingBottom,
                  ),
                  child: widget.child,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
