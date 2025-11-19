class Time {
  /// Constructs an instance of [Time].
  const Time([this.hour = 0, this.minute = 0, this.second = 0])
    : assert(hour >= 0 && hour < 24),
      assert(minute >= 0 && minute < 60),
      assert(second >= 0 && second < 60);

  /// The hour component of the time.
  ///
  /// Accepted range is 0 to 23 inclusive.
  final int hour;

  /// The minutes component of the time.
  ///
  /// Accepted range is 0 to 59 inclusive.
  final int minute;

  /// The seconds component of the time.
  ///
  /// Accepted range is 0 to 59 inclusive.
  final int second;
}
