import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_shadows.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/providers/account_provider.dart';
import '../../../core/providers/goal_provider.dart';
import '../../../core/providers/privacy_provider.dart';
import '../../../core/providers/transaction_provider.dart';
import '../../../core/utils/formatters.dart';
import '../../widgets/amount_display.dart';
import '../../widgets/icon_render.dart';
import '../../widgets/sparkline.dart';
import '../../widgets/sources_bar.dart';
import 'capital_sheet.dart';

class OverviewTab extends ConsumerStatefulWidget {
  const OverviewTab({super.key});

  @override
  ConsumerState<OverviewTab> createState() => _OverviewTabState();
}

class _OverviewTabState extends ConsumerState<OverviewTab> {
  final PageController _pageController = PageController(viewportFraction: 0.9);
  int _currentAccountIndex = 0;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _openCapitalSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      
      builder: (context) => const CapitalSheet(),
    );
  }

  void _openAddMoneySheet(String accountId) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      
      builder: (context) => AddMoneySheet(accountId: accountId),
    );
  }

  @override
  Widget build(BuildContext context) {
    final totalCapital = ref.watch(totalCapitalProvider);
    final totalSaved = ref.watch(totalSavedProvider);
    final accounts = ref.watch(accountsProvider);
    final goals = ref.watch(goalsProvider);
    final isHidden = ref.watch(hideBalanceProvider);
    final transactions = ref.watch(searchedTransactionsProvider(_searchQuery));

    return Scaffold(
      
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 1. Header row
              Padding(
                padding: const EdgeInsets.only(left: 20, right: 20, top: 12, bottom: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: [Color(0xFFFFD6A0), Color(0xFFFFAB6B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Icon(
                            PhosphorIcons.user(),
                            size: 18,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Good evening,',
                                style: AppTypography.bodySmall.copyWith(color: AppColors.textLabel)),
                            Text('User', style: AppTypography.body.copyWith(fontWeight: FontWeight.w600, fontSize: 15)),
                          ],
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // Navigate to settings
                      },
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: AppColors.border, width: 1),
                        ),
                        child: Icon(
                          PhosphorIcons.gear(),
                          size: 16,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Total Capital Hero Card
              GestureDetector(
                onTap: _openCapitalSheet,
                child: Container(
                  margin: const EdgeInsets.only(left: 20, right: 20, bottom: 28),
                  padding: const EdgeInsets.all(AppSpacing.cardPaddingHero),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(AppRadii.heroCard),
                    gradient: const LinearGradient(
                      colors: [AppColors.heroGradientStart, AppColors.heroGradientMid, AppColors.heroGradientEnd],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: AppShadows.heroCard,
                  ),
                  child: Stack(
                    children: [
                      // Glow effects
                      Positioned(
                        top: -20,
                        right: -20,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: AppColors.heroPurpleGlow, blurRadius: 50, spreadRadius: 20),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -20,
                        left: -20,
                        child: Container(
                          width: 100,
                          height: 100,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(color: AppColors.heroBlueGlow, blurRadius: 50, spreadRadius: 20),
                            ],
                          ),
                        ),
                      ),
                      // Content
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Icon(PhosphorIcons.sparkle(), size: 14, color: Colors.white60),
                                  const SizedBox(width: 6),
                                  Text(
                                    'TOTAL CAPITAL',
                                    style: AppTypography.sectionLabelUpper.copyWith(color: Colors.white60),
                                  ),
                                ],
                              ),
                              GestureDetector(
                                onTap: () => ref.read(hideBalanceProvider.notifier).state = !isHidden,
                                child: Container(
                                  width: 30,
                                  height: 30,
                                  decoration: const BoxDecoration(shape: BoxShape.circle),
                                  child: Icon(
                                    isHidden ? PhosphorIcons.eyeClosed() : PhosphorIcons.eye(),
                                    size: 16,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              AmountDisplay(
                                paisa: totalCapital,
                                size: AmountSize.hero,
                                isHidden: isHidden,
                              ),
                              const Spacer(),
                              const Sparkline(),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text('This month', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
                              const SizedBox(width: 4),
                              Icon(PhosphorIcons.arrowUpRight(), size: 12, color: AppColors.success),
                              const SizedBox(width: 2),
                              Text('+6.3%', style: AppTypography.bodySmall.copyWith(color: AppColors.success)),
                              const SizedBox(width: 8),
                              Container(width: 1, height: 12, color: Colors.white24),
                              const SizedBox(width: 8),
                              Text('In goals', style: AppTypography.bodySmall.copyWith(color: Colors.white60)),
                              const SizedBox(width: 4),
                              AmountDisplay(
                                paisa: totalSaved,
                                size: AmountSize.transaction,
                                isHidden: isHidden,
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Container(height: 1, color: Colors.white12),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              Text(
                                '${accounts.length} accounts · ${goals.length} goals',
                                style: AppTypography.bodySmall.copyWith(color: Colors.white70),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          SourcesBar(
                            height: 4,
                            segments: accounts.map((a) {
                              return SourceSegment(
                                amount: a.balance.toDouble(),
                                color: Color(int.parse(a.color.replaceAll('#', '0xFF'))),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // 3. Accounts section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Accounts', style: AppTypography.sectionLabel),
                    Text('${_currentAccountIndex + 1} of ${accounts.length}', style: AppTypography.sectionLabelUpper),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // 4. Swipeable Account Cards
              if (accounts.isNotEmpty)
                SizedBox(
                  height: 160,
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (idx) {
                      setState(() {
                        _currentAccountIndex = idx;
                      });
                    },
                    itemCount: accounts.length,
                    itemBuilder: (context, index) {
                      final account = accounts[index];
                      final bgColor = Color(int.parse(account.color.replaceAll('#', '0xFF')));
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 5),
                        padding: const EdgeInsets.all(AppSpacing.cardPaddingAccount),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(AppRadii.accountCard),
                          color: bgColor,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(8),
                                      decoration: BoxDecoration(
                                        color: Colors.white24,
                                        borderRadius: BorderRadius.circular(AppRadii.accountIcon),
                                      ),
                                      child: IconRender(
                                        name: account.icon,
                                        size: 20,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Text(
                                      account.name,
                                      style: AppTypography.body.copyWith(color: Colors.white, fontWeight: FontWeight.w600),
                                    ),
                                  ],
                                ),
                                Icon(PhosphorIcons.dotsThree(), color: Colors.white),
                              ],
                            ),
                            const Spacer(),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                AmountDisplay(
                                  paisa: account.balance,
                                  size: AmountSize.card,
                                  isHidden: isHidden,
                                ),
                                GestureDetector(
                                  onTap: () => _openAddMoneySheet(account.id),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.white24,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Text('Add money', style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.w600)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

              // 5. Pagination dots
              if (accounts.length > 1)
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(accounts.length, (index) {
                      final isActive = index == _currentAccountIndex;
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2.5),
                        width: isActive ? 16 : 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: isActive ? AppColors.textSecondary : AppColors.border,
                          borderRadius: BorderRadius.circular(AppRadii.paginationDot),
                        ),
                      );
                    }),
                  ),
                ),

              const SizedBox(height: 32),

              // 6. Recent Transactions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Recent transactions', style: AppTypography.sectionLabel),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: AppColors.mutedSurface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(PhosphorIcons.magnifyingGlass(), size: 16, color: AppColors.textPlaceholder),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val;
                                });
                              },
                              decoration: InputDecoration(
                                hintText: 'Search transactions...',
                                hintStyle: AppTypography.body.copyWith(color: AppColors.textPlaceholder),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              child: Icon(PhosphorIcons.x(), size: 16, color: AppColors.textTertiary),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (transactions.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(32.0),
                          child: Text(
                            'No transactions found.',
                            style: AppTypography.bodySmall.copyWith(color: AppColors.textMuted),
                          ),
                        ),
                      )
                    else
                      ...transactions.take(10).map((t) {
                        // Assuming account name and color are accessible or we just use dummy
                        // Let's find account
                        final account = accounts.firstWhere((a) => a.id == t.accountId, orElse: () => accounts.first);
                        final accountColor = Color(int.parse(account.color.replaceAll('#', '0xFF')));

                        return Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Row(
                                children: [
                                  Container(
                                    width: 38,
                                    height: 38,
                                    decoration: BoxDecoration(
                                      color: AppColors.mutedSurface,
                                      borderRadius: BorderRadius.circular(AppRadii.iconTile),
                                    ),
                                    child: Center(
                                      child: IconRender(
                                        name: t.categoryId, // Fallback icon name, maybe mapping needed
                                        size: 20,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(t.name, style: AppTypography.transactionName),
                                            const SizedBox(width: 8),
                                            Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: accountColor.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                account.name.toUpperCase(),
                                                style: AppTypography.accountTag.copyWith(color: accountColor),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          formatDate(t.date.toIso8601String()),
                                          style: AppTypography.timestamp,
                                        ),
                                      ],
                                    ),
                                  ),
                                  AmountDisplay(
                                    paisa: t.amount,
                                    size: AmountSize.transaction,
                                    isHidden: isHidden,
                                  ),
                                ],
                              ),
                            ),
                            const Divider(height: 1, color: AppColors.lightDivider),
                          ],
                        );
                      }).toList(),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.scrollBottomPadding),
            ],
          ),
        ),
      ),
    );
  }
}

class AddMoneySheet extends StatefulWidget {
  final String accountId;
  const AddMoneySheet({super.key, required this.accountId});

  @override
  State<AddMoneySheet> createState() => _AddMoneySheetState();
}

class _AddMoneySheetState extends State<AddMoneySheet> {
  String _amount = '0';

  void _onKeyPress(String key) {
    setState(() {
      if (key == 'backspace') {
        if (_amount.length > 1) {
          _amount = _amount.substring(0, _amount.length - 1);
        } else {
          _amount = '0';
        }
      } else {
        if (_amount == '0') {
          _amount = key;
        } else {
          _amount += key;
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(
        top: 24,
        left: AppSpacing.bottomSheetPaddingSide,
        right: AppSpacing.bottomSheetPaddingSide,
        bottom: AppSpacing.bottomSheetPaddingBottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadii.bottomSheet)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(width: 40, height: 4, decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(2))),
          const SizedBox(height: 24),
          const Text('Add Money', style: AppTypography.modalTitle),
          const SizedBox(height: 32),
          Text(
            'रु $_amount',
            style: AppTypography.numpadAmount,
          ),
          const SizedBox(height: 32),
          _buildNumpad(),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
              child: const Text('Add Money', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNumpad() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: 12,
      itemBuilder: (context, index) {
        if (index == 9) return const SizedBox.shrink();
        if (index == 11) {
          return GestureDetector(
            onTap: () => _onKeyPress('backspace'),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.numpadKey,
                borderRadius: BorderRadius.circular(AppRadii.numpadKey),
              ),
              child: Icon(PhosphorIcons.backspace(), color: AppColors.textPrimary),
            ),
          );
        }
        final number = index == 10 ? '0' : '${index + 1}';
        return GestureDetector(
          onTap: () => _onKeyPress(number),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.numpadKey,
              borderRadius: BorderRadius.circular(AppRadii.numpadKey),
            ),
            alignment: Alignment.center,
            child: Text(number, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
          ),
        );
      },
    );
  }
}
