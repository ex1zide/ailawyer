/// Shared list extensions used across the app.
extension ListExtensions<T> on List<T> {
  /// Returns the last [n] elements of this list.
  /// If the list has fewer than [n] elements, returns the entire list.
  List<T> takeLast(int n) => length > n ? sublist(length - n) : this;
}
