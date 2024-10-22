class Statistics {
  final int acceptedOrdersToday;
  final int compareYesterdayOrderNum;
  final bool isOrderIncreased;
  final double estimatedIncomeToday;
  final double compareYesterdayIncome;
  final bool isIncomeIncreased;
  final double totalIncomeThisMonth;
  final double compareLastMonthIncome;
  final bool isMonthIncomeIncreased;

  Statistics({
    required this.acceptedOrdersToday,
    required this.compareYesterdayOrderNum,
    required this.estimatedIncomeToday,
    required this.compareYesterdayIncome,
    required this.totalIncomeThisMonth,
    required this.compareLastMonthIncome,
    required this.isOrderIncreased,
    required this.isIncomeIncreased,
    required this.isMonthIncomeIncreased,
  });
}