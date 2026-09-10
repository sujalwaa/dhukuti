import 'package:uuid/uuid.dart';
import 'package:dhukuti/data/models/account.dart';
import 'package:dhukuti/data/models/category.dart';
import 'package:dhukuti/data/models/transaction.dart';
import 'package:dhukuti/data/models/income.dart';
import 'package:dhukuti/data/models/goal.dart';
import 'package:dhukuti/data/models/contribution.dart';

/// Sample data matching the design document's inventory.
/// Seeded on first launch for demo purposes.
class SampleData {
  static const _uuid = Uuid();

  // Fixed IDs for cross-referencing
  static const accountNicAsia = 'acc-nic-asia';
  static const accountNabil = 'acc-nabil';
  static const accountCash = 'acc-cash';
  static const accountSavings = 'acc-savings';
  static const accountInvestments = 'acc-investments';

  static const catMandatory = 'cat-mandatory';
  static const catFood = 'cat-food';
  static const catEntertainment = 'cat-entertainment';
  static const catTransport = 'cat-transport';
  static const catHealth = 'cat-health';
  static const catShopping = 'cat-shopping';

  static const goalEmergency = 'goal-emergency';
  static const goalPokhara = 'goal-pokhara';
  static const goalMacbook = 'goal-macbook';
  static const goalMotorbike = 'goal-motorbike';

  /// Generate all sample accounts for a given user ID
  static List<Account> getAccounts(String userId) => [
        Account(
          id: accountNicAsia,
          userId: userId,
          name: 'NIC Asia',
          color: '#FF3B5C',
          icon: 'creditCard',
          balance: 4523500, // रु 45,235.00
        ),
        Account(
          id: accountNabil,
          userId: userId,
          name: 'Nabil Bank',
          color: '#FF8C00',
          icon: 'building',
          balance: 7875200, // रु 78,752.00
        ),
        Account(
          id: accountCash,
          userId: userId,
          name: 'Cash',
          color: '#34C759',
          icon: 'banknote',
          balance: 1248939, // रु 12,489.39
        ),
        Account(
          id: accountSavings,
          userId: userId,
          name: 'Savings',
          color: '#007AFF',
          icon: 'landmark',
          balance: 15568600, // रु 1,55,686.00
        ),
        Account(
          id: accountInvestments,
          userId: userId,
          name: 'Investments',
          color: '#AF52DE',
          icon: 'trendingUp',
          balance: 28513290, // रु 2,85,132.90
        ),
      ];

  /// Generate all sample categories for a given user ID
  static List<Category> getCategories(String userId) => [
        Category(
          id: catMandatory,
          userId: userId,
          name: 'Mandatory',
          icon: 'receipt',
          color: '#FF3B5C',
        ),
        Category(
          id: catFood,
          userId: userId,
          name: 'Food',
          icon: 'utensils',
          color: '#FF8C00',
        ),
        Category(
          id: catEntertainment,
          userId: userId,
          name: 'Entertainment',
          icon: 'gamepad',
          color: '#007AFF',
        ),
        Category(
          id: catTransport,
          userId: userId,
          name: 'Transport',
          icon: 'car',
          color: '#34C759',
        ),
        Category(
          id: catHealth,
          userId: userId,
          name: 'Health',
          icon: 'heart',
          color: '#AF52DE',
        ),
        Category(
          id: catShopping,
          userId: userId,
          name: 'Shopping',
          icon: 'shoppingBag',
          color: '#FF69B4',
        ),
      ];

  /// Generate all sample transactions (expenses) for a given user ID
  /// 23 in April 2026, 3 in March 2026
  static List<Transaction> getTransactions(String userId) => [
        // April 2026 transactions (23)
        Transaction(
          id: 'txn-01',
          userId: userId,
          name: 'Rent - April',
          accountId: accountSavings,
          categoryId: catMandatory,
          amount: -2500000, // -25,000
          date: DateTime(2026, 4, 1, 10, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-02',
          userId: userId,
          name: 'Electricity Bill',
          accountId: accountNicAsia,
          categoryId: catMandatory,
          amount: -185000, // -1,850
          date: DateTime(2026, 4, 2, 14, 30),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-03',
          userId: userId,
          name: 'Bhat Bhateni',
          accountId: accountNicAsia,
          categoryId: catFood,
          amount: -435000, // -4,350
          date: DateTime(2026, 4, 2, 17, 30),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-04',
          userId: userId,
          name: 'Thamel Momo House',
          accountId: accountCash,
          categoryId: catFood,
          amount: -35000, // -350
          date: DateTime(2026, 4, 3, 13, 15),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-05',
          userId: userId,
          name: 'Himalayan Java',
          accountId: accountNicAsia,
          categoryId: catFood,
          amount: -42000, // -420
          date: DateTime(2026, 4, 3, 16, 45),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-06',
          userId: userId,
          name: 'Pizza Hut',
          accountId: accountNabil,
          categoryId: catFood,
          amount: -125000, // -1,250
          date: DateTime(2026, 4, 4, 19, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-07',
          userId: userId,
          name: 'Netflix Subscription',
          accountId: accountNicAsia,
          categoryId: catEntertainment,
          amount: -149900, // -1,499
          date: DateTime(2026, 4, 5, 9, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-08',
          userId: userId,
          name: 'Spotify Premium',
          accountId: accountNicAsia,
          categoryId: catEntertainment,
          amount: -79900, // -799
          date: DateTime(2026, 4, 5, 9, 30),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-09',
          userId: userId,
          name: 'QFX Cinema',
          accountId: accountCash,
          categoryId: catEntertainment,
          amount: -80000, // -800
          date: DateTime(2026, 4, 6, 18, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-10',
          userId: userId,
          name: 'Pathao Ride',
          accountId: accountNicAsia,
          categoryId: catTransport,
          amount: -25000, // -250
          date: DateTime(2026, 4, 7, 8, 30),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-11',
          userId: userId,
          name: 'Pathao Ride',
          accountId: accountNicAsia,
          categoryId: catTransport,
          amount: -31000, // -310
          date: DateTime(2026, 4, 7, 18, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-12',
          userId: userId,
          name: 'Petrol - IOC',
          accountId: accountCash,
          categoryId: catTransport,
          amount: -200000, // -2,000
          date: DateTime(2026, 4, 8, 11, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-13',
          userId: userId,
          name: 'Bus Pass Monthly',
          accountId: accountCash,
          categoryId: catTransport,
          amount: -350000, // -3,500
          date: DateTime(2026, 4, 8, 12, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-14',
          userId: userId,
          name: 'Gym Membership',
          accountId: accountNabil,
          categoryId: catHealth,
          amount: -400000, // -4,000
          date: DateTime(2026, 4, 9, 7, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-15',
          userId: userId,
          name: 'Dental Checkup',
          accountId: accountNicAsia,
          categoryId: catHealth,
          amount: -150000, // -1,500
          date: DateTime(2026, 4, 9, 14, 30),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-16',
          userId: userId,
          name: 'Daraz Order',
          accountId: accountNicAsia,
          categoryId: catShopping,
          amount: -289000, // -2,890
          date: DateTime(2026, 4, 10, 20, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-17',
          userId: userId,
          name: 'Civil Mall Shopping',
          accountId: accountNabil,
          categoryId: catShopping,
          amount: -450000, // -4,500
          date: DateTime(2026, 4, 11, 15, 30),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-18',
          userId: userId,
          name: 'Water Bill',
          accountId: accountNicAsia,
          categoryId: catMandatory,
          amount: -80000, // -800
          date: DateTime(2026, 4, 11, 10, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-19',
          userId: userId,
          name: 'Internet - Vianet',
          accountId: accountNicAsia,
          categoryId: catMandatory,
          amount: -135000, // -1,350
          date: DateTime(2026, 4, 12, 9, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-20',
          userId: userId,
          name: 'Grocery - Salesberry',
          accountId: accountNabil,
          categoryId: catFood,
          amount: -320000, // -3,200
          date: DateTime(2026, 4, 12, 17, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-21',
          userId: userId,
          name: 'Pharmacy',
          accountId: accountCash,
          categoryId: catHealth,
          amount: -65000, // -650
          date: DateTime(2026, 4, 13, 11, 30),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-22',
          userId: userId,
          name: 'Bakery Cafe',
          accountId: accountCash,
          categoryId: catFood,
          amount: -28000, // -280
          date: DateTime(2026, 4, 14, 10, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-23',
          userId: userId,
          name: 'Mobile Recharge',
          accountId: accountNicAsia,
          categoryId: catMandatory,
          amount: -50000, // -500
          date: DateTime(2026, 4, 15, 8, 0),
          source: 'manual',
        ),
        // March 2026 transactions (3)
        Transaction(
          id: 'txn-24',
          userId: userId,
          name: 'Rent - March',
          accountId: accountSavings,
          categoryId: catMandatory,
          amount: -2500000, // -25,000
          date: DateTime(2026, 3, 1, 10, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-25',
          userId: userId,
          name: 'Bhat Bhateni Monthly',
          accountId: accountNicAsia,
          categoryId: catFood,
          amount: -580000, // -5,800
          date: DateTime(2026, 3, 15, 16, 0),
          source: 'manual',
        ),
        Transaction(
          id: 'txn-26',
          userId: userId,
          name: 'Electricity - March',
          accountId: accountNicAsia,
          categoryId: catMandatory,
          amount: -195000, // -1,950
          date: DateTime(2026, 3, 20, 11, 0),
          source: 'manual',
        ),
      ];

  /// Generate all sample incomes for a given user ID
  static List<Income> getIncomes(String userId) => [
        // April 2026 (4)
        Income(
          id: 'inc-01',
          userId: userId,
          name: 'Salary - April',
          accountId: accountNabil,
          amount: 7500000, // 75,000
          date: DateTime(2026, 4, 1, 9, 0),
        ),
        Income(
          id: 'inc-02',
          userId: userId,
          name: 'Freelance Project',
          accountId: accountNicAsia,
          amount: 2500000, // 25,000
          date: DateTime(2026, 4, 5, 15, 0),
        ),
        Income(
          id: 'inc-03',
          userId: userId,
          name: 'Investment Return',
          accountId: accountInvestments,
          amount: 850000, // 8,500
          date: DateTime(2026, 4, 10, 12, 0),
        ),
        Income(
          id: 'inc-04',
          userId: userId,
          name: 'Side Gig',
          accountId: accountCash,
          amount: 450000, // 4,500
          date: DateTime(2026, 4, 12, 14, 0),
        ),
        // March 2026 (1)
        Income(
          id: 'inc-05',
          userId: userId,
          name: 'Salary - March',
          accountId: accountNabil,
          amount: 7500000, // 75,000
          date: DateTime(2026, 3, 1, 9, 0),
        ),
      ];

  /// Generate all sample goals for a given user ID
  static List<Goal> getGoals(String userId) => [
        Goal(
          id: goalEmergency,
          userId: userId,
          name: 'Emergency Fund',
          target: 10000000, // 1,00,000
          icon: 'shield',
          color: '#FF3B5C',
          sourceAccountId: accountSavings,
          balance: 7500000, // 75,000
          autoEnabled: true,
          autoAmount: 1000000, // 10,000
          autoDayOfMonth: 5,
        ),
        Goal(
          id: goalPokhara,
          userId: userId,
          name: 'Trip to Pokhara',
          target: 5000000, // 50,000
          icon: 'airplane',
          color: '#007AFF',
          sourceAccountId: accountNicAsia,
          balance: 3200000, // 32,000
          autoEnabled: false,
          autoAmount: 0,
          autoDayOfMonth: 1,
        ),
        Goal(
          id: goalMacbook,
          userId: userId,
          name: 'MacBook Pro',
          target: 35000000, // 3,50,000
          icon: 'laptop',
          color: '#AF52DE',
          sourceAccountId: accountNabil,
          balance: 18000000, // 1,80,000
          autoEnabled: true,
          autoAmount: 2000000, // 20,000
          autoDayOfMonth: 10,
        ),
        Goal(
          id: goalMotorbike,
          userId: userId,
          name: 'Motorbike',
          target: 45000000, // 4,50,000
          icon: 'car',
          color: '#34C759',
          sourceAccountId: accountSavings,
          balance: 12000000, // 1,20,000
          autoEnabled: false,
          autoAmount: 0,
          autoDayOfMonth: 1,
        ),
      ];

  /// Generate sample contribution histories for goals
  static List<Contribution> getContributions() => [
        // Emergency Fund contributions
        Contribution(
          id: 'contrib-01',
          goalId: goalEmergency,
          type: 'contribute',
          amount: 2500000, // 25,000
          date: DateTime(2026, 1, 5, 10, 0),
          note: 'Initial deposit',
        ),
        Contribution(
          id: 'contrib-02',
          goalId: goalEmergency,
          type: 'contribute',
          amount: 1000000, // 10,000
          date: DateTime(2026, 2, 5, 10, 0),
          note: 'Monthly auto-contribute',
        ),
        Contribution(
          id: 'contrib-03',
          goalId: goalEmergency,
          type: 'contribute',
          amount: 1000000,
          date: DateTime(2026, 3, 5, 10, 0),
          note: 'Monthly auto-contribute',
        ),
        Contribution(
          id: 'contrib-04',
          goalId: goalEmergency,
          type: 'contribute',
          amount: 1500000, // 15,000
          date: DateTime(2026, 3, 15, 14, 0),
          note: 'Extra from bonus',
        ),
        Contribution(
          id: 'contrib-05',
          goalId: goalEmergency,
          type: 'contribute',
          amount: 1000000,
          date: DateTime(2026, 4, 5, 10, 0),
          note: 'Monthly auto-contribute',
        ),
        Contribution(
          id: 'contrib-06',
          goalId: goalEmergency,
          type: 'withdraw',
          amount: 500000, // 5,000
          date: DateTime(2026, 4, 8, 16, 0),
          note: 'Medical emergency',
        ),

        // Trip to Pokhara contributions
        Contribution(
          id: 'contrib-07',
          goalId: goalPokhara,
          type: 'contribute',
          amount: 2000000, // 20,000
          date: DateTime(2026, 2, 10, 12, 0),
          note: 'Starting the trip fund',
        ),
        Contribution(
          id: 'contrib-08',
          goalId: goalPokhara,
          type: 'contribute',
          amount: 1200000, // 12,000
          date: DateTime(2026, 3, 20, 11, 0),
          note: 'Saved from freelance',
        ),

        // MacBook Pro contributions
        Contribution(
          id: 'contrib-09',
          goalId: goalMacbook,
          type: 'contribute',
          amount: 5000000, // 50,000
          date: DateTime(2026, 1, 10, 10, 0),
          note: 'Initial savings',
        ),
        Contribution(
          id: 'contrib-10',
          goalId: goalMacbook,
          type: 'contribute',
          amount: 2000000,
          date: DateTime(2026, 2, 10, 10, 0),
          note: 'Monthly auto-contribute',
        ),
        Contribution(
          id: 'contrib-11',
          goalId: goalMacbook,
          type: 'contribute',
          amount: 2000000,
          date: DateTime(2026, 3, 10, 10, 0),
          note: 'Monthly auto-contribute',
        ),
        Contribution(
          id: 'contrib-12',
          goalId: goalMacbook,
          type: 'contribute',
          amount: 7000000, // 70,000
          date: DateTime(2026, 3, 25, 15, 0),
          note: 'Tax refund boost',
        ),
        Contribution(
          id: 'contrib-13',
          goalId: goalMacbook,
          type: 'contribute',
          amount: 2000000,
          date: DateTime(2026, 4, 10, 10, 0),
          note: 'Monthly auto-contribute',
        ),

        // Motorbike contributions
        Contribution(
          id: 'contrib-14',
          goalId: goalMotorbike,
          type: 'contribute',
          amount: 5000000, // 50,000
          date: DateTime(2026, 1, 15, 10, 0),
          note: 'Starting motorbike fund',
        ),
        Contribution(
          id: 'contrib-15',
          goalId: goalMotorbike,
          type: 'contribute',
          amount: 5000000,
          date: DateTime(2026, 2, 15, 10, 0),
          note: 'Added more',
        ),
        Contribution(
          id: 'contrib-16',
          goalId: goalMotorbike,
          type: 'contribute',
          amount: 2000000, // 20,000
          date: DateTime(2026, 3, 15, 10, 0),
          note: 'Saved from side gig',
        ),
      ];

  /// Seed all sample data into the database for a new user
  static Future<void> seedAll({
    required String userId,
    required Future<void> Function(Account) insertAccount,
    required Future<void> Function(Category) insertCategory,
    required Future<void> Function(Transaction) insertTransaction,
    required Future<void> Function(Income) insertIncome,
    required Future<void> Function(Goal) insertGoal,
    required Future<void> Function(Contribution) insertContribution,
  }) async {
    // Insert accounts
    for (final account in getAccounts(userId)) {
      await insertAccount(account);
    }

    // Insert categories
    for (final category in getCategories(userId)) {
      await insertCategory(category);
    }

    // Insert transactions
    for (final transaction in getTransactions(userId)) {
      await insertTransaction(transaction);
    }

    // Insert incomes
    for (final income in getIncomes(userId)) {
      await insertIncome(income);
    }

    // Insert goals
    for (final goal in getGoals(userId)) {
      await insertGoal(goal);
    }

    // Insert contributions
    for (final contribution in getContributions()) {
      await insertContribution(contribution);
    }
  }
}
