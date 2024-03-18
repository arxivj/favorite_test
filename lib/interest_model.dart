class Interest {
  final String ticker;

  Interest({required this.ticker});

  factory Interest.fromJson(String ticker) {
    return Interest(ticker: ticker);
  }
}
