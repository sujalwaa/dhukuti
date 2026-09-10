import '../../core/theme/app_typography.dart';
import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_spacing.dart';

/// A reusable bottom sheet wrapper with blur backdrop.
class BottomSheetWrapper extends StatelessWidget {
  final Widget child;
  final String? title;
  
  const BottomSheetWrapper({super.key, required this.child, this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Container(
          color: const Color.fromRGBO(0, 0, 0, 0.4),
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {}, // Prevent tap from dismissing
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.8,
              ),
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(AppRadii.bottomSheet),
                  ),
                ),
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadii.bottomSheet),
                  ),
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.only(
                      left: AppSpacing.bottomSheetPaddingSide,
                      right: AppSpacing.bottomSheetPaddingSide,
                      top: 24, // Assuming some top padding
                      bottom: AppSpacing.bottomSheetPaddingBottom,
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, mainAxisSize: MainAxisSize.min, children: [if (title != null) Padding(padding: const EdgeInsets.only(bottom: 16.0), child: Text(title!, style: AppTypography.pageTitle, textAlign: TextAlign.center)), child]),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper method to show this bottom sheet wrapper
Future<T?> showCustomBottomSheet<T>(BuildContext context, WidgetBuilder builder) {
  return showGeneralDialog<T>(
    context: context,
    pageBuilder: (context, animation, secondaryAnimation) => BottomSheetWrapper(child: builder(context)),
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    transitionDuration: const Duration(milliseconds: 250),
    transitionBuilder: (context, animation, secondaryAnimation, child) {
      return SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 1),
          end: Offset.zero,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut)),
        child: child,
      );
    },
  );
}
