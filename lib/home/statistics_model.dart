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

  static Statistics fromJson(response) {
    return Statistics(
      acceptedOrdersToday: response['acceptedOrdersToday'],
      compareYesterdayOrderNum: response['compareYesterdayOrderNum'],
      estimatedIncomeToday: response['estimatedIncomeToday'],
      compareYesterdayIncome: response['compareYesterdayIncome'],
      totalIncomeThisMonth: response['totalIncomeThisMonth'],
      compareLastMonthIncome: response['compareLastMonthIncome'],
      isOrderIncreased: response['isOrderIncreased'],
      isIncomeIncreased: response['isIncomeIncreased'],
      isMonthIncomeIncreased: response['isMonthIncomeIncreased'],
    );
  }

  @override
  String toString() {
    return 'Statistics{acceptedOrdersToday: $acceptedOrdersToday, compareYesterdayOrderNum: $compareYesterdayOrderNum, isOrderIncreased: $isOrderIncreased, estimatedIncomeToday: $estimatedIncomeToday, compareYesterdayIncome: $compareYesterdayIncome, isIncomeIncreased: $isIncomeIncreased, totalIncomeThisMonth: $totalIncomeThisMonth, compareLastMonthIncome: $compareLastMonthIncome, isMonthIncomeIncreased: $isMonthIncomeIncreased}';
  }
}